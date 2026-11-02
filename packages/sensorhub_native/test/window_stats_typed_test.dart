import 'package:flutter_test/flutter_test.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

class _FakeWindowStatsApi implements WindowStatsApi {
  List<double>? window;

  @override
  Future<WindowStatsMessage> analyzeWindow(
    List<double> window,
    double value,
  ) async {
    this.window = window;
    return WindowStatsMessage(mean: 1, stdDev: 0.5, zScore: value);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('analyzeWindowTyped maps the Pigeon message', () async {
    final api = _FakeWindowStatsApi();
    final native = SensorhubNative(windowStatsApi: api);

    final stats = await native.analyzeWindowTyped([1, 2], 3);

    expect(api.window, [1.0, 2.0]);
    expect(stats, const NativeWindowStats(mean: 1, stdDev: 0.5, zScore: 3));
  });
}
