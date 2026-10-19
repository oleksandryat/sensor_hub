import 'package:freezed_annotation/freezed_annotation.dart';

part 'latency_stats.freezed.dart';

/// Summary of round-trip samples; percentiles use the nearest-rank method.
@freezed
abstract class LatencyStats with _$LatencyStats {
  const factory LatencyStats({
    required int count,
    required Duration min,
    required Duration median,
    required Duration p95,
    required Duration max,
  }) = _LatencyStats;

  factory LatencyStats.of(Iterable<Duration> samples) {
    final sorted = [...samples]..sort();
    if (sorted.isEmpty) throw ArgumentError.value(samples, 'samples', 'empty');
    Duration rank(double p) => sorted[(p * sorted.length).ceil() - 1];
    return LatencyStats(
      count: sorted.length,
      min: sorted.first,
      median: rank(0.5),
      p95: rank(0.95),
      max: sorted.last,
    );
  }
}
