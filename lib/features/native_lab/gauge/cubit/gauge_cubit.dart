import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../../../domain/throttle.dart';

part 'gauge_cubit.freezed.dart';
part 'gauge_state.dart';

class GaugeCubit extends Cubit<GaugeState> {
  final SensorhubNative _native;
  final Throttle _throttle;

  StreamSubscription<AccelerometerSample>? _sub;

  GaugeCubit(
    this._native,
    DateTime Function() now, {
    Duration interval = const Duration(milliseconds: 50),
  }) : _throttle = Throttle(interval, now),
       super(const GaugeState());

  void start() {
    if (_sub != null) return;
    emit(state.copyWith(status: GaugeStatus.streaming, error: null));
    _sub = _native.accelerometerStream().listen(_onSample, onError: _onError);
  }

  void _onSample(AccelerometerSample sample) {
    if (_throttle.tryAcquire()) emit(state.copyWith(value: sample.magnitude));
  }

  void _onError(Object error) {
    _sub?.cancel();
    _sub = null;
    emit(
      state.copyWith(
        status: GaugeStatus.error,
        error: switch (error) {
          NativeException(:final message, :final code) => message ?? code,
          _ => '$error',
        },
      ),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
