import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'sensorhub_stats_bindings_generated.dart';

const String _libName = 'sensorhub_stats';

DynamicLibrary _openDefaultLibrary() {
  if (Platform.isMacOS || Platform.isIOS) {
    // Swift Package Manager links the C code statically into the app.
    return DynamicLibrary.process();
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}

class StatsException implements Exception {
  final String message;

  const StatsException(this.message);

  @override
  String toString() => 'StatsException: $message';
}

/// Result of comparing one sample with the samples before it.
class StatsReading {
  final double mean;
  final double stdDev;

  /// Distance of the sample from the mean, in standard deviations.
  final double zScore;
  final bool isAnomaly;

  const StatsReading({
    required this.mean,
    required this.stdDev,
    required this.zScore,
    required this.isAnomaly,
  });
}

/// Flags samples that are far from the average of the last [window] samples.
///
/// Dart keeps the history; the math runs in C.
class StatsDetector {
  final int window;
  final double zThreshold;
  final SensorhubStatsBindings _bindings;

  final List<double> _history = [];

  /// [library] can be replaced in tests with a build for the host machine.
  StatsDetector({
    this.window = 50,
    this.zThreshold = 3,
    DynamicLibrary? library,
  }) : _bindings = SensorhubStatsBindings(library ?? _openDefaultLibrary()) {
    if (window < 2) {
      throw ArgumentError.value(window, 'window', 'must be at least 2');
    }
  }

  StatsReading push(double value) {
    // `using` frees everything allocated inside the block when it ends.
    final reading = using((arena) {
      final samples = arena<Double>(_history.length + 1);
      samples.asTypedList(_history.length).setAll(0, _history);
      final result = arena<sh_stats_result>();

      final code = _bindings.sh_stats_analyze(
        samples,
        _history.length,
        value,
        zThreshold,
        result,
      );
      if (code != 0) throw StatsException('Invalid sample: $value');

      // Read the values before the block ends and the memory is freed.
      return StatsReading(
        mean: result.ref.mean,
        stdDev: result.ref.stddev,
        zScore: result.ref.z_score,
        isAnomaly: result.ref.is_anomaly != 0,
      );
    });

    // After the call, so C compares `value` with the samples before it.
    _history.add(value);
    if (_history.length > window) {
      _history.removeAt(0);
    }
    return reading;
  }

  void reset() {
    _history.clear();
  }
}
