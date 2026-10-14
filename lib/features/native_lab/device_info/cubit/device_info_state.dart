part of 'device_info_cubit.dart';

enum DeviceInfoStatus { loading, loaded, error }

@freezed
abstract class DeviceInfoState with _$DeviceInfoState {
  const factory DeviceInfoState({
    @Default(DeviceInfoStatus.loading) DeviceInfoStatus status,
    NativeDeviceInfo? info,
    String? error,
  }) = _DeviceInfoState;
}
