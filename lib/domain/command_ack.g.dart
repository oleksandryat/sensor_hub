// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_ack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommandAck _$CommandAckFromJson(Map<String, dynamic> json) => _CommandAck(
  cmdId: json['cmdId'] as String,
  ok: json['ok'] as bool,
  error: json['error'] as String?,
);

Map<String, dynamic> _$CommandAckToJson(_CommandAck instance) =>
    <String, dynamic>{
      'cmdId': instance.cmdId,
      'ok': instance.ok,
      'error': instance.error,
    };
