class MqttTopics(final String prefix) {
  String get telemetryFilter => '${prefix}devices/+/telemetry';

  String get statusFilter => '${prefix}devices/+/status';

  String cmdTopic(int deviceId) => '${prefix}devices/$deviceId/cmd';

  String cmdAckFilter(int deviceId) => '${prefix}devices/$deviceId/cmd/ack';
}
