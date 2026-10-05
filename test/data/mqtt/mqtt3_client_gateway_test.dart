import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt3;
import 'package:sensor_hub/data/mqtt/mqtt3_client_gateway.dart';
import 'package:sensor_hub/domain/mqtt_gateway_state.dart';
import 'package:sensor_hub/domain/mqtt_qos.dart';

void main() {
  group('mapMqtt3DisconnectReason', () {
    const expected = {
      mqtt3.MqttDisconnectionOrigin.solicited: MqttDisconnectReason.normal,
      mqtt3.MqttDisconnectionOrigin.unsolicited:
          MqttDisconnectReason.connectionLost,
      mqtt3.MqttDisconnectionOrigin.none: MqttDisconnectReason.unknown,
    };

    for (final MapEntry(key: origin, value: reason) in expected.entries) {
      test('${origin.name} -> ${reason.name}', () {
        expect(mapMqtt3DisconnectReason(origin), reason);
      });
    }
  });

  group('mapMqtt3ConnectFailureReason', () {
    test('notAuthorized and badUsernameOrPassword -> notAuthorized', () {
      for (final code in [
        mqtt3.MqttConnectReturnCode.notAuthorized,
        mqtt3.MqttConnectReturnCode.badUsernameOrPassword,
      ]) {
        expect(
          mapMqtt3ConnectFailureReason(code),
          MqttDisconnectReason.notAuthorized,
        );
      }
    });

    test('other codes and null -> unknown', () {
      final others = mqtt3.MqttConnectReturnCode.values.where(
        (c) =>
            c != mqtt3.MqttConnectReturnCode.notAuthorized &&
            c != mqtt3.MqttConnectReturnCode.badUsernameOrPassword,
      );
      for (final code in others) {
        expect(
          mapMqtt3ConnectFailureReason(code),
          MqttDisconnectReason.unknown,
        );
      }
      expect(mapMqtt3ConnectFailureReason(null), MqttDisconnectReason.unknown);
    });
  });

  group('mapDomainQosToMqtt3', () {
    test('every domain QoS maps to the matching package QoS', () {
      const expected = {
        MqttQos.atMostOnce: mqtt3.MqttQos.atMostOnce,
        MqttQos.atLeastOnce: mqtt3.MqttQos.atLeastOnce,
        MqttQos.exactlyOnce: mqtt3.MqttQos.exactlyOnce,
      };
      expect(expected.keys, unorderedEquals(MqttQos.values));
      for (final MapEntry(key: domain, value: package) in expected.entries) {
        expect(mapDomainQosToMqtt3(domain), package);
      }
    });
  });
}
