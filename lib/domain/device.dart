import 'package:freezed_annotation/freezed_annotation.dart';

import 'telemetry.dart';

part 'device.freezed.dart';

@freezed
abstract class Device with _$Device {
  const factory Device({
    required String id,
    Telemetry? last,
    required bool online,
    DateTime? lastSeen,
    required bool isStale,
  }) = _Device;
}
