import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/domain/connection_manager.dart';
import 'package:sensor_hub/domain/mqtt_broker_settings.dart';
import 'package:sensor_hub/domain/mqtt_qos.dart';
import 'package:sensor_hub/domain/mqtt_topics.dart';
import 'package:sensor_hub/domain/phone_telemetry_publisher.dart';

import '../fakes/fake_backoff_policy.dart';
import '../fakes/fake_mqtt_gateway.dart';

void main() {
  late FakeMqttGateway gateway;
  late ConnectionManager connection;
  late PhoneTelemetryPublisher publisher;
  late DateTime now;

  const settings = MqttBrokerSettings(
    host: 'h',
    port: 1883,
    clientId: 'c',
    username: '',
    password: '',
  );

  setUp(() {
    now = DateTime.fromMillisecondsSinceEpoch(1000);
    gateway = FakeMqttGateway();
    connection = ConnectionManager(gateway, FakeBackoffPolicy());
    publisher = PhoneTelemetryPublisher(
      deviceId: 'phone-1',
      gateway: gateway,
      connection: connection,
      topics: MqttTopics('p/'),
      now: () => now,
      interval: const Duration(seconds: 1),
    );
  });

  tearDown(() => connection.dispose());

  Future<void> connect() async {
    gateway.connectResults.add(null);
    await connection.connect(settings);
    await pumpEventQueue();
  }

  test('publishes telemetry on the device topic with QoS 0', () async {
    await connect();

    publisher.offer(9.81);

    final message = gateway.published.single;
    expect(message.topic, 'p/devices/phone-1/telemetry');
    expect(message.qos, MqttQos.atMostOnce);
    expect(message.retain, isFalse);
    expect(jsonDecode(message.payload), {
      'ts': 1000,
      'value': 9.81,
      'unit': 'm/s²',
    });
  });

  test('drops values while offline', () {
    publisher.offer(9.81);

    expect(gateway.published, isEmpty);
  });

  test('limits the rate to the interval', () async {
    await connect();

    publisher.offer(1);
    now = now.add(const Duration(milliseconds: 400));
    publisher.offer(2);
    now = now.add(const Duration(milliseconds: 600));
    publisher.offer(3);

    expect(gateway.published.map((m) => jsonDecode(m.payload)['value']), [
      1,
      3,
    ]);
  });
}
