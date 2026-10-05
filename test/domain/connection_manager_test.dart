import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/domain/connection_manager.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/mqtt_broker_settings.dart';
import 'package:sensor_hub/domain/mqtt_gateway_state.dart';
import 'package:sensor_hub/domain/mqtt_qos.dart';

import '../fakes/fake_backoff_policy.dart';
import '../fakes/fake_mqtt_gateway.dart';

void main() {
  late ConnectionManager manager;
  late FakeMqttGateway gateway;
  late FakeBackoffPolicy backoff;
  late List<ConnectionStatus> statuses;
  late StreamSubscription sub;
  const MqttBrokerSettings settings = MqttBrokerSettings(
    host: 'test',
    port: 1883,
    clientId: '1',
    username: 'test',
    password: 'pswd',
  );

  void init() {
    gateway = FakeMqttGateway();
    backoff = FakeBackoffPolicy();
    manager = ConnectionManager(gateway, backoff);
    statuses = [];
    sub = manager.status.listen(statuses.add);
  }

  setUp(() {
    init();
  });

  tearDown(() {
    sub.cancel();
    manager.dispose();
  });

  test('connect success', () async {
    gateway.connectResults.add(null);
    await manager.connect(settings);
    await pumpEventQueue();
    expect(statuses, [ConnectionStatus.connecting, ConnectionStatus.connected]);
  });

  test('initial connect failure', () async {
    gateway.connectResults.add((
      Exception(),
      MqttDisconnectReason.notAuthorized,
    ));
    await manager.connect(settings);
    await pumpEventQueue();
    expect(statuses, [ConnectionStatus.connecting, ConnectionStatus.error]);
  });

  test('a live drop moves to reconnecting', () async {
    gateway.connectResults.add((null));
    backoff.delays.add(Duration(seconds: 2));
    await manager.connect(settings);
    await pumpEventQueue();
    gateway.emitState(.disconnected(reason: .connectionLost));
    await pumpEventQueue();
    expect(statuses, [
      ConnectionStatus.connecting,
      ConnectionStatus.connected,
      ConnectionStatus.reconnecting,
    ]);
  });

  test('a live drop schedules a reconnect', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));
      gateway.connectResults.add((null));
      backoff.delays.add(Duration(seconds: 2));

      manager.connect(settings);
      gateway.emitState(.disconnected(reason: .connectionLost));
      async.flushMicrotasks();
      expect(gateway.connectCalls.length, 1);
      async.elapse(Duration(seconds: 2));
      expect(gateway.connectCalls.length, 2);
      async.flushMicrotasks();
      expect(statuses, [
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        ConnectionStatus.reconnecting,
        ConnectionStatus.connected,
      ]);
    });
  });

  test('notAuthorized error on reconnect does not schedule another reconnect attempt', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));
      gateway.connectResults.add((
        Exception(),
        MqttDisconnectReason.notAuthorized,
      ));
      backoff.delays.add(Duration(seconds: 2));
      backoff.delays.add(Duration(seconds: 2));

      manager.connect(settings);
      gateway.emitState(.disconnected(reason: .connectionLost));
      async.flushMicrotasks();
      expect(gateway.connectCalls.length, 1);
      async.elapse(Duration(seconds: 2));
      expect(gateway.connectCalls.length, 2);
      async.elapse(Duration(seconds: 2));
      expect(gateway.connectCalls.length, 2);
      async.flushMicrotasks();
      expect(statuses, [
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        ConnectionStatus.reconnecting,
        ConnectionStatus.error,
      ]);
    });
  });

  test('unknown or connectionLost error on reconnect schedules another reconnect attempt', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));
      gateway.connectResults.add((Exception(), MqttDisconnectReason.unknown));
      gateway.connectResults.add((
        Exception(),
        MqttDisconnectReason.connectionLost,
      ));
      gateway.connectResults.add((null));

      backoff.delays.add(Duration(seconds: 1));
      backoff.delays.add(Duration(seconds: 2));
      backoff.delays.add(Duration(seconds: 4));

      manager.connect(settings);
      gateway.emitState(.disconnected(reason: .connectionLost));
      async.flushMicrotasks();

      expect(gateway.connectCalls.length, 1);

      async.elapse(Duration(seconds: 1));
      expect(gateway.connectCalls.length, 2);

      async.elapse(Duration(seconds: 2));
      expect(gateway.connectCalls.length, 3);

      async.elapse(Duration(seconds: 4));
      expect(gateway.connectCalls.length, 4);

      async.flushMicrotasks();

      expect(statuses, [
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        ConnectionStatus.reconnecting,
        ConnectionStatus.connected,
      ]);
    });
  });

  test('backoff reset on a successful reconnect', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));
      gateway.connectResults.add((null));
      backoff.delays.add(Duration(seconds: 2));
      backoff.delays.add(Duration(seconds: 4));

      manager.connect(settings);
      gateway.emitState(.disconnected(reason: .connectionLost));
      async.flushMicrotasks();
      expect(gateway.connectCalls.length, 1);
      expect(backoff.resetCalls, 1);
      async.elapse(Duration(seconds: 2));
      expect(gateway.connectCalls.length, 2);
      async.flushMicrotasks();
      expect(backoff.resetCalls, 2);
    });
  });

  test('after a reconnect, only the current subscriptions are restored, each with its QoS', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));
      gateway.connectResults.add((null));
      backoff.delays.add(Duration(seconds: 2));
      manager.connect(settings);
      async.flushMicrotasks();

      manager.subscribe('a/#', qos: .atMostOnce);
      manager.subscribe('b/#');
      manager.unsubscribe('b/#');

      gateway.emitState(.disconnected(reason: .connectionLost));
      expect(gateway.subscriptions, isEmpty);

      async.elapse(Duration(seconds: 2));
      async.flushMicrotasks();
      expect(gateway.subscriptions, {'a/#': MqttQos.atMostOnce});
    });
  });

  test('subscribe while disconnected is stored and applied on connect', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));

      manager.subscribe('a/#', qos: .atMostOnce);
      manager.connect(settings);
      expect(gateway.subscriptions, isEmpty);
      async.flushMicrotasks();
      expect(gateway.subscriptions, {'a/#': MqttQos.atMostOnce});
    });
  });

  test('unsubscribe while disconnected is stored and updates cached state which applied on connect', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));

      manager.subscribe('a/#', qos: .atMostOnce);
      manager.unsubscribe('a/#');
      manager.connect(settings);
      async.flushMicrotasks();
      expect(gateway.subscriptions, isEmpty);
    });
  });

  test('user disconnects while connected should emit normal', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));

      manager.connect(settings);
      async.flushMicrotasks();
      manager.disconnect();
      async.flushMicrotasks();

      expect(statuses, [
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        ConnectionStatus.disconnected,
      ]);
    });
  });

  test('user disconnects during backoff should stop trying to connect', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));
      gateway.connectResults.add((Exception(), .connectionLost));

      backoff.delays.add(Duration(seconds: 2));
      backoff.delays.add(Duration(seconds: 4));

      manager.connect(settings);
      gateway.emitState(.disconnected(reason: .connectionLost));
      async.flushMicrotasks();

      async.elapse(Duration(seconds: 2));

      manager.disconnect();
      async.flushMicrotasks();
      async.elapse(Duration(seconds: 4));

      expect(gateway.connectCalls.length, 2);

      expect(statuses, [
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        ConnectionStatus.reconnecting,
        ConnectionStatus.disconnected,
      ]);
    });
  });

  test('user is disconnected when sessionTakenOver arrives', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));

      backoff.delays.add(Duration(seconds: 2));
      backoff.delays.add(Duration(seconds: 4));

      manager.connect(settings);
      gateway.emitState(.disconnected(reason: .sessionTakenOver));
      async.flushMicrotasks();

      async.elapse(Duration(seconds: 2));
      async.elapse(Duration(seconds: 4));

      expect(gateway.connectCalls.length, 1);

      expect(statuses, [
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        ConnectionStatus.disconnected,
      ]);
    });
  });

  test('connect while reconnecting should drop pending timers', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));
      gateway.connectResults.add(null);
      gateway.connectResults.add((null));

      backoff.delays.add(Duration(seconds: 2));
      backoff.delays.add(Duration(seconds: 4));

      manager.connect(settings);
      gateway.emitState(.disconnected(reason: .connectionLost));
      async.flushMicrotasks();

      async.elapse(Duration(seconds: 1));
      manager.connect(settings);
      async.flushMicrotasks();
      async.elapse(Duration(seconds: 4));

      expect(gateway.connectCalls.length, 2);
    });
  });

  test('disconnect while connecting should emit disconnected', () {
    fakeAsync((async) {
      sub.cancel();
      init();

      gateway.connectResults.add((null));

      backoff.delays.add(Duration(seconds: 2));
      backoff.delays.add(Duration(seconds: 4));

      gateway.connectGate = Completer();

      manager.connect(settings);
      async.flushMicrotasks();

      manager.disconnect();
      async.flushMicrotasks();

      gateway.connectGate?.complete();
      async.flushMicrotasks();

      expect(statuses, [
        ConnectionStatus.connecting,
        ConnectionStatus.disconnected,
      ]);
    });
  });
}
