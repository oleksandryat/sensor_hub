import 'package:flutter/material.dart';

/// Native Lab list entry; disabled while [onTap] is null.
class DemoTile extends StatelessWidget {
  final Key? tileKey;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const DemoTile({
    super.key,
    this.tileKey,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: tileKey,
      enabled: onTap != null,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
