import 'mqtt_broker_settings.dart';
import 'mqtt_gateway_message.dart';
import 'mqtt_gateway_state.dart';
import 'mqtt_qos.dart';

abstract interface class MqttGateway {
  Stream<MqttGatewayState> get connectionState;

  Stream<MqttGatewayMessage> get messages;

  Future<void> connect(MqttBrokerSettings settings);

  Future<void> disconnect();

  void subscribe(String topicFilter, {MqttQos qos = .atLeastOnce});

  void unsubscribe(String topicFilter);

  void publish({
    required String topic,
    required String payload,
    MqttQos qos = .atLeastOnce,
    bool retain = false,
  });
}
