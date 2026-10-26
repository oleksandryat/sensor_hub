import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sensorhub_stats/sensorhub_stats.dart';

void main() {
  late Directory buildDir;
  late DynamicLibrary library;

  // Compiles the same C file the plugin ships, for the host machine.
  setUpAll(() {
    buildDir = Directory.systemTemp.createTempSync('sensorhub_stats_test');
    final ext = Platform.isMacOS ? 'dylib' : 'so';
    final out = '${buildDir.path}/libsensorhub_stats.$ext';
    final result = Process.runSync('cc', [
      '-shared',
      '-fPIC',
      '-Iios/sensorhub_stats/Sources/sensorhub_stats/include',
      '-o',
      out,
      'ios/sensorhub_stats/Sources/sensorhub_stats/sensorhub_stats.c',
      '-lm',
    ]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    library = DynamicLibrary.open(out);
  });

  tearDownAll(() => buildDir.deleteSync(recursive: true));

  StatsDetector detector({int window = 10}) =>
      StatsDetector(window: window, zThreshold: 3, library: library);

  const calm = [9.7, 9.9, 9.8, 9.85, 9.75, 9.8];

  test('mean and stddev describe the earlier samples', () {
    final d = detector();
    d
      ..push(1)
      ..push(2);

    final r = d.push(10);

    expect(r.mean, closeTo(1.5, 1e-9));
    expect(r.stdDev, closeTo(0.5, 1e-9));
  });

  test('no z-score while warming up', () {
    final d = detector();

    final r = d.push(1000);

    expect(r.zScore, 0);
    expect(r.isAnomaly, isFalse);
  });

  test('no z-score for a flat signal', () {
    final d = detector();
    for (var i = 0; i < 5; i++) {
      d.push(9.81);
    }

    expect(d.push(50).isAnomaly, isFalse);
  });

  test('flags a spike', () {
    final d = detector();
    for (final v in calm) {
      expect(d.push(v).isAnomaly, isFalse);
    }

    final spike = d.push(20);

    expect(spike.isAnomaly, isTrue);
    expect(spike.zScore, greaterThan(3));
  });

  test('flags a drop with a negative z-score', () {
    final d = detector();
    calm.forEach(d.push);

    expect(d.push(0).zScore, lessThan(-3));
  });

  test('old samples fall out of the window', () {
    final d = detector(window: 3);
    for (final v in [100.0, 1.0, 2.0, 3.0]) {
      d.push(v);
    }

    // The window now holds 1, 2, 3; the 100 is gone.
    expect(d.push(4).mean, closeTo(2, 1e-9));
  });

  test('reset forgets the history', () {
    final d = detector();
    calm.forEach(d.push);
    d.reset();

    expect(d.push(20).zScore, 0);
  });

  test('rejects NaN and infinity', () {
    final d = detector();

    expect(() => d.push(double.nan), throwsA(isA<StatsException>()));
    expect(() => d.push(double.infinity), throwsA(isA<StatsException>()));
  });

  test('rejects a window below 2', () {
    expect(() => detector(window: 1), throwsArgumentError);
  });
}
