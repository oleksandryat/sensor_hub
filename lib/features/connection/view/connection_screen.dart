import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/connection_status.dart';
import '../cubit/connection_cubit.dart';
import '../widgets/broker_form.dart';
import '../widgets/connection_status_chip.dart';

@RoutePage()
class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConnectionCubit>()..loadSaved(),
      child: const ConnectionView(),
    );
  }
}

class ConnectionView extends StatelessWidget {
  const ConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectionCubit, ConnectionCubitState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == ConnectionStatus.connected) {
              context.router.push(const DashboardRoute());
            }
          },
        ),
        BlocListener<ConnectionCubit, ConnectionCubitState>(
          listenWhen: (prev, curr) =>
              curr.vaultError != null && prev.vaultError != curr.vaultError,
          listener: (context, state) => ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(content: Text('Secure storage: ${state.vaultError}')),
              ),
        ),
      ],
      child: BlocBuilder<ConnectionCubit, ConnectionCubitState>(
        builder: (context, state) {
          final cubit = context.read<ConnectionCubit>();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Connection'),
              actions: [
                IconButton(
                  key: const Key('native_lab_button'),
                  tooltip: 'Native Lab',
                  icon: const Icon(Icons.science_outlined),
                  onPressed: () => context.router.push(const NativeLabRoute()),
                ),
              ],
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(child: ConnectionStatusChip(status: state.status)),
                  const SizedBox(height: 24),
                  BrokerForm(
                    status: state.status,
                    saved: state.saved,
                    onConnect: (host, port, username, password, remember) =>
                        cubit.connect(
                          host: host,
                          port: port,
                          username: username,
                          password: password,
                          remember: remember,
                        ),
                    onDisconnect: cubit.disconnect,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
