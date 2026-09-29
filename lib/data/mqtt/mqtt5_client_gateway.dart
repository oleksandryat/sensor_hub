import 'dart:async';
import 'dart:convert';

import 'package:mqtt5_client/mqtt5_client.dart' as mqtt5;
import 'package:mqtt5_client/mqtt5_server_client.dart' as mqtt5;
import 'package:typed_data/typed_data.dart';

import '../../domain/mqtt_broker_settings.dart';
import '../../domain/mqtt_gateway.dart';
import '../../domain/mqtt_gateway_message.dart';
import '../../domain/mqtt_gateway_state.dart';
import '../../domain/mqtt_qos.dart';

MqttDisconnectReason mapDisconnectReason({
  required mqtt5.MqttDisconnectionOrigin origin,
  mqtt5.MqttDisconnectReasonCode? code,
}) {
  switch (origin) {
    case mqtt5.MqttDisconnectionOrigin.solicited:
      return .normal;
    case mqtt5.MqttDisconnectionOrigin.brokerSolicited:
      return switch (code) {
        .sessionTakenOver => .sessionTakenOver,
        .notAuthorized => .notAuthorized,
        _ => .unknown,
      };
    case mqtt5.MqttDisconnectionOrigin.unsolicited:
      return .connectionLost;
    case mqtt5.MqttDisconnectionOrigin.none:
      return .unknown;
  }
}

MqttDisconnectReason mapConnectFailureReason(
  mqtt5.MqttConnectReasonCode? code,
) {
  return switch (code) {
    .notAuthorized || .badUsernameOrPassword => .notAuthorized,
    _ => .unknown,
  };
}

mqtt5.MqttQos mapDomainQosToPackage(MqttQos qos) {
  return switch (qos) {
    MqttQos.atMostOnce => .atMostOnce,

    MqttQos.atLeastOnce => .atLeastOnce,

    MqttQos.exactlyOnce => .exactlyOnce,
  };
}

class Mqtt5ClientGateway implements MqttGateway {
  final StreamController<MqttGatewayState> _connectionStateController =
      StreamController.broadcast();
  final StreamController<MqttGatewayMessage> _messagesController =
      StreamController.broadcast();

  mqtt5.MqttServerClient get _connectedClient {
    if (_client == null) throw StateError('Can not use client when it is null');
    return _client!;
  }

  @override
  Stream<MqttGatewayState> get connectionState =>
      _connectionStateController.stream;

  @override
  Stream<MqttGatewayMessage> get messages => _messagesController.stream;

  mqtt5.MqttServerClient? _client;
  StreamSubscription? _updatesSubscription;

  @override
  Future<void> connect(MqttBrokerSettings settings) async {
    _client = mqtt5.MqttServerClient.withPort(
      settings.host,
      settings.clientId,
      settings.port,
    );
    _client!
      ..autoReconnect = false
      ..keepAlivePeriod = 30
      ..onConnected = () {
        _connectionStateController.add(MqttGatewayState.connected());
      }
      ..onDisconnected = () {
        final status = _client!.connectionStatus!;
        _connectionStateController.add(
          MqttGatewayState.disconnected(
            reason: mapDisconnectReason(
              origin: status.disconnectionOrigin,
              code: status.disconnectMessage.reasonCode,
            ),
          ),
        );
      };
    _connectionStateController.add(MqttGatewayState.connecting());
    try {
      await _client!.connect(settings.username, settings.password);
    } catch (_) {
      _connectionStateController.add(
        MqttGatewayState.disconnected(
          reason: mapConnectFailureReason(
            _client!.connectionStatus!.reasonCode,
          ),
        ),
      );
      rethrow;
    }
    _updatesSubscription?.cancel();
    _updatesSubscription = _client?.updates?.listen((messages) {
      for (final m in messages) {
        final topic = m.topic;
        if (topic == null) {
          continue;
        }
        final payload = (m.payload as mqtt5.MqttPublishMessage).payload;
        if (payload.message == null) {
          continue;
        }
        _messagesController.add(
          MqttGatewayMessage(
            topic: topic,
            payload: mqtt5.MqttUtilities.bytesToStringAsString(
              payload.message!,
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
      mapDomainQosToPackage(qos),
      Uint8Buffer()..addAll(utf8.encode(payload)),
      retain: retain,
    );
  }

  @override
  void subscribe(String topicFilter, {MqttQos qos = .atLeastOnce}) {
    _connectedClient.subscribe(topicFilter, mapDomainQosToPackage(qos));
  }

  @override
  void unsubscribe(String topicFilter) {
    _connectedClient.unsubscribeStringTopic(topicFilter);
  }
}
