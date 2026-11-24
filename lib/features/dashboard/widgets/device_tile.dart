import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/device.dart';
import 'command_buttons.dart';
import 'stale_badge.dart';

class DeviceTile extends StatelessWidget {
  final Device device;

  const DeviceTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final last = device.last;
    final lastSeen = device.lastSeen;
    return Card(
      child: Column(
        children: [
          ListTile(
            key: Key('device_${device.id}'),
            leading: device.online
                ? const Icon(Icons.sensors)
                : Icon(
                    Icons.sensors_off,
                    key: const Key('device_offline_icon'),
                    color: Theme.of(context).colorScheme.error,
                  ),
            title: Text(device.online ? device.id : '${device.id} · offline'),
            subtitle: Text(
              lastSeen == null
                  ? 'No data yet'
                  : 'Last seen ${DateFormat.Hms().format(lastSeen)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (device.isStale) const StaleBadge(),
                if (last != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${last.value.toStringAsFixed(1)} ${last.unit}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ],
            ),
          ),
          CommandButtons(deviceId: device.id),
        ],
      ),
    );
  }
}
