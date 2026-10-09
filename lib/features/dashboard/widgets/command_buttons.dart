import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/dashboard_cubit.dart';
import 'set_interval_dialog.dart';

class CommandButtons extends StatelessWidget {
  final String deviceId;

  const CommandButtons({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final enabled = context.select<DashboardCubit, bool>(
      (c) => !c.state.isOffline && !c.state.sending.contains(deviceId),
    );
    final sending = context.select<DashboardCubit, bool>(
      (c) => c.state.sending.contains(deviceId),
    );
    final cubit = context.read<DashboardCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (sending)
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: SizedBox(
              key: Key('command_progress'),
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        TextButton(
          key: Key('reboot_$deviceId'),
          onPressed: enabled ? () => cubit.reboot(deviceId) : null,
          child: const Text('Reboot'),
        ),
        TextButton(
          key: Key('set_interval_$deviceId'),
          onPressed: enabled
              ? () async {
                  final seconds = await showDialog<int>(
                    context: context,
                    builder: (_) => const SetIntervalDialog(),
                  );
                  if (seconds != null) cubit.setInterval(deviceId, seconds);
                }
              : null,
          child: const Text('Interval'),
        ),
      ],
    );
  }
}
