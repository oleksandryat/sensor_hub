import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/data/native_anomaly_detector.dart';
import 'package:sensorhub_stats/sensorhub_stats.dart';

void main() {
  late Directory buildDir;
  late DynamicLibrary library;

  // Builds the plugin's C sources for the host; no device needed.
  setUpAll(() {
    buildDir = Directory.systemTemp.createTempSync('native_anomaly_test');
    final ext = Platform.isMacOS ? 'dylib' : 'so';
    final out = '${buildDir.path}/libsensorhub_stats.$ext';
    final result = Process.runSync('cc', [
      '-shared',
      '-fPIC',
      '-Ipackages/sensorhub_stats/ios/sensorhub_stats/Sources/sensorhub_stats/include',
      '-o',
      out,
      'packages/sensorhub_stats/ios/sensorhub_stats/Sources/sensorhub_stats/sensorhub_stats.c',
      '-lm',
    ]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    library = DynamicLibrary.open(out);
  });

  tearDownAll(() => buildDir.deleteSync(recursive: true));

  NativeAnomalyDetector build() => NativeAnomalyDetector(
    StatsDetector(window: 10, zThreshold: 3, library: library),
  );

  test('maps the native reading to the domain model', () {
    final detector = build();
    for (final v in [9.7, 9.9, 9.8, 9.85, 9.75, 9.8]) {
      detector.push(v);
    }

    final reading = detector.push(20);

    expect(reading.isAnomaly, isTrue);
    expect(reading.zScore, greaterThan(3));
    expect(reading.mean, closeTo(9.8, 0.1));
    expect(reading.stdDev, greaterThan(0));
  });

  test('reset clears the history', () {
    final detector = build();
    for (final v in [9.7, 9.9, 9.8, 9.85]) {
      detector.push(v);
    }
    detector.reset();

    expect(detector.push(20).zScore, 0);
  });
}
