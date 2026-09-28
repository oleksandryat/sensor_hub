import 'package:freezed_annotation/freezed_annotation.dart';

part 'mqtt_broker_settings.freezed.dart';

@freezed
abstract class MqttBrokerSettings with _$MqttBrokerSettings {
  const factory MqttBrokerSettings({
    required String host,
    required int port,
    required String clientId,
    required String username,
    required String password,
  }) = _MqttBrokerSettings;
}
