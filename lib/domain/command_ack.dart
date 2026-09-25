import 'package:freezed_annotation/freezed_annotation.dart';

part 'command_ack.freezed.dart';

part 'command_ack.g.dart';

@freezed
abstract class CommandAck with _$CommandAck {
  const factory CommandAck({
    required String cmdId,
    required bool ok,
    required String? error,
  }) = _CommandAck;

  factory CommandAck.fromJson(Map<String, dynamic> json) =>
      _$CommandAckFromJson(json);
}
