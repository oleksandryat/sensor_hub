import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/connection_manager.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/mqtt_broker_settings.dart';
import 'package:sensor_hub/features/connection/cubit/connection_cubit.dart';

class MockConnectionManager extends Mock implements ConnectionManager {}

class FakeSettings extends Fake implements MqttBrokerSettings {}

void main() {
  late MockConnectionManager manager;
  late StreamController<ConnectionStatus> statuses;

  setUpAll(() => registerFallbackValue(FakeSettings()));

  setUp(() {
    manager = MockConnectionManager();
    statuses = StreamController.broadcast();
    when(() => manager.status).thenAnswer((_) => statuses.stream);
    when(() => manager.connect(any())).thenAnswer((_) async {});
    when(() => manager.disconnect()).thenAnswer((_) async {});
  });

  tearDown(() => statuses.close());

  ConnectionCubit build() => ConnectionCubit(manager, () => 'client-1');

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

  test('close cancels status subscription', () async {
    final cubit = build();
    await cubit.close();
    expect(statuses.hasListener, isFalse);
  });
}
