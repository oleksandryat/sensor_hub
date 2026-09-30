import 'package:freezed_annotation/freezed_annotation.dart';

part 'command.freezed.dart';

part 'command.g.dart';

@Freezed(unionKey: 'type')
sealed class Command with _$Command {
  const factory Command.reboot({required String cmdId}) = _Reboot;

  @FreezedUnionValue('set_interval')
  const factory Command.setInterval({
    required String cmdId,
    required int seconds,
  }) = _SetInterval;

  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);
}
