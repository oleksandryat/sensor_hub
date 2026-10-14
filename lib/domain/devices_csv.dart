import 'package:intl/intl.dart';

import 'device.dart';

final _timestamp = DateFormat('yyyy-MM-dd HH:mm:ss');

/// Serializes a device snapshot into CSV (header + one row per device).
String devicesToCsv(List<Device> devices) {
  final rows = devices.map((d) {
    final last = d.last;
    return [
      d.id,
      d.online,
      last?.value.toStringAsFixed(2) ?? '',
      last?.unit ?? '',
      d.lastSeen == null ? '' : _timestamp.format(d.lastSeen!),
    ].join(',');
  });
  return ['id,online,value,unit,last_seen', ...rows].join('\n');
}
