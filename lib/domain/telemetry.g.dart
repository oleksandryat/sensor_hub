// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Telemetry _$TelemetryFromJson(Map<String, dynamic> json) => _Telemetry(
  ts: _fromJson((json['ts'] as num).toInt()),
  value: (json['value'] as num).toDouble(),
  unit: json['unit'] as String,
);

Map<String, dynamic> _$TelemetryToJson(_Telemetry instance) =>
    <String, dynamic>{
      'ts': _toJson(instance.ts),
      'value': instance.value,
      'unit': instance.unit,
    };
