import 'package:freezed_annotation/freezed_annotation.dart';

part 'mqtt_gateway_state.freezed.dart';

enum MqttDisconnectReason {
  normal,
  connectionLost,
  sessionTakenOver,
  notAuthorized,
  unknown,
}

@freezed
sealed class MqttGatewayState with _$MqttGatewayState {
  const factory MqttGatewayState.connecting() = _Connecting;

  const factory MqttGatewayState.connected() = _Connected;

  const factory MqttGatewayState.disconnected({
    required MqttDisconnectReason reason,
  }) = _Disconnected;
}
