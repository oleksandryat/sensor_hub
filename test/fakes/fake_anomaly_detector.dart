import 'package:sensor_hub/domain/anomaly_detector.dart';

/// Flags values above [threshold] as anomalies.
class FakeAnomalyDetector implements AnomalyDetector {
  final double threshold;
  final pushed = <double>[];

  FakeAnomalyDetector({this.threshold = double.infinity});

  @override
  AnomalyReading push(double value) {
    pushed.add(value);
    return AnomalyReading(
      mean: value,
      stdDev: 0,
      zScore: value > threshold ? 10 : 0,
      isAnomaly: value > threshold,
    );
  }

  @override
  void reset() => pushed.clear();
}
