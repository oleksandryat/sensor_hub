import 'package:flutter/material.dart';

import '../../../domain/device.dart';
import 'device_tile.dart';

class DeviceList extends StatelessWidget {
  final List<Device> devices;

  const DeviceList({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const Center(
        key: Key('empty_state'),
        child: Text('No devices yet'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: devices.length,
      itemBuilder: (_, i) => DeviceTile(device: devices[i]),
    );
  }
}
