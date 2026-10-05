import 'dart:async';
import 'dart:convert';

import 'command.dart';
import 'command_ack.dart';
import 'command_result.dart';
import 'mqtt_gateway.dart';
import 'mqtt_topics.dart';

abstract interface class CommandDispatcher {
  Future<CommandResult> send(Command command, {required String deviceId});
}

class MqttCommandDispatcher implements CommandDispatcher {
  final MqttGateway _gateway;
  final MqttTopics _topics;
  final Duration _timeout;

  MqttCommandDispatcher(
    this._gateway,
    this._topics, [
    this._timeout = const Duration(seconds: 5),
  ]);

  @override
  Future<CommandResult> send(
    Command command, {
    required String deviceId,
  }) async {
    final cmdId = command.cmdId;
    final ackTopic = _topics.cmdAckFilter(deviceId);
    Completer<CommandAck?> ack = Completer();
    Completer<CommandAck?> timeout = Completer();
    _gateway.subscribe(ackTopic);
    final StreamSubscription sub = _gateway.messages.listen((m) {
      if (m.topic == ackTopic) {
        final decoded = CommandAck.fromJson(
          jsonDecode(m.payload) as Map<String, dynamic>,
        );
        if (decoded.cmdId == cmdId) {
          ack.complete(decoded);
        }
      }
    });
    _gateway.publish(
      topic: _topics.cmdTopic(deviceId),
      payload: jsonEncode(command.toJson()),
    );
    final timer = Timer(_timeout, () => timeout.complete(null));
    final result = await Future.any([ack.future, timeout.future]);
    unawaited(sub.cancel());
    timer.cancel();
    return switch (result) {
      CommandAck commandAck =>
        commandAck.ok
            ? CommandResult.succeeded(cmdId: cmdId)
            : CommandResult.failed(
                cmdId: cmdId,
                error: commandAck.error ?? 'unknown error',
              ),
      null => CommandResult.timedOut(cmdId: cmdId),
    };
  }
}
