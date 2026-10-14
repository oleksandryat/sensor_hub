import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';
import '../widgets/demo_tile.dart';

@RoutePage()
class NativeLabScreen extends StatelessWidget {
  const NativeLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final router = context.router;
    return Scaffold(
      appBar: AppBar(title: const Text('Native Lab')),
      body: ListView(
        children: [
          DemoTile(
            tileKey: const Key('demo_device_info'),
            icon: Icons.phone_android,
            title: 'Device info',
            subtitle: 'MethodChannel',
            onTap: () => router.push(const DeviceInfoRoute()),
          ),
          DemoTile(
            tileKey: const Key('demo_export'),
            icon: Icons.ios_share,
            title: 'Export telemetry',
            subtitle: 'MethodChannel + native share sheet',
            onTap: () => router.push(const ExportRoute()),
          ),
          const DemoTile(
            icon: Icons.sensors,
            title: 'Phone as sensor',
            subtitle: 'EventChannel (coming soon)',
          ),
          const DemoTile(
            icon: Icons.memory,
            title: 'System events',
            subtitle: 'BasicMessageChannel (coming soon)',
          ),
        ],
      ),
    );
  }
}
