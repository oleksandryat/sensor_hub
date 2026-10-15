import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/device.dart';
import 'package:sensor_hub/domain/device_repository.dart';
import 'package:sensor_hub/features/native_lab/export/cubit/export_cubit.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

class MockNative extends Mock implements SensorhubNative {}

class MockDeviceRepository extends Mock implements DeviceRepository {}

void main() {
  late MockNative native;
  late MockDeviceRepository repo;
  late StreamController<List<Device>> devices;

  const device = Device(id: 'a', online: true, isStale: false);

  setUp(() {
    native = MockNative();
    repo = MockDeviceRepository();
    devices = StreamController.broadcast();
    when(() => repo.devices).thenAnswer((_) => devices.stream);
  });

  tearDown(() => devices.close());

  blocTest<ExportCubit, ExportState>(
    'tracks the device count from the repository',
    build: () => ExportCubit(repo, native),
    act: (c) async {
      c.start();
      devices.add([device]);
    },
    expect: () => [const ExportState(deviceCount: 1)],
  );

  blocTest<ExportCubit, ExportState>(
    'export does nothing without data',
    build: () => ExportCubit(repo, native),
    act: (c) => c.export(),
    expect: () => <ExportState>[],
    verify: (_) => verifyNever(
      () => native.shareText(any(), subject: any(named: 'subject')),
    ),
  );

  blocTest<ExportCubit, ExportState>(
    'export shares the CSV and reports the outcome',
    setUp: () =>
        when(() => native.shareText(any(), subject: any(named: 'subject')))
            .thenAnswer((_) async => ShareOutcome.completed),
    build: () => ExportCubit(repo, native),
    act: (c) async {
      c.start();
      devices.add([device]);
      await Future<void>.delayed(Duration.zero);
      await c.export();
    },
    expect: () => [
      const ExportState(deviceCount: 1),
      const ExportState(deviceCount: 1, status: ExportStatus.sharing),
      const ExportState(
        deviceCount: 1,
        status: ExportStatus.done,
        outcome: ShareOutcome.completed,
      ),
    ],
    verify: (_) => verify(
      () => native.shareText(
        any(that: startsWith('id,online')),
        subject: 'SensorHub telemetry',
      ),
    ).called(1),
  );

  blocTest<ExportCubit, ExportState>(
    'export maps NativeException to error',
    setUp: () =>
        when(() => native.shareText(any(), subject: any(named: 'subject')))
            .thenThrow(NativeException('no_activity')),
    build: () => ExportCubit(repo, native),
    act: (c) async {
      c.start();
      devices.add([device]);
      await Future<void>.delayed(Duration.zero);
      await c.export();
    },
    skip: 2,
    expect: () => [
      const ExportState(
        deviceCount: 1,
        status: ExportStatus.error,
        error: 'no_activity',
      ),
    ],
  );
}
