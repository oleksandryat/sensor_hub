import 'dart:async';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart' as mqtt3;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt3;
import 'package:typed_data/typed_data.dart';

import '../../domain/mqtt_broker_settings.dart';
import '../../domain/mqtt_gateway.dart';
import '../../domain/mqtt_gateway_message.dart';
import '../../domain/mqtt_gateway_state.dart';
import '../../domain/mqtt_qos.dart';

MqttDisconnectReason mapMqtt3DisconnectReason(
  mqtt3.MqttDisconnectionOrigin origin,
) {
  return switch (origin) {
    .solicited => .normal,
    .unsolicited => .connectionLost,
    .none => .unknown,
  };
}

MqttDisconnectReason mapMqtt3ConnectFailureReason(
  mqtt3.MqttConnectReturnCode? code,
) {
  return switch (code) {
    .notAuthorized || .badUsernameOrPassword => .notAuthorized,
    _ => .unknown,
  };
}

mqtt3.MqttQos mapDomainQosToMqtt3(MqttQos qos) {
  return switch (qos) {
    .atMostOnce => .atMostOnce,
    .atLeastOnce => .atLeastOnce,
    .exactlyOnce => .exactlyOnce,
  };
}

class Mqtt3ClientGateway implements MqttGateway {
  final StreamController<MqttGatewayState> _connectionStateController =
      StreamController.broadcast();
  final StreamController<MqttGatewayMessage> _messagesController =
      StreamController.broadcast();

  mqtt3.MqttServerClient? _client;
  StreamSubscription? _updatesSubscription;

  mqtt3.MqttServerClient get _connectedClient {
    final client = _client;
    if (client == null) throw StateError('Can not use client when it is null');
    return client;
  }

  @override
  Stream<MqttGatewayState> get connectionState =>
      _connectionStateController.stream;

  @override
  Stream<MqttGatewayMessage> get messages => _messagesController.stream;

  @override
  Future<void> connect(MqttBrokerSettings settings) async {
    final client = mqtt3.MqttServerClient.withPort(
      settings.host,
      settings.clientId,
      settings.port,
    );
    _client = client;
    client
      ..autoReconnect = false
      ..keepAlivePeriod = 30
      ..logging(on: false)
      ..setProtocolV311()
      ..connectionMessage = mqtt3.MqttConnectMessage()
          .withClientIdentifier(settings.clientId)
          .startClean()
      ..onConnected = () {
        _connectionStateController.add(.connected());
      }
      ..onDisconnected = () {
        _connectionStateController.add(
          .disconnected(
            reason: mapMqtt3DisconnectReason(
              client.connectionStatus!.disconnectionOrigin,
            ),
          ),
        );
      };
    _connectionStateController.add(.connecting());
    try {
      await client.connect(settings.username, settings.password);
    } catch (_) {
      _connectionStateController.add(
        .disconnected(
          reason: mapMqtt3ConnectFailureReason(
            client.connectionStatus?.returnCode,
          ),
        ),
      );
      rethrow;
    }
    await _updatesSubscription?.cancel();
    _updatesSubscription = client.updates?.listen((messages) {
      for (final m in messages) {
        final message = m.payload;
        if (message is! mqtt3.MqttPublishMessage) continue;
        _messagesController.add(
          MqttGatewayMessage(
            topic: m.topic,
            payload: mqtt3.MqttPublishPayload.bytesToStringAsString(
              message.payload.message,
            ),
          ),
        );
      }
    });
  }

  @override
  Future<void> disconnect() async {
    _client?.disconnect();
    await _updatesSubscription?.cancel();
    _updatesSubscription = null;
  }

  @override
  void publish({
    required String topic,
    required String payload,
    MqttQos qos = .atLeastOnce,
    bool retain = false,
  }) {
    _connectedClient.publishMessage(
      topic,
      mapDomainQosToMqtt3(qos),
      Uint8Buffer()..addAll(utf8.encode(payload)),
      retain: retain,
    );
  }

  @override
  void subscribe(String topicFilter, {MqttQos qos = .atLeastOnce}) {
    _connectedClient.subscribe(topicFilter, mapDomainQosToMqtt3(qos));
  }

  @override
  void unsubscribe(String topicFilter) {
    _connectedClient.unsubscribe(topicFilter);
  }
}
