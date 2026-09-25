import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_status.freezed.dart';

part 'device_status.g.dart';

@freezed
abstract class DeviceStatus with _$DeviceStatus {
  const factory DeviceStatus({required bool online}) = _DeviceStatus;

  factory DeviceStatus.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusFromJson(json);
}
