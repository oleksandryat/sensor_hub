import 'package:freezed_annotation/freezed_annotation.dart';

part 'anomaly_detector.freezed.dart';

/// Window statistics right after a sample was pushed.
@freezed
abstract class AnomalyReading with _$AnomalyReading {
  const factory AnomalyReading({
    required double mean,
    required double stdDev,
    required double zScore,
    required bool isAnomaly,
  }) = _AnomalyReading;
}

/// Sliding-window z-score anomaly detection over a numeric stream.
abstract interface class AnomalyDetector {
  AnomalyReading push(double value);

  void reset();
}
