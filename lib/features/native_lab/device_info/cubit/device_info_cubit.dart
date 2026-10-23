import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

part 'device_info_cubit.freezed.dart';
part 'device_info_state.dart';

class DeviceInfoCubit extends Cubit<DeviceInfoState> {
  final SensorhubNative _native;

  DeviceInfoCubit(this._native) : super(const DeviceInfoState());

  Future<void> load([
    DeviceInfoSource source = DeviceInfoSource.methodChannel,
  ]) async {
    emit(DeviceInfoState(source: source));
    try {
      final info = switch (source) {
        DeviceInfoSource.methodChannel => await _native.getDeviceInfo(),
        DeviceInfoSource.pigeon => await _native.getDeviceInfoTyped(),
      };
      emit(
        DeviceInfoState(
          status: DeviceInfoStatus.loaded,
          source: source,
          info: info,
        ),
      );
    } on NativeException catch (e) {
      emit(
        DeviceInfoState(
          status: DeviceInfoStatus.error,
          source: source,
          error: e.message ?? e.code,
        ),
      );
    }
  }
}
