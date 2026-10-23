import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/connection_manager.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/credentials_vault.dart';
import 'package:sensor_hub/domain/mqtt_broker_settings.dart';
import 'package:sensor_hub/domain/stored_credentials.dart';
import 'package:sensor_hub/features/connection/cubit/connection_cubit.dart';

import '../../fakes/fake_credentials_vault.dart';

class MockConnectionManager extends Mock implements ConnectionManager {}

class FakeSettings extends Fake implements MqttBrokerSettings {}

void main() {
  late MockConnectionManager manager;
  late StreamController<ConnectionStatus> statuses;
  late FakeCredentialsVault vault;

  setUpAll(() => registerFallbackValue(FakeSettings()));

  setUp(() {
    manager = MockConnectionManager();
    statuses = StreamController.broadcast();
    vault = FakeCredentialsVault();
    when(() => manager.status).thenAnswer((_) => statuses.stream);
    when(() => manager.connect(any())).thenAnswer((_) async {});
    when(() => manager.disconnect()).thenAnswer((_) async {});
  });

  tearDown(() => statuses.close());

  ConnectionCubit build() => ConnectionCubit(manager, () => 'client-1', vault);

  test('starts disconnected', () {
    expect(build().state.status, ConnectionStatus.disconnected);
  });

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'mirrors manager statuses',
    build: build,
    act: (_) {
      statuses
        ..add(ConnectionStatus.connecting)
        ..add(ConnectionStatus.connected)
        ..add(ConnectionStatus.reconnecting)
        ..add(ConnectionStatus.error);
    },
    expect: () => [
      const ConnectionCubitState(status: ConnectionStatus.connecting),
      const ConnectionCubitState(status: ConnectionStatus.connected),
      const ConnectionCubitState(status: ConnectionStatus.reconnecting),
      const ConnectionCubitState(status: ConnectionStatus.error),
    ],
  );

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'connect passes settings with generated client id',
    build: build,
    act: (c) => c.connect(host: 'h', port: 1883, username: 'u', password: 'p'),
    verify: (_) => verify(
      () => manager.connect(
        const MqttBrokerSettings(
          host: 'h',
          port: 1883,
          clientId: 'client-1',
          username: 'u',
          password: 'p',
        ),
      ),
    ).called(1),
  );

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'disconnect delegates to manager',
    build: build,
    act: (c) => c.disconnect(),
    verify: (_) => verify(() => manager.disconnect()).called(1),
  );

  const saved = StoredCredentials(username: 'u', password: 'p');

  Future<void> connectWith(ConnectionCubit cubit, {required bool remember}) =>
      cubit.connect(
        host: 'h',
        port: 1883,
        username: 'u',
        password: 'p',
        remember: remember,
      );

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'loadSaved exposes stored credentials',
    setUp: () => vault.stored = saved,
    build: build,
    act: (c) => c.loadSaved(),
    expect: () => [const ConnectionCubitState(saved: saved)],
  );

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'loadSaved emits nothing for an empty vault',
    build: build,
    act: (c) => c.loadSaved(),
    expect: () => <ConnectionCubitState>[],
  );

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'loadSaved reports a vault failure',
    setUp: () => vault.failure = const VaultException('corrupted'),
    build: build,
    act: (c) => c.loadSaved(),
    expect: () => [const ConnectionCubitState(vaultError: 'corrupted')],
  );

  const remembered = (credentials: saved, remember: true);
  const forgotten = (credentials: saved, remember: false);

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'remembers credentials only after a successful connect',
    build: build,
    act: (c) async {
      await connectWith(c, remember: true);
      expect(vault.stored, isNull);
      statuses.add(ConnectionStatus.connected);
    },
    verify: (_) => expect(vault.stored, saved),
    expect: () => [
      const ConnectionCubitState(pending: remembered),
      const ConnectionCubitState(
        status: ConnectionStatus.connected,
        pending: remembered,
      ),
      const ConnectionCubitState(status: ConnectionStatus.connected),
      const ConnectionCubitState(
        status: ConnectionStatus.connected,
        saved: saved,
      ),
    ],
  );

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'does not remember credentials of a failed attempt',
    build: build,
    act: (c) async {
      await connectWith(c, remember: true);
      statuses.add(ConnectionStatus.error);
    },
    verify: (_) => expect(vault.stored, isNull),
    expect: () => [
      const ConnectionCubitState(pending: remembered),
      const ConnectionCubitState(
        status: ConnectionStatus.error,
        pending: remembered,
      ),
    ],
  );

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'forgets stored credentials when remember is off',
    setUp: () => vault.stored = saved,
    build: build,
    seed: () => const ConnectionCubitState(saved: saved),
    act: (c) async {
      await connectWith(c, remember: false);
      statuses.add(ConnectionStatus.connected);
    },
    verify: (_) => expect(vault.stored, isNull),
    expect: () => [
      const ConnectionCubitState(saved: saved, pending: forgotten),
      const ConnectionCubitState(
        status: ConnectionStatus.connected,
        saved: saved,
        pending: forgotten,
      ),
      const ConnectionCubitState(
        status: ConnectionStatus.connected,
        saved: saved,
      ),
      const ConnectionCubitState(status: ConnectionStatus.connected),
    ],
  );

  blocTest<ConnectionCubit, ConnectionCubitState>(
    'a vault failure does not break the connection',
    setUp: () => vault.failure = const VaultException('boom'),
    build: build,
    act: (c) async {
      await connectWith(c, remember: true);
      statuses.add(ConnectionStatus.connected);
    },
    expect: () => [
      const ConnectionCubitState(pending: remembered),
      const ConnectionCubitState(
        status: ConnectionStatus.connected,
        pending: remembered,
      ),
      const ConnectionCubitState(status: ConnectionStatus.connected),
      const ConnectionCubitState(
        status: ConnectionStatus.connected,
        vaultError: 'boom',
      ),
    ],
  );

  test('close cancels status subscription', () async {
    final cubit = build();
    await cubit.close();
    expect(statuses.hasListener, isFalse);
  });
}
