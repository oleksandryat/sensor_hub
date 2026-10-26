import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/connection_manager.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/phone_telemetry_publisher.dart';
import 'package:sensor_hub/features/native_lab/phone_sensor/cubit/phone_sensor_cubit.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../fakes/fake_anomaly_detector.dart';

class MockNative extends Mock implements SensorhubNative {}

class MockPublisher extends Mock implements PhoneTelemetryPublisher {}

class MockConnection extends Mock implements ConnectionManager {}

void main() {
  late MockNative native;
  late MockPublisher publisher;
  late MockConnection connection;
  late FakeAnomalyDetector detector;
  late StreamController<AccelerometerSample> samples;
  late StreamController<ConnectionStatus> status;
  late ConnectionStatus current;
  late DateTime now;

  AccelerometerSample sample(double z) => AccelerometerSample(
    x: 0,
    y: 0,
    z: z,
    timestamp: DateTime.fromMillisecondsSinceEpoch(0),
  );

  setUp(() {
    native = MockNative();
    publisher = MockPublisher();
    connection = MockConnection();
    detector = FakeAnomalyDetector(threshold: 15);
    samples = StreamController();
    status = StreamController.broadcast();
    current = ConnectionStatus.connected;
    now = DateTime(2026);
    when(() => native.accelerometerStream(samplingHz: any(named: 'samplingHz')))
        .thenAnswer((_) => samples.stream);
    when(() => connection.status).thenAnswer((_) => status.stream);
    when(() => connection.currentStatus).thenAnswer((_) => current);
  });

  tearDown(() {
    samples.close();
    status.close();
  });

  PhoneSensorCubit build() =>
      PhoneSensorCubit(native, publisher, detector, connection, () => now);

  blocTest<PhoneSensorCubit, PhoneSensorState>(
    'start streams samples and throttles UI updates',
    build: build,
    act: (c) async {
      c.start();
      samples.add(sample(1));
      await pumpEventQueue();
      now = now.add(const Duration(milliseconds: 50));
      samples.add(sample(2));
      await pumpEventQueue();
      now = now.add(const Duration(milliseconds: 60));
      samples.add(sample(3));
      await pumpEventQueue();
    },
    expect: () => [
      isA<PhoneSensorState>()
          .having((s) => s.status, 'status', PhoneSensorStatus.streaming)
          .having((s) => s.connected, 'connected', true),
      isA<PhoneSensorState>().having((s) => s.sample!.z, 'z', 1),
      isA<PhoneSensorState>().having((s) => s.sample!.z, 'z', 3),
    ],
  );

  blocTest<PhoneSensorCubit, PhoneSensorState>(
    'offers every sample to the publisher only while publishing',
    build: build,
    act: (c) async {
      c.start();
      samples.add(sample(1));
      await pumpEventQueue();
      c.setPublishing(true);
      samples.add(sample(2));
      samples.add(sample(3));
      await pumpEventQueue();
    },
    verify: (_) {
      verifyNever(() => publisher.offer(1));
      verify(() => publisher.offer(2)).called(1);
      verify(() => publisher.offer(3)).called(1);
    },
  );

  blocTest<PhoneSensorCubit, PhoneSensorState>(
    'cannot start publishing while offline',
    setUp: () => current = ConnectionStatus.disconnected,
    build: build,
    act: (c) => c.setPublishing(true),
    expect: () => <PhoneSensorState>[],
  );

  blocTest<PhoneSensorCubit, PhoneSensorState>(
    'tracks the connection status',
    build: build,
    act: (c) async {
      status.add(ConnectionStatus.reconnecting);
      await pumpEventQueue();
    },
    expect: () => [
      isA<PhoneSensorState>().having((s) => s.connected, 'connected', false),
    ],
  );

  blocTest<PhoneSensorCubit, PhoneSensorState>(
    'native error stops publishing and shows the message',
    build: build,
    act: (c) async {
      c.start();
      c.setPublishing(true);
      samples.addError(const NativeException('unavailable', 'no sensor'));
      await pumpEventQueue();
    },
    expect: () => [
      isA<PhoneSensorState>().having(
        (s) => s.status,
        's',
        PhoneSensorStatus.streaming,
      ),
      isA<PhoneSensorState>().having((s) => s.publishing, 'p', true),
      isA<PhoneSensorState>()
          .having((s) => s.status, 's', PhoneSensorStatus.error)
          .having((s) => s.publishing, 'p', false)
          .having((s) => s.error, 'e', 'no sensor'),
    ],
  );

  blocTest<PhoneSensorCubit, PhoneSensorState>(
    'feeds every sample to the detector, even when the UI is throttled',
    build: build,
    act: (c) async {
      c.start();
      samples.add(sample(1));
      samples.add(sample(2));
      samples.add(sample(3));
      await pumpEventQueue();
    },
    verify: (_) => expect(detector.pushed, [1, 2, 3]),
  );

  blocTest<PhoneSensorCubit, PhoneSensorState>(
    'an anomaly bypasses the UI throttle and is counted',
    build: build,
    act: (c) async {
      c.start();
      samples.add(sample(1));
      samples.add(sample(20));
      await pumpEventQueue();
    },
    skip: 1,
    expect: () => [
      isA<PhoneSensorState>().having((s) => s.anomalyCount, 'count', 0),
      isA<PhoneSensorState>()
          .having((s) => s.anomalyCount, 'count', 1)
          .having((s) => s.reading!.isAnomaly, 'anomaly', true),
    ],
  );

  test('close cancels the native stream', () async {
    final cubit = build()..start();
    await cubit.close();

    expect(samples.hasListener, isFalse);
  });
}
