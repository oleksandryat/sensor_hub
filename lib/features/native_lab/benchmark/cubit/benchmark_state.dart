part of 'benchmark_cubit.dart';

enum BenchmarkMechanism { methodChannel, pigeon, ffi }

enum BenchmarkStatus { idle, running, done, error }

@freezed
abstract class BenchmarkResult with _$BenchmarkResult {
  const factory BenchmarkResult({
    required BenchmarkMechanism mechanism,
    required LatencyStats stats,
  }) = _BenchmarkResult;
}

@freezed
abstract class BenchmarkState with _$BenchmarkState {
  const factory BenchmarkState({
    @Default(BenchmarkStatus.idle) BenchmarkStatus status,
    @Default([]) List<BenchmarkResult> results,
    String? error,
  }) = _BenchmarkState;

  const BenchmarkState._();

  /// Lowest median of the finished mechanisms, the baseline for comparison.
  Duration? get fastestMedian => results.isEmpty
      ? null
      : results.map((r) => r.stats.median).reduce((a, b) => a < b ? a : b);
}
