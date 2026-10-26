import 'package:sensorhub_stats/sensorhub_stats.dart';

import '../domain/anomaly_detector.dart';

/// [AnomalyDetector] backed by the native C statistics library.
class NativeAnomalyDetector implements AnomalyDetector {
  final StatsDetector _detector;

  NativeAnomalyDetector(this._detector);

  @override
  AnomalyReading push(double value) {
    final r = _detector.push(value);
    return AnomalyReading(
      mean: r.mean,
      stdDev: r.stdDev,
      zScore: r.zScore,
      isAnomaly: r.isAnomaly,
    );
  }

  @override
  void reset() => _detector.reset();
}
