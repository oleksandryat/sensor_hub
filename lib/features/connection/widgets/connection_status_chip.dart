import 'package:flutter/material.dart';

import '../../../domain/connection_status.dart';

class ConnectionStatusChip extends StatelessWidget {
  final ConnectionStatus status;

  const ConnectionStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      ConnectionStatus.disconnected => ('Disconnected', scheme.outline),
      ConnectionStatus.connecting => ('Connecting…', scheme.tertiary),
      ConnectionStatus.connected => ('Connected', scheme.primary),
      ConnectionStatus.reconnecting => ('Reconnecting…', scheme.tertiary),
      ConnectionStatus.error => ('Error', scheme.error),
    };
    return Chip(
      key: const Key('connection_status_chip'),
      avatar: Icon(Icons.circle, size: 12, color: color),
      label: Text(label),
    );
  }
}
