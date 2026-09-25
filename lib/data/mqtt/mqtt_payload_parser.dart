import 'dart:convert';

import '../../domain/command_ack.dart';
import '../../domain/telemetry.dart';

Telemetry parseTelemetry(String payload) {
  return Telemetry.fromJson(jsonDecode(payload) as Map<String, dynamic>);
}

CommandAck parseCommandAck(String payload) {
  return CommandAck.fromJson(jsonDecode(payload) as Map<String, dynamic>);
}
