import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

part 'device_info_cubit.freezed.dart';
part 'device_info_state.dart';

class DeviceInfoCubit extends Cubit<DeviceInfoState> {
  final SensorhubNative _native;

  DeviceInfoCubit(this._native) : super(const DeviceInfoState());

  Future<void> load() async {
    emit(const DeviceInfoState());
    try {
      final info = await _native.getDeviceInfo();
      emit(DeviceInfoState(status: DeviceInfoStatus.loaded, info: info));
    } on PlatformException catch (e) {
      emit(
        DeviceInfoState(
          status: DeviceInfoStatus.error,
          error: e.message ?? e.code,
        ),
      );
    }
  }
}
