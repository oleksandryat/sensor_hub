import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/data/mqtt/mqtt_payload_parser.dart';
import 'package:sensor_hub/domain/command_ack.dart';
import 'package:sensor_hub/domain/telemetry.dart';

void main() {
  group('parseTelemetry', () {
    test('returns Telemetry with correct payload', () {
      final payload = '{"ts":1000, "value": 20.0, "unit": "C"}';
      expect(
        parseTelemetry(payload),
        Telemetry(
          ts: DateTime.fromMillisecondsSinceEpoch(1000),
          value: 20.0,
          unit: "C",
        ),
      );
    });
    test('throws TypeError on missing field', () {
      final payload = '{"ts":1000, "value": 20.0}';
      expect(() => parseTelemetry(payload), throwsA(isA<TypeError>()));
    });
    test('throws TypeError on incorrect type', () {
      final payload = '1000';
      expect(() => parseTelemetry(payload), throwsA(isA<TypeError>()));
    });
    test('throws FormatException on incorrect JSON format', () {
      final payload = '{"ts":1000, "value": 20.0 /}';
      expect(() => parseTelemetry(payload), throwsA(isA<FormatException>()));
    });
  });

  group('parseCommandAck', () {
    test('returns CommandAck with error is null', () {
      final payload = '{"cmdId": "1", "ok": true}';
      expect(
        parseCommandAck(payload),
        CommandAck(cmdId: '1', ok: true, error: null),
      );
    });
    test('returns CommandAck with error is not null', () {
      final payload = '{"cmdId": "1", "ok": false, "error": "CODE401"}';
      expect(
        parseCommandAck(payload),
        CommandAck(cmdId: '1', ok: false, error: 'CODE401'),
      );
    });
    test('throws TypeError on incorrect type', () {
      final payload = '1000';
      expect(() => parseCommandAck(payload), throwsA(isA<TypeError>()));
    });
  });
}
