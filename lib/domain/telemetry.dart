import 'package:freezed_annotation/freezed_annotation.dart';

part 'telemetry.freezed.dart';

part 'telemetry.g.dart';

@freezed
abstract class Telemetry with _$Telemetry {
  const factory Telemetry({
    @JsonKey(fromJson: _fromJson, toJson: _toJson) required DateTime ts,
    required double value,
    required String unit,
  }) = _Telemetry;

  factory Telemetry.fromJson(Map<String, dynamic> json) =>
      _$TelemetryFromJson(json);
}

int _toJson(DateTime value) => value.millisecondsSinceEpoch;

DateTime _fromJson(int value) => DateTime.fromMillisecondsSinceEpoch(value);
