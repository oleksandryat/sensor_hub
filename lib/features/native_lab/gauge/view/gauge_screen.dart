import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../../../core/di/injection.dart';
import '../cubit/gauge_cubit.dart';

@RoutePage()
class GaugeScreen extends StatelessWidget {
  const GaugeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GaugeCubit>()..start(),
      child: const GaugeView(),
    );
  }
}

class GaugeView extends StatelessWidget {
  static const maxValue = 30.0;

  const GaugeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native gauge')),
      body: BlocBuilder<GaugeCubit, GaugeState>(
        builder: (context, state) {
          if (state.status == GaugeStatus.error) {
            return ListTile(
              key: const Key('gauge_error'),
              leading: const Icon(Icons.error_outline),
              title: Text(state.error ?? 'Unknown error'),
            );
          }
          return Center(
            child: SizedBox.square(
              dimension: 280,
              child: NativeGauge(
                key: const Key('native_gauge'),
                min: 0,
                max: maxValue,
                unit: 'm/s²',
                value: state.value,
              ),
            ),
          );
        },
      ),
    );
  }
}
