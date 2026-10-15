import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../../../domain/device.dart';
import '../../../../domain/device_repository.dart';
import '../../../../domain/devices_csv.dart';

part 'export_cubit.freezed.dart';
part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  final DeviceRepository _devices;
  final SensorhubNative _native;

  List<Device> _snapshot = const [];
  StreamSubscription<List<Device>>? _sub;

  ExportCubit(this._devices, this._native) : super(const ExportState());

  void start() {
    _sub ??= _devices.devices.listen((devices) {
      _snapshot = devices;
      emit(state.copyWith(deviceCount: devices.length));
    });
  }

  Future<void> export() async {
    if (_snapshot.isEmpty || state.status == ExportStatus.sharing) return;
    emit(state.copyWith(status: ExportStatus.sharing, error: null));
    try {
      final outcome = await _native.shareText(
        devicesToCsv(_snapshot),
        subject: 'SensorHub telemetry',
      );
      emit(state.copyWith(status: ExportStatus.done, outcome: outcome));
    } on NativeException catch (e) {
      emit(
        state.copyWith(status: ExportStatus.error, error: e.message ?? e.code),
      );
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
