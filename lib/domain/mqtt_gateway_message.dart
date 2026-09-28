import 'package:freezed_annotation/freezed_annotation.dart';

part 'mqtt_gateway_message.freezed.dart';

@freezed
abstract class MqttGatewayMessage with _$MqttGatewayMessage {
  const factory MqttGatewayMessage({
    required String topic,
    required String payload,
  }) = _MqttGatewayMessage;
}
