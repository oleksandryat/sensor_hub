import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../../../domain/connection_manager.dart';
import '../../../../domain/connection_status.dart';
import '../../../../domain/phone_telemetry_publisher.dart';
import '../../../../domain/throttle.dart';

part 'phone_sensor_cubit.freezed.dart';
part 'phone_sensor_state.dart';

class PhoneSensorCubit extends Cubit<PhoneSensorState> {
  static const samplingHz = 50;

  final SensorhubNative _native;
  final PhoneTelemetryPublisher _publisher;
  final Throttle _uiThrottle;

  StreamSubscription<AccelerometerSample>? _sensorSub;
  late final StreamSubscription<ConnectionStatus> _statusSub;

  PhoneSensorCubit(
    this._native,
    this._publisher,
    ConnectionManager connection,
    DateTime Function() now, {
    Duration uiInterval = const Duration(milliseconds: 100),
  }) : _uiThrottle = Throttle(uiInterval, now),
       super(
         PhoneSensorState(
           connected: connection.currentStatus == ConnectionStatus.connected,
         ),
       ) {
    _statusSub = connection.status.listen(
      (status) =>
          emit(state.copyWith(connected: status == ConnectionStatus.connected)),
    );
  }

  void start() {
    if (_sensorSub != null) return;
    emit(state.copyWith(status: PhoneSensorStatus.streaming, error: null));
    _sensorSub = _native
        .accelerometerStream(samplingHz: samplingHz)
        .listen(_onSample, onError: _onError);
  }

  void setPublishing(bool value) {
    if (value && !state.connected) return;
    emit(state.copyWith(publishing: value));
  }

  void _onSample(AccelerometerSample sample) {
    // MQTT has its own rate limit; the UI only needs a few frames per second.
    if (state.publishing) _publisher.offer(sample.magnitude);
    if (_uiThrottle.tryAcquire()) emit(state.copyWith(sample: sample));
  }

  void _onError(Object error) {
    // A failed native stream is finished; clearing it allows a retry.
    _sensorSub?.cancel();
    _sensorSub = null;
    emit(
      state.copyWith(
        status: PhoneSensorStatus.error,
        publishing: false,
        error: switch (error) {
          NativeException(:final message, :final code) => message ?? code,
          _ => '$error',
        },
      ),
    );
  }

  @override
  Future<void> close() {
    _sensorSub?.cancel();
    _statusSub.cancel();
    return super.close();
  }
}
