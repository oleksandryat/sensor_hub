import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../cubit/device_info_cubit.dart';

@RoutePage()
class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DeviceInfoCubit>()..load(),
      child: const DeviceInfoView(),
    );
  }
}

class DeviceInfoView extends StatelessWidget {
  const DeviceInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device info')),
      body: BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
        builder: (context, state) {
          final info = state.info;
          return switch (state.status) {
            DeviceInfoStatus.loading => const Center(
              key: Key('device_info_loading'),
              child: CircularProgressIndicator(),
            ),
            DeviceInfoStatus.error => Center(
              key: const Key('device_info_error'),
              child: Text(state.error ?? 'Unknown error'),
            ),
            DeviceInfoStatus.loaded => ListView(
              children: [
                ListTile(
                  title: const Text('Platform'),
                  subtitle: Text(info!.platform),
                ),
                ListTile(
                  title: const Text('Manufacturer'),
                  subtitle: Text(info.manufacturer),
                ),
                ListTile(
                  title: const Text('Model'),
                  subtitle: Text(info.model),
                ),
                ListTile(
                  title: const Text('OS version'),
                  subtitle: Text(info.osVersion),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}
