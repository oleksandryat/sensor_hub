import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../cubit/phone_sensor_cubit.dart';

@RoutePage()
class PhoneSensorScreen extends StatelessWidget {
  const PhoneSensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PhoneSensorCubit>()..start(),
      child: const PhoneSensorView(),
    );
  }
}

class PhoneSensorView extends StatelessWidget {
  const PhoneSensorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone as sensor')),
      body: BlocBuilder<PhoneSensorCubit, PhoneSensorState>(
        builder: (context, state) {
          final sample = state.sample;
          return ListView(
            children: [
              if (state.status == PhoneSensorStatus.error)
                ListTile(
                  key: const Key('sensor_error'),
                  leading: const Icon(Icons.error_outline),
                  title: Text(state.error ?? 'Unknown error'),
                )
              else if (sample == null)
                const ListTile(
                  key: Key('sensor_waiting'),
                  title: Text('Waiting for the first reading…'),
                )
              else ...[
                _AxisTile(
                  tileKey: const Key('sensor_x'),
                  label: 'X',
                  value: sample.x,
                ),
                _AxisTile(
                  tileKey: const Key('sensor_y'),
                  label: 'Y',
                  value: sample.y,
                ),
                _AxisTile(
                  tileKey: const Key('sensor_z'),
                  label: 'Z',
                  value: sample.z,
                ),
                _AxisTile(
                  tileKey: const Key('sensor_magnitude'),
                  label: '|a|',
                  value: sample.magnitude,
                ),
              ],
              const Divider(),
              SwitchListTile(
                key: const Key('sensor_publish_switch'),
                title: const Text('Publish over MQTT'),
                subtitle: Text(
                  state.connected
                      ? 'Sends |a| about once per second'
                      : 'Connect to a broker first',
                ),
                value: state.publishing,
                onChanged: state.connected || state.publishing
                    ? context.read<PhoneSensorCubit>().setPublishing
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AxisTile extends StatelessWidget {
  final Key tileKey;
  final String label;
  final double value;

  const _AxisTile({
    required this.tileKey,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: tileKey,
      title: Text(label),
      trailing: Text('${value.toStringAsFixed(2)} m/s²'),
    );
  }
}
