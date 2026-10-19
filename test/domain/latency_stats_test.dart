import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/domain/latency_stats.dart';

void main() {
  List<Duration> ms(Iterable<int> values) => [
    for (final v in values) Duration(milliseconds: v),
  ];

  test('computes nearest-rank percentiles regardless of order', () {
    final stats = LatencyStats.of(ms([for (var i = 100; i >= 1; i--) i]));

    expect(
      stats,
      LatencyStats(
        count: 100,
        min: const Duration(milliseconds: 1),
        median: const Duration(milliseconds: 50),
        p95: const Duration(milliseconds: 95),
        max: const Duration(milliseconds: 100),
      ),
    );
  });

  test('a single sample is every percentile', () {
    final stats = LatencyStats.of(ms([7]));

    expect(stats.median, const Duration(milliseconds: 7));
    expect(stats.p95, const Duration(milliseconds: 7));
  });

  test('p95 picks the outlier in a small series', () {
    final stats = LatencyStats.of(ms([1, 1, 1, 1, 50]));

    expect(stats.median, const Duration(milliseconds: 1));
    expect(stats.p95, const Duration(milliseconds: 50));
  });

  test('rejects an empty series', () {
    expect(() => LatencyStats.of([]), throwsArgumentError);
  });
}
