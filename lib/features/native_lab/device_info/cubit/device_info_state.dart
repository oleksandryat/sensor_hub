part of 'device_info_cubit.dart';

enum DeviceInfoStatus { loading, loaded, error }

/// Which native mechanism fetched the info.
enum DeviceInfoSource { methodChannel, pigeon }

@freezed
abstract class DeviceInfoState with _$DeviceInfoState {
  const factory DeviceInfoState({
    @Default(DeviceInfoStatus.loading) DeviceInfoStatus status,
    @Default(DeviceInfoSource.methodChannel) DeviceInfoSource source,
    NativeDeviceInfo? info,
    String? error,
  }) = _DeviceInfoState;
}
