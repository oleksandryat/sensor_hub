import 'dart:async';

import 'backoff_policy.dart';
import 'connection_status.dart';
import 'mqtt_broker_settings.dart';
import 'mqtt_gateway.dart';
import 'mqtt_gateway_state.dart';
import 'mqtt_qos.dart';

class ConnectionManager {
  final MqttGateway _gateway;
  final BackoffPolicy _backoff;

  late final StreamSubscription _sub;

  Timer? _reconnectTimer;

  MqttBrokerSettings? _settings;

  final Map<String, MqttQos> _subs = {};

  ConnectionStatus _status = .disconnected;

  ConnectionManager(this._gateway, this._backoff) {
    _sub = _gateway.connectionState.listen((state) {
      state.map(
        connecting: (_) {
          if (_status == .reconnecting) {
            return;
          } else {
            _emitStatus(.connecting);
          }
        },
        connected: (_) {
          if (_settings == null) {
            _gateway.disconnect();
            return;
          }
          _backoff.reset();
          _emitStatus(.connected);
          for (final e in _subs.entries) {
            _gateway.subscribe(e.key, qos: e.value);
          }
        },
        disconnected: (value) {
          switch (_status) {
            case ConnectionStatus.connecting:
              if (value.reason == .normal) {
                _emitStatus(.disconnected);
              } else {
                _emitStatus(.error);
              }
            case ConnectionStatus.reconnecting:
              switch (value.reason) {
                case MqttDisconnectReason.connectionLost ||
                    MqttDisconnectReason.unknown:
                  _scheduleReconnect();
                case MqttDisconnectReason.notAuthorized:
                  _emitStatus(.error);
                default:
                  _emitStatus(.disconnected);
              }
            case ConnectionStatus.connected:
              switch (value.reason) {
                case MqttDisconnectReason.connectionLost:
                  _emitStatus(.reconnecting);
                  _scheduleReconnect();
                case MqttDisconnectReason.notAuthorized:
                  _emitStatus(.error);
                case MqttDisconnectReason.sessionTakenOver:
                  _emitStatus(.disconnected);
                default:
                  _emitStatus(.disconnected);
              }
            default:
          }
        },
      );
    });
  }

  void _scheduleReconnect() {
    if (_settings != null) {
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(_backoff.nextDelay(), () => connect(_settings!));
    }
  }

  void dispose() {
    _sub.cancel();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  final StreamController<ConnectionStatus> _statusController =
      StreamController.broadcast();

  ConnectionStatus get currentStatus => _status;

  Stream<ConnectionStatus> get status => _statusController.stream;

  void _emitStatus(ConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  Future<void> connect(MqttBrokerSettings settings) async {
    try {
      _settings = settings;
      _reconnectTimer?.cancel();
      await _gateway.connect(settings);
    } catch (_) {}
  }

  Future<void> disconnect() async {
    _settings = null;
    _reconnectTimer?.cancel();
    await _gateway.disconnect();
  }

  void subscribe(String topicFilter, {MqttQos qos = .atLeastOnce}) {
    _subs[topicFilter] = qos;
    if (_status != .connected) return;
    return _gateway.subscribe(topicFilter, qos: qos);
  }

  void unsubscribe(String topicFilter) {
    _subs.remove(topicFilter);
    if (_status != .connected) return;
    return _gateway.unsubscribe(topicFilter);
  }
}
