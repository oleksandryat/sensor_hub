import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:intl/intl.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:typed_data/typed_data.dart';

const _keepAlive = 10;

final _timeFormat = DateFormat('HH:mm:ss');

void log(String message) =>
    stdout.writeln('[${_timeFormat.format(DateTime.now())}] $message');

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('seed', defaultsTo: '42')
    ..addOption('devices', defaultsTo: '3')
    ..addOption('host', defaultsTo: 'test.mosquitto.org')
    ..addOption('port', defaultsTo: '1883')
    ..addOption('prefix', defaultsTo: 'sensorhub-demo/')
    ..addOption('interval', defaultsTo: '1000')
    ..addOption('stats', defaultsTo: '5', help: 'Summary period, seconds');

  final results = parser.parse(arguments);

  final seed = int.parse(results['seed'] as String);
  final host = results['host'] as String;
  final port = int.parse(results['port'] as String);
  final prefix = results['prefix'] as String;
  final devices = int.parse(results['devices'] as String);
  final interval = int.parse(results['interval'] as String);
  final statsPeriod = int.parse(results['stats'] as String);

  log(
    'Simulator: $devices device(s) -> $host:$port, prefix "$prefix", '
    'seed $seed, interval ${interval}ms',
  );

  final payload = Uint8Buffer()
    ..addAll(utf8.encode(jsonEncode({'online': true})));

  final published = List<int>.filled(devices, 0);
  final lastValue = List<double>.filled(devices, 0);
  final online = List<bool>.filled(devices, true);
  var commands = 0;

  for (int i = 0; i < devices; i++) {
    final deviceId = '${i + 1}';
    final clientId = '$prefix$deviceId';
    final statusTopic = '${prefix}devices/$deviceId/status';

    log('[$deviceId] connecting…');
    late final MqttServerClient client;
    void publishOnline() => client.publishMessage(
      statusTopic,
      MqttQos.atLeastOnce,
      payload,
      retain: true,
    );
    try {
      client = await connectDevice(
        host,
        port,
        clientId,
        statusTopic,
        deviceId,
        onLost: () {
          online[i] = false;
          log('[$deviceId] connection lost, reconnecting…');
        },
        onBack: () {
          online[i] = true;
          // A restarted broker may have lost the retained status.
          publishOnline();
          log('[$deviceId] reconnected, status online (retained)');
        },
      );
    } catch (e) {
      log('[$deviceId] connection FAILED: $e');
      exit(1);
    }
    log('[$deviceId] connected, status online (retained)');
    publishOnline();

    final telemetryTopic = '${prefix}devices/$deviceId/telemetry';
    final random = Random(seed + i);
    Timer? telemetryTimer;
    void startTelemetry(Duration period) {
      telemetryTimer?.cancel();
      telemetryTimer = Timer.periodic(period, (_) {
        final value = 20 + random.nextDouble() * 10;
        final telemetryPayload = Uint8Buffer()
          ..addAll(
            utf8.encode(
              jsonEncode({
                'ts': DateTime.now().millisecondsSinceEpoch,
                'value': value,
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
          published[i]++;
          lastValue[i] = value;
        } catch (_) {
          // Device disconnected; skip this tick.
        }
      });
    }

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
        commands++;
        final seconds = json['seconds'];
        if (json['type'] == 'set_interval' && seconds is int && seconds > 0) {
          startTelemetry(Duration(seconds: seconds));
          log('[$deviceId] telemetry interval -> ${seconds}s');
        }
        log(
          '[$deviceId] cmd ${json['type']} (${json['cmdId']}) '
          '-> ack ok=$known',
        );
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
          log('[$deviceId] ack skipped: device disconnected');
        }
      }
    });

    startTelemetry(Duration(milliseconds: interval));
  }

  // Periodic heartbeat proves the simulator is alive.
  Timer.periodic(Duration(seconds: statsPeriod), (_) {
    final perDevice = [
      for (int i = 0; i < devices; i++)
        '${i + 1}: ${online[i] ? '' : 'OFFLINE '}${published[i]} msgs '
            '(last ${lastValue[i].toStringAsFixed(1)} C)',
    ].join(' | ');
    log('alive | $perDevice | commands: $commands');
  });

  log('Running. Ctrl+C to stop.');
}

Future<MqttServerClient> connectDevice(
  String host,
  int port,
  String clientId,
  String statusTopic,
  String deviceId, {
  required void Function() onLost,
  required void Function() onBack,
}) async {
  final MqttServerClient client = MqttServerClient.withPort(
    host,
    clientId,
    port,
  );
  client
    ..autoReconnect = true
    ..keepAlivePeriod = _keepAlive
    // Callbacks are captured at connect() time, so set them before it.
    ..onAutoReconnect = onLost
    ..onAutoReconnected = onBack
    ..onDisconnected = () => log('[$deviceId] DISCONNECTED');
  final payload = Uint8Buffer()
    ..addAll(utf8.encode(jsonEncode({'online': false})));

  client.connectionMessage = MqttConnectMessage()
      .keepAliveFor(_keepAlive)
      .will()
      .withWillTopic(statusTopic)
      .withWillQos(MqttQos.atLeastOnce)
      .withWillPayload(payload)
      .withWillRetain();

  await client.connect();
  return client;
}
