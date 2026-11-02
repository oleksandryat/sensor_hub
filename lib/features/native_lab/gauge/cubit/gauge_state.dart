part of 'gauge_cubit.dart';

enum GaugeStatus { idle, streaming, error }

@freezed
abstract class GaugeState with _$GaugeState {
  const factory GaugeState({
    @Default(GaugeStatus.idle) GaugeStatus status,
    @Default(0.0) double value,
    String? error,
  }) = _GaugeState;
}
