import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/command.dart';
import 'package:sensor_hub/domain/command_dispatcher.dart';
import 'package:sensor_hub/domain/command_result.dart';
import 'package:sensor_hub/domain/connection_manager.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/device.dart';
import 'package:sensor_hub/domain/device_repository.dart';
import 'package:sensor_hub/features/dashboard/cubit/dashboard_cubit.dart';

class MockDeviceRepository extends Mock implements DeviceRepository {}

class MockConnectionManager extends Mock implements ConnectionManager {}

class MockCommandDispatcher extends Mock implements CommandDispatcher {}

void main() {
  setUpAll(() => registerFallbackValue(const Command.reboot(cmdId: '')));

  late MockDeviceRepository repo;
  late MockConnectionManager manager;
  late MockCommandDispatcher dispatcher;
  late StreamController<List<Device>> devices;
  late StreamController<ConnectionStatus> statuses;

  const device = Device(id: 'a', online: true, isStale: false);

  setUp(() {
    repo = MockDeviceRepository();
    manager = MockConnectionManager();
    dispatcher = MockCommandDispatcher();
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

  DashboardCubit build() =>
      DashboardCubit(repo, manager, dispatcher, () => 'c1');

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

  group('commands', () {
    const loaded = DashboardState(
      status: DashboardStatus.loaded,
      devices: [device],
      connection: ConnectionStatus.connected,
    );

    blocTest<DashboardCubit, DashboardState>(
      'reboot sends the command and reports success',
      build: build,
      seed: () => loaded,
      setUp: () => when(
        () => dispatcher.send(any(), deviceId: any(named: 'deviceId')),
      ).thenAnswer((_) async => const CommandResult.succeeded(cmdId: 'c1')),
      act: (c) => c.reboot('a'),
      expect: () => [
        loaded.copyWith(sending: {'a'}),
        loaded.copyWith(
          feedback: (
            deviceId: 'a',
            result: const CommandResult.succeeded(cmdId: 'c1'),
          ),
        ),
      ],
      verify: (_) => verify(
        () => dispatcher.send(const Command.reboot(cmdId: 'c1'), deviceId: 'a'),
      ).called(1),
    );

    blocTest<DashboardCubit, DashboardState>(
      'setInterval sends the interval and reports a timeout',
      build: build,
      seed: () => loaded,
      setUp: () => when(
        () => dispatcher.send(any(), deviceId: any(named: 'deviceId')),
      ).thenAnswer((_) async => const CommandResult.timedOut(cmdId: 'c1')),
      act: (c) => c.setInterval('a', 10),
      expect: () => [
        loaded.copyWith(sending: {'a'}),
        loaded.copyWith(
          feedback: (
            deviceId: 'a',
            result: const CommandResult.timedOut(cmdId: 'c1'),
          ),
        ),
      ],
      verify: (_) => verify(
        () => dispatcher.send(
          const Command.setInterval(cmdId: 'c1', seconds: 10),
          deviceId: 'a',
        ),
      ).called(1),
    );

    blocTest<DashboardCubit, DashboardState>(
      'dispatcher exception becomes a failed result',
      build: build,
      seed: () => loaded,
      setUp: () =>
          when(() => dispatcher.send(any(), deviceId: any(named: 'deviceId')))
              .thenThrow(Exception('boom')),
      act: (c) => c.reboot('a'),
      expect: () => [
        loaded.copyWith(sending: {'a'}),
        isA<DashboardState>()
            .having((s) => s.sending, 'sending', isEmpty)
            .having(
              (s) => s.feedback?.result,
              'result',
              isA<CommandResult>().having((r) => r.cmdId, 'cmdId', 'c1'),
            ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'ignores commands while offline',
      build: build,
      seed: () => loaded.copyWith(connection: ConnectionStatus.reconnecting),
      act: (c) => c.reboot('a'),
      expect: () => <DashboardState>[],
      verify: (_) => verifyNever(
        () => dispatcher.send(any(), deviceId: any(named: 'deviceId')),
      ),
    );

    blocTest<DashboardCubit, DashboardState>(
      'ignores a second command while one is in flight',
      build: build,
      seed: () => loaded.copyWith(sending: {'a'}),
      act: (c) => c.reboot('a'),
      expect: () => <DashboardState>[],
    );
  });
}
