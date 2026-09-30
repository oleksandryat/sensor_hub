import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:args/args.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:typed_data/typed_data.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('seed', defaultsTo: '42')
    ..addOption('devices', defaultsTo: '3')
    ..addOption('host', defaultsTo: 'test.mosquitto.org')
    ..addOption('port', defaultsTo: '1883')
    ..addOption('prefix', defaultsTo: 'sensorhub-sim/')
    ..addOption('interval', defaultsTo: '1000');

  final results = parser.parse(arguments);

  final seed = int.parse(results['seed'] as String);
  final host = results['host'] as String;
  final port = int.parse(results['port'] as String);
  final prefix = results['prefix'] as String;
  final devices = int.parse(results['devices'] as String);
  final interval = int.parse(results['interval'] as String);

  final payload = Uint8Buffer()
    ..addAll(utf8.encode(jsonEncode({'online': true})));

  for (int i = 0; i < devices; i++) {
    final deviceId = '${i + 1}';
    final clientId = '$prefix$deviceId';
    final statusTopic = '${prefix}devices/$deviceId/status';
    final client = await connectDevice(host, port, clientId, statusTopic);
    client.publishMessage(
      statusTopic,
      MqttQos.atLeastOnce,
      payload,
      retain: true,
    );

    final cmdTopic = '${prefix}devices/$deviceId/cmd';
    final ackTopic = '${prefix}devices/$deviceId/cmd/ack';
    client.subscribe(cmdTopic, MqttQos.atLeastOnce);

    client.updates!.listen((messages) {
      for (final m in messages) {
        if (m.topic != cmdTopic) continue;
        final bytes = (m.payload as MqttPublishMessage).payload.message;
        if (bytes == null) continue;
        final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
        final known =
            json['type'] == 'reboot' || json['type'] == 'set_interval';
        final ackPayload = Uint8Buffer()
          ..addAll(
            utf8.encode(
              jsonEncode({
                'cmdId': json['cmdId'],
                'ok': known,
                'error': known ? null : 'unknown command type',
              }),
            ),
          );
        try {
          client.publishMessage(ackTopic, MqttQos.atLeastOnce, ackPayload);
        } catch (_) {
          // Device disconnected before it could ack; skip.
        }
      }
    });

    final telemetryTopic = '${prefix}devices/$deviceId/telemetry';
    final random = Random(seed + i);
    Timer.periodic(Duration(milliseconds: interval), (_) {
      final telemetryPayload = Uint8Buffer()
        ..addAll(
          utf8.encode(
            jsonEncode({
              'ts': DateTime.now().millisecondsSinceEpoch,
              'value': 20 + random.nextDouble() * 10,
              'unit': 'C',
            }),
          ),
        );
      try {
        client.publishMessage(
          telemetryTopic,
          MqttQos.atMostOnce,
          telemetryPayload,
        );
      } catch (_) {
        // Device disconnected; skip this tick.
      }
    });
  }
}

Future<MqttServerClient> connectDevice(
  String host,
  int port,
  String clientId,
  String statusTopic,
) async {
  final MqttServerClient client = MqttServerClient.withPort(
    host,
    clientId,
    port,
  );
  final payload = Uint8Buffer()
    ..addAll(utf8.encode(jsonEncode({'online': false})));

  client.connectionMessage = MqttConnectMessage()
      .will()
      .withWillTopic(statusTopic)
      .withWillQos(MqttQos.atLeastOnce)
      .withWillPayload(payload)
      .withWillRetain();

  await client.connect();
  return client;
}
