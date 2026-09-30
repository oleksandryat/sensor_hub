import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/domain/mqtt_topics.dart';

void main() {
  group('telemetryFilter', () {
    test('correct string when prefix is not empty', () {
      final topics = MqttTopics('my-prefix/');
      expect(topics.telemetryFilter, 'my-prefix/devices/+/telemetry');
    });
    test('correct string when prefix is empty', () {
      final topics = MqttTopics('');
      expect(topics.telemetryFilter, 'devices/+/telemetry');
    });
  });

  group('statusFilter', () {
    test('correct string when prefix is not empty', () {
      final topics = MqttTopics('my-prefix/');
      expect(topics.statusFilter, 'my-prefix/devices/+/status');
    });
    test('correct string when prefix is empty', () {
      final topics = MqttTopics('');
      expect(topics.statusFilter, 'devices/+/status');
    });
  });

  group('cmdTopic', () {
    test('correct string when deviceId is positive', () {
      final topics = MqttTopics('my-prefix/');
      expect(topics.cmdTopic(1), 'my-prefix/devices/1/cmd');
    });
    test('correct string when deviceId is positive', () {
      final topics = MqttTopics('my-prefix/');
      expect(topics.cmdTopic(42), 'my-prefix/devices/42/cmd');
    });
  });

  group('cmdAckFilter', () {
    test('correct string when deviceId is positive', () {
      final topics = MqttTopics('my-prefix/');
      expect(topics.cmdAckFilter(1), 'my-prefix/devices/1/cmd/ack');
    });
    test('correct string when deviceId is positive', () {
      final topics = MqttTopics('my-prefix/');
      expect(topics.cmdAckFilter(42), 'my-prefix/devices/42/cmd/ack');
    });
  });
}
