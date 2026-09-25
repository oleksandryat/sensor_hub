// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reboot _$RebootFromJson(Map<String, dynamic> json) =>
    _Reboot(cmdId: json['cmdId'] as String, $type: json['type'] as String?);

Map<String, dynamic> _$RebootToJson(_Reboot instance) => <String, dynamic>{
  'cmdId': instance.cmdId,
  'type': instance.$type,
};

_SetInterval _$SetIntervalFromJson(Map<String, dynamic> json) => _SetInterval(
  cmdId: json['cmdId'] as String,
  seconds: (json['seconds'] as num).toInt(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$SetIntervalToJson(_SetInterval instance) =>
    <String, dynamic>{
      'cmdId': instance.cmdId,
      'seconds': instance.seconds,
      'type': instance.$type,
    };
