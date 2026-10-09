import 'package:freezed_annotation/freezed_annotation.dart';

part 'command_result.freezed.dart';

@freezed
sealed class CommandResult with _$CommandResult {
  const CommandResult._();

  const factory CommandResult.succeeded({required String cmdId}) = _Succeeded;

  const factory CommandResult.failed({
    required String cmdId,
    required String error,
  }) = _Failed;

  const factory CommandResult.timedOut({required String cmdId}) = _TimedOut;

  bool get isSuccess => this is _Succeeded;

  String? get error => switch (this) {
    _Failed(:final error) => error,
    _ => null,
  };
}
