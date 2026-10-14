part of 'export_cubit.dart';

enum ExportStatus { idle, sharing, done, error }

@freezed
abstract class ExportState with _$ExportState {
  const factory ExportState({
    @Default(ExportStatus.idle) ExportStatus status,
    @Default(0) int deviceCount,
    ShareOutcome? outcome,
    String? error,
  }) = _ExportState;
}
