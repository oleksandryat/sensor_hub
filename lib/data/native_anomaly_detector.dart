import 'package:sensorhub_stats/sensorhub_stats.dart';

import '../domain/anomaly_detector.dart';

/// [AnomalyDetector] backed by the native C statistics library.
class NativeAnomalyDetector implements AnomalyDetector {
  final StatsDetector _detector;

  /// Deviations below this are noise, whatever their z-score: a resting
  /// sensor has a tiny stdDev, so jitter alone produces huge z values.
  final double minDeviation;

  NativeAnomalyDetector(this._detector, {this.minDeviation = 0});

  @override
  AnomalyReading push(double value) {
    final r = _detector.push(value);
    return AnomalyReading(
      mean: r.mean,
      stdDev: r.stdDev,
      zScore: r.zScore,
      isAnomaly: r.isAnomaly && (value - r.mean).abs() >= minDeviation,
    );
  }

  @override
  void reset() => _detector.reset();
}
