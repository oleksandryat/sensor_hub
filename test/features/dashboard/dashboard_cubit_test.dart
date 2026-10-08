import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/connection_manager.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/device.dart';
import 'package:sensor_hub/domain/device_repository.dart';
import 'package:sensor_hub/features/dashboard/cubit/dashboard_cubit.dart';

class MockDeviceRepository extends Mock implements DeviceRepository {}

class MockConnectionManager extends Mock implements ConnectionManager {}

void main() {
  late MockDeviceRepository repo;
  late MockConnectionManager manager;
  late StreamController<List<Device>> devices;
  late StreamController<ConnectionStatus> statuses;

  const device = Device(id: 'a', online: true, isStale: false);

  setUp(() {
    repo = MockDeviceRepository();
    manager = MockConnectionManager();
    devices = StreamController.broadcast();
    statuses = StreamController.broadcast();
    when(() => repo.devices).thenAnswer((_) => devices.stream);
    when(() => repo.start()).thenReturn(null);
    when(() => manager.status).thenAnswer((_) => statuses.stream);
    when(() => manager.currentStatus).thenReturn(ConnectionStatus.connected);
  });

  tearDown(() {
    devices.close();
    statuses.close();
  });

  DashboardCubit build() => DashboardCubit(repo, manager);

  test('starts loaded when already connected', () {
    final state = build().state;
    expect(state.status, DashboardStatus.loaded);
    expect(state.isOffline, isFalse);
  });

  test('starts loading when not connected', () {
    when(() => manager.currentStatus).thenReturn(ConnectionStatus.connecting);
    final state = build().state;
    expect(state.status, DashboardStatus.loading);
    expect(state.isOffline, isTrue);
  });

  blocTest<DashboardCubit, DashboardState>(
    'start starts the repository',
    build: build,
    act: (c) => c.start(),
    verify: (_) => verify(() => repo.start()).called(1),
  );

  blocTest<DashboardCubit, DashboardState>(
    'emits devices from the repository',
    build: build,
    act: (c) {
      c.start();
      devices.add([device]);
    },
    expect: () => [
      const DashboardState(
        status: DashboardStatus.loaded,
        devices: [device],
        connection: ConnectionStatus.connected,
      ),
    ],
  );

  blocTest<DashboardCubit, DashboardState>(
    'drop shows offline but keeps devices',
    build: build,
    seed: () => const DashboardState(
      status: DashboardStatus.loaded,
      devices: [device],
      connection: ConnectionStatus.connected,
    ),
    act: (c) {
      c.start();
      statuses.add(ConnectionStatus.reconnecting);
    },
    expect: () => [
      isA<DashboardState>()
          .having((s) => s.isOffline, 'isOffline', isTrue)
          .having((s) => s.status, 'status', DashboardStatus.loaded)
          .having((s) => s.devices, 'devices', [device]),
    ],
  );

  blocTest<DashboardCubit, DashboardState>(
    'connection error without devices is an error state',
    build: build,
    act: (c) {
      c.start();
      statuses.add(ConnectionStatus.error);
    },
    expect: () => [
      isA<DashboardState>().having(
        (s) => s.status,
        'status',
        DashboardStatus.error,
      ),
    ],
  );

  blocTest<DashboardCubit, DashboardState>(
    'repository stream error is an error state',
    build: build,
    act: (c) {
      c.start();
      devices.addError(Exception('boom'));
    },
    expect: () => [
      isA<DashboardState>().having(
        (s) => s.status,
        'status',
        DashboardStatus.error,
      ),
    ],
  );

  blocTest<DashboardCubit, DashboardState>(
    'recovers from error to loaded on connect',
    build: build,
    seed: () => const DashboardState(
      status: DashboardStatus.error,
      connection: ConnectionStatus.error,
    ),
    act: (c) {
      c.start();
      statuses.add(ConnectionStatus.connected);
    },
    expect: () => [
      isA<DashboardState>().having(
        (s) => s.status,
        'status',
        DashboardStatus.loaded,
      ),
    ],
  );

  test('close cancels subscriptions', () async {
    final cubit = build()..start();
    await cubit.close();
    expect(devices.hasListener, isFalse);
    expect(statuses.hasListener, isFalse);
  });
}
