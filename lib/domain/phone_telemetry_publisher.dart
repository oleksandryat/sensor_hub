import 'dart:convert';

import 'connection_manager.dart';
import 'connection_status.dart';
import 'mqtt_gateway.dart';
import 'mqtt_topics.dart';
import 'telemetry.dart';
import 'throttle.dart';

/// Publishes the phone's own readings as a regular device, at a limited rate.
class PhoneTelemetryPublisher {
  static const unit = 'm/s²';

  final String deviceId;

  final MqttGateway _gateway;
  final ConnectionManager _connection;
  final MqttTopics _topics;
  final DateTime Function() _now;
  final Throttle _throttle;

  PhoneTelemetryPublisher({
    required this.deviceId,
    required this._gateway,
    required this._connection,
    required this._topics,
    required this._now,
    required Duration interval,
  }) : _throttle = Throttle(interval, _now);

  /// Publishes [value] unless offline or the previous one was too recent.
  void offer(double value) {
    if (_connection.currentStatus != ConnectionStatus.connected) return;
    if (!_throttle.tryAcquire()) return;
    final telemetry = Telemetry(ts: _now(), value: value, unit: unit);
    _gateway.publish(
      topic: _topics.telemetryTopic(deviceId),
      payload: jsonEncode(telemetry.toJson()),
      qos: .atMostOnce,
    );
  }
}
