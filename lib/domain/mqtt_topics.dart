class MqttTopics(final String prefix) {
  String get telemetryFilter => '${prefix}devices/+/telemetry';

  String get statusFilter => '${prefix}devices/+/status';

  String cmdTopic(String deviceId) => '${prefix}devices/$deviceId/cmd';

  String cmdAckFilter(String deviceId) => '${prefix}devices/$deviceId/cmd/ack';
}
