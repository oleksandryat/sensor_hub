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
      create: (_) => getIt<ConnectionCubit>(),
      child: const ConnectionView(),
    );
  }
}

class ConnectionView extends StatelessWidget {
  const ConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectionCubit, ConnectionCubitState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == ConnectionStatus.connected) {
          context.router.push(const DashboardRoute());
        }
      },
      builder: (context, state) {
        final cubit = context.read<ConnectionCubit>();
        return Scaffold(
          appBar: AppBar(title: const Text('Connection')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(child: ConnectionStatusChip(status: state.status)),
                const SizedBox(height: 24),
                BrokerForm(
                  status: state.status,
                  onConnect: (host, port, username, password) => cubit.connect(
                    host: host,
                    port: port,
                    username: username,
                    password: password,
                  ),
                  onDisconnect: cubit.disconnect,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
