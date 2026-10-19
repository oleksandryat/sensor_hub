part of 'system_events_cubit.dart';

enum PingStatus { idle, running, done, error }

@freezed
abstract class PingResult with _$PingResult {
  const factory PingResult({
    required PingCodec codec,
    required int payloadSize,
    required LatencyStats stats,
  }) = _PingResult;
}

@freezed
abstract class SystemEventsState with _$SystemEventsState {
  const factory SystemEventsState({
    /// Newest first.
    @Default([]) List<SystemEvent> events,
    @Default(PingStatus.idle) PingStatus pingStatus,
    @Default([]) List<PingResult> results,
    String? error,
  }) = _SystemEventsState;
}
