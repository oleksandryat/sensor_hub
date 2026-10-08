import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/device.dart';
import 'stale_badge.dart';

class DeviceTile extends StatelessWidget {
  final Device device;

  const DeviceTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final last = device.last;
    final lastSeen = device.lastSeen;
    return Card(
      child: ListTile(
        key: Key('device_${device.id}'),
        leading: Icon(
          Icons.sensors,
          color: device.online ? null : Theme.of(context).colorScheme.outline,
        ),
        title: Text(device.id),
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
    );
  }
}
