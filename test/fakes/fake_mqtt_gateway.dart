import 'dart:async';
import 'dart:collection';

import 'package:sensor_hub/domain/mqtt_broker_settings.dart';
import 'package:sensor_hub/domain/mqtt_gateway.dart';
import 'package:sensor_hub/domain/mqtt_gateway_message.dart';
import 'package:sensor_hub/domain/mqtt_gateway_state.dart';
import 'package:sensor_hub/domain/mqtt_qos.dart';

class FakeMqttGateway implements MqttGateway {
  final StreamController<MqttGatewayMessage> _messages =
      StreamController.broadcast();
  final StreamController<MqttGatewayState> _connectionState =
      StreamController.broadcast();

  bool _connected = false;

  final Queue<(Object error, MqttDisconnectReason reason)?> connectResults =
      Queue();
  final List<MqttBrokerSettings> connectCalls = [];
  int disconnectCalls = 0;

  Completer<void>? connectGate;

  final Map<String, MqttQos> subscriptions = {};

  final List<({String topic, String payload, MqttQos qos, bool retain})>
  published = [];

  @override
  Stream<MqttGatewayState> get connectionState => _connectionState.stream;

  @override
  Stream<MqttGatewayMessage> get messages => _messages.stream;

  void emitState(MqttGatewayState state) {
    state.map(
      connecting: (_) {},
      connected: (_) => _connected = true,
      disconnected: (_) {
        _connected = false;
        subscriptions.clear();
      },
    );
    _connectionState.add(state);
  }

  void emitMessage({required String topic, required String payload}) {
    _messages.add(MqttGatewayMessage(topic: topic, payload: payload));
  }

  @override
  Future<void> connect(MqttBrokerSettings settings) async {
    connectCalls.add(settings);
    assert(connectResults.isNotEmpty, 'unscripted connect()');
    emitState(.connecting());
    if (connectGate case final gate?) await gate.future;
    final connectResult = connectResults.removeFirst();
    if (connectResult case (final error, final reason)) {
      emitState(.disconnected(reason: reason));
      throw error;
    }

    emitState(.connected());
  }

  @override
  Future<void> disconnect() async {
    disconnectCalls++;

    emitState(.disconnected(reason: .normal));
  }

  @override
  void publish({
    required String topic,
    required String payload,
    MqttQos qos = .atLeastOnce,
    bool retain = false,
  }) {
    if (!_connected) {
      throw StateError('Can not publish while disconnected');
    }
    published.add((topic: topic, payload: payload, qos: qos, retain: retain));
  }

  @override
  void subscribe(String topicFilter, {MqttQos qos = .atLeastOnce}) {
    if (!_connected) {
      throw StateError('Can not subscribe while disconnected');
    }
    subscriptions[topicFilter] = qos;
  }

  @override
  void unsubscribe(String topicFilter) {
    if (!_connected) {
      throw StateError('Can not unsubscribe while disconnected');
    }
    subscriptions.remove(topicFilter);
  }
}
