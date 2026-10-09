import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../cubit/dashboard_cubit.dart';
import '../widgets/device_list.dart';
import '../widgets/offline_banner.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..start(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listenWhen: (p, c) => c.feedback != null && p.feedback != c.feedback,
      listener: (context, state) {
        final feedback = state.feedback!;
        final message = switch (feedback.result) {
          final r when r.isSuccess => '${feedback.deviceId}: acknowledged',
          final r when r.error != null => '${feedback.deviceId}: ${r.error}',
          _ => '${feedback.deviceId}: no response in time',
        };
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return Column(
              children: [
                if (state.isOffline) const OfflineBanner(),
                Expanded(
                  child: switch (state.status) {
                    DashboardStatus.loading => const Center(
                      key: Key('loading_state'),
                      child: CircularProgressIndicator(),
                    ),
                    DashboardStatus.error => const Center(
                      key: Key('error_state'),
                      child: Text('Connection error'),
                    ),
                    DashboardStatus.loaded => DeviceList(
                      devices: state.devices,
                    ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
