import 'package:flutter/material.dart';

class StaleBadge extends StatelessWidget {
  const StaleBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      key: const Key('stale_badge'),
      label: const Text('Stale'),
      visualDensity: VisualDensity.compact,
      backgroundColor: scheme.tertiaryContainer,
    );
  }
}
