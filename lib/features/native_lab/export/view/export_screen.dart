import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../cubit/export_cubit.dart';

@RoutePage()
class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExportCubit>()..start(),
      child: const ExportView(),
    );
  }
}

class ExportView extends StatelessWidget {
  const ExportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export telemetry')),
      body: BlocBuilder<ExportCubit, ExportState>(
        builder: (context, state) {
          final canExport =
              state.deviceCount > 0 && state.status != ExportStatus.sharing;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  state.deviceCount == 0
                      ? 'No device data yet. Connect to a broker first.'
                      : '${state.deviceCount} device(s) ready to export as CSV.',
                  key: const Key('export_summary'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  key: const Key('export_button'),
                  onPressed: canExport
                      ? context.read<ExportCubit>().export
                      : null,
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Share'),
                ),
                const SizedBox(height: 16),
                if (state.status == ExportStatus.done)
                  Text(
                    'Share sheet: ${state.outcome!.name}',
                    key: const Key('export_result'),
                  ),
                if (state.status == ExportStatus.error)
                  Text(
                    state.error ?? 'Unknown error',
                    key: const Key('export_error'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
