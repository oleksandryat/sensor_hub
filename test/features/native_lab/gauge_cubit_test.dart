import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/features/native_lab/gauge/cubit/gauge_cubit.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

class MockNative extends Mock implements SensorhubNative {}

void main() {
  late MockNative native;
  late StreamController<AccelerometerSample> samples;
  late DateTime now;

  AccelerometerSample sample(double z) => AccelerometerSample(
    x: 0,
    y: 0,
    z: z,
    timestamp: DateTime.fromMillisecondsSinceEpoch(0),
  );

  setUp(() {
    native = MockNative();
    samples = StreamController();
    now = DateTime(2026);
    when(() => native.accelerometerStream(samplingHz: any(named: 'samplingHz')))
        .thenAnswer((_) => samples.stream);
  });

  tearDown(() => samples.close());

  GaugeCubit build() => GaugeCubit(native, () => now);

  blocTest<GaugeCubit, GaugeState>(
    'emits the magnitude of each sample',
    build: build,
    act: (cubit) async {
      cubit.start();
      samples.add(sample(10));
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      const GaugeState(status: GaugeStatus.streaming),
      const GaugeState(status: GaugeStatus.streaming, value: 10),
    ],
  );

  blocTest<GaugeCubit, GaugeState>(
    'drops samples inside the throttle interval',
    build: build,
    act: (cubit) async {
      cubit.start();
      samples
        ..add(sample(10))
        ..add(sample(20));
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      const GaugeState(status: GaugeStatus.streaming),
      const GaugeState(status: GaugeStatus.streaming, value: 10),
    ],
  );

  blocTest<GaugeCubit, GaugeState>(
    'maps native errors',
    build: build,
    act: (cubit) async {
      cubit.start();
      samples.addError(const NativeException('unavailable', 'no sensor'));
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      const GaugeState(status: GaugeStatus.streaming),
      const GaugeState(status: GaugeStatus.error, error: 'no sensor'),
    ],
  );
}
