import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/data/device_repository_impl.dart';
import 'package:sensor_hub/domain/connection_manager.dart';
import 'package:sensor_hub/domain/device.dart';
import 'package:sensor_hub/domain/mqtt_broker_settings.dart';
import 'package:sensor_hub/domain/mqtt_topics.dart';

import '../fakes/fake_backoff_policy.dart';
import '../fakes/fake_mqtt_gateway.dart';

void main() {
  const settings = MqttBrokerSettings(
    host: 'test',
    port: 1883,
    clientId: '1',
    username: 'test',
    password: 'pswd',
  );
  final topics = MqttTopics('p/');
  const staleThreshold = Duration(seconds: 15);

  String telemetry(double value) =>
      jsonEncode({'ts': 1000, 'value': value, 'unit': 'C'});

  void run(
    void Function(
      FakeAsync async,
      FakeMqttGateway gateway,
      ConnectionManager manager,
      DeviceRepositoryImpl repo,
      List<List<Device>> emitted,
    )
    body,
  ) {
    fakeAsync((async) {
      final start = DateTime(2026);
      final gateway = FakeMqttGateway();
      final manager = ConnectionManager(gateway, FakeBackoffPolicy());
      final repo = DeviceRepositoryImpl(
        gateway: gateway,
        connection: manager,
        topics: topics,
        now: () => start.add(async.elapsed),
        staleThreshold: staleThreshold,
      );
      final emitted = <List<Device>>[];
      repo.devices.listen(emitted.add);
      gateway.connectResults.add(null);
      manager.connect(settings);
      async.flushMicrotasks();
      repo.start();
      async.flushMicrotasks();
      body(async, gateway, manager, repo, emitted);
      repo.dispose();
      manager.dispose();
    });
  }

  test('subscribes to telemetry and status filters', () {
    run((async, gateway, _, _, _) {
      expect(gateway.subscriptions.keys, {
        topics.telemetryFilter,
        topics.statusFilter,
      });
    });
  });

  test('telemetry creates a device with last value', () {
    run((async, gateway, _, _, emitted) {
      gateway.emitMessage(
        topic: 'p/devices/a/telemetry',
        payload: telemetry(21.5),
      );
      async.flushMicrotasks();

      final device = emitted.last.single;
      expect(device.id, 'a');
      expect(device.last?.value, 21.5);
      expect(device.online, isTrue);
      expect(device.isStale, isFalse);
      expect(device.lastSeen, isNotNull);
    });
  });

  test('status updates online flag', () {
    run((async, gateway, _, _, emitted) {
      gateway.emitMessage(
        topic: 'p/devices/a/status',
        payload: jsonEncode({'online': false}),
      );
      async.flushMicrotasks();

      expect(emitted.last.single.online, isFalse);
    });
  });

  test('devices are sorted by id', () {
    run((async, gateway, _, _, emitted) {
      for (final id in ['b', 'a', 'c']) {
        gateway.emitMessage(
          topic: 'p/devices/$id/telemetry',
          payload: telemetry(1),
        );
      }
      async.flushMicrotasks();

      expect(emitted.last.map((d) => d.id), ['a', 'b', 'c']);
    });
  });

  test('ignores malformed payloads and foreign topics', () {
    run((async, gateway, _, _, emitted) {
      gateway.emitMessage(topic: 'p/devices/a/telemetry', payload: 'nope');
      gateway.emitMessage(topic: 'p/devices/a/status', payload: '{}');
      gateway.emitMessage(
        topic: 'other/devices/a/telemetry',
        payload: telemetry(1),
      );
      gateway.emitMessage(topic: 'p/devices/a/cmd/ack', payload: telemetry(1));
      async.flushMicrotasks();

      expect(emitted, isEmpty);
    });
  });

  test('device becomes stale after threshold and recovers on telemetry', () {
    run((async, gateway, _, _, emitted) {
      gateway.emitMessage(
        topic: 'p/devices/a/telemetry',
        payload: telemetry(1),
      );
      async.flushMicrotasks();

      async.elapse(staleThreshold);
      expect(emitted.last.single.isStale, isFalse);

      async.elapse(const Duration(seconds: 2));
      expect(emitted.last.single.isStale, isTrue);

      gateway.emitMessage(
        topic: 'p/devices/a/telemetry',
        payload: telemetry(2),
      );
      async.flushMicrotasks();
      expect(emitted.last.single.isStale, isFalse);
    });
  });

  test('stale check emits only on change', () {
    run((async, gateway, _, _, emitted) {
      gateway.emitMessage(
        topic: 'p/devices/a/telemetry',
        payload: telemetry(1),
      );
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 60));

      expect(emitted, hasLength(2));
    });
  });

  test('device without telemetry is never stale', () {
    run((async, gateway, _, _, emitted) {
      gateway.emitMessage(
        topic: 'p/devices/a/status',
        payload: jsonEncode({'online': true}),
      );
      async.flushMicrotasks();
      async.elapse(const Duration(minutes: 1));

      expect(emitted.last.single.isStale, isFalse);
    });
  });
}
