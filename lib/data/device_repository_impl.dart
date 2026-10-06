import 'dart:async';
import 'dart:convert';

import '../domain/connection_manager.dart';
import '../domain/device.dart';
import '../domain/device_repository.dart';
import '../domain/device_status.dart';
import '../domain/mqtt_gateway.dart';
import '../domain/mqtt_gateway_message.dart';
import '../domain/mqtt_topics.dart';
import '../domain/telemetry.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final MqttGateway _gateway;
  final ConnectionManager _connection;
  final MqttTopics _topics;
  final DateTime Function() _now;
  final Duration _staleThreshold;

  DeviceRepositoryImpl({
    required this._gateway,
    required this._connection,
    required this._topics,
    required this._now,
    required this._staleThreshold,
  });

  final Map<String, Device> _devices = {};

  final StreamController<List<Device>> _controller =
      StreamController.broadcast();

  Timer? _staleCheckTimer;

  StreamSubscription? _messagesSubscription;

  @override
  Stream<List<Device>> get devices => _controller.stream;

  @override
  void start() {
    _staleCheckTimer = Timer.periodic(Duration(seconds: 1), (_) {
      bool changed = false;
      for (final d in _devices.values) {
        if (d.lastSeen == null) continue;

        final stale = _now().difference(d.lastSeen!) > _staleThreshold;

        if (d.isStale == stale) continue;
        changed = true;
        _devices[d.id] = d.copyWith(isStale: stale);
      }
      if (changed) _emit();
    });
    // goes through the manager: it queues while offline and resubscribes
    _connection.subscribe(_topics.telemetryFilter);
    _connection.subscribe(_topics.statusFilter);
    _messagesSubscription = _gateway.messages.listen(_onMessage);
  }

  void _onMessage(MqttGatewayMessage m) {
    if (!m.topic.startsWith(_topics.prefix)) return;
    final suffix = m.topic.substring(_topics.prefix.length);
    final parts = suffix.split('/');
    if (parts case ['devices', String id, 'telemetry']) {
      _onTelemetry(id, m.payload);
    }
    if (parts case ['devices', String id, 'status']) {
      _onStatus(id, m.payload);
    }
  }

  void _onTelemetry(String id, String payload) {
    try {
      final telemetry = Telemetry.fromJson(
        jsonDecode(payload) as Map<String, dynamic>,
      );
      final lastSeen = _now();
      _update(
        id,
        (d) => d.copyWith(last: telemetry, lastSeen: lastSeen, isStale: false),
      );
    } catch (_) {
      return;
    }
  }

  void _onStatus(String id, String payload) {
    try {
      final status = DeviceStatus.fromJson(
        jsonDecode(payload) as Map<String, dynamic>,
      );
      _update(id, (d) => d.copyWith(online: status.online));
    } catch (_) {
      return;
    }
  }

  void _update(String id, Device Function(Device) change) {
    final device = _devices[id] ?? Device(id: id, online: true, isStale: false);
    final updated = change(device);
    _devices[id] = updated;
    _emit();
  }

  void _emit() {
    _controller.add(
      _devices.values.toList()..sort((a, b) => a.id.compareTo(b.id)),
    );
  }

  @override
  void dispose() {
    _staleCheckTimer?.cancel();
    _messagesSubscription?.cancel();
    _controller.close();
  }
}
