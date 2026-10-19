import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../../../core/di/injection.dart';
import '../../../../domain/latency_stats.dart';
import '../cubit/system_events_cubit.dart';

final _time = DateFormat('HH:mm:ss.SSS');

String _ms(Duration d) => (d.inMicroseconds / 1000).toStringAsFixed(2);

@RoutePage()
class SystemEventsScreen extends StatelessWidget {
  const SystemEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SystemEventsCubit>()..start(),
      child: const SystemEventsView(),
    );
  }
}

class SystemEventsView extends StatelessWidget {
  const SystemEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('System events')),
      body: BlocBuilder<SystemEventsCubit, SystemEventsState>(
        builder: (context, state) {
          final running = state.pingStatus == PingStatus.running;
          return ListView(
            children: [
              ListTile(
                title: Text('Ping round trip', style: textTheme.titleMedium),
                subtitle: Text(
                  'Median / p95 of ${context.read<SystemEventsCubit>().pingCount} '
                  'echoes per codec and payload',
                ),
                trailing: FilledButton(
                  key: const Key('ping_run'),
                  onPressed: running
                      ? null
                      : context.read<SystemEventsCubit>().runPing,
                  child: Text(running ? 'Running…' : 'Run'),
                ),
              ),
              if (state.pingStatus == PingStatus.error)
                ListTile(
                  key: const Key('ping_error'),
                  leading: const Icon(Icons.error_outline),
                  title: Text(state.error ?? 'Unknown error'),
                ),
              for (final result in state.results) _PingResultTile(result),
              const Divider(),
              ListTile(
                title: Text('Native events', style: textTheme.titleMedium),
                subtitle: const Text(
                  'Background the app, or trigger memory pressure: '
                  'adb shell am send-trim-memory <package> RUNNING_LOW, '
                  'Simulator › Debug › Simulate Memory Warning',
                ),
              ),
              if (state.events.isEmpty)
                const ListTile(
                  key: Key('events_empty'),
                  title: Text('No events yet'),
                )
              else
                for (final event in state.events) _EventTile(event),
            ],
          );
        },
      ),
    );
  }
}

class _PingResultTile extends StatelessWidget {
  final PingResult result;

  const _PingResultTile(this.result);

  @override
  Widget build(BuildContext context) {
    final LatencyStats(:median, :p95) = result.stats;
    final codec = switch (result.codec) {
      PingCodec.json => 'JSONMessageCodec',
      PingCodec.standard => 'StandardMessageCodec',
    };
    return ListTile(
      key: Key('ping_${result.codec.name}_${result.payloadSize}'),
      dense: true,
      title: Text(codec),
      subtitle: Text('${result.payloadSize} doubles'),
      trailing: Text('${_ms(median)} / ${_ms(p95)} ms'),
    );
  }
}

class _EventTile extends StatelessWidget {
  final SystemEvent event;

  const _EventTile(this.event);

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = switch (event) {
      MemoryPressureEvent(:final level, :final source) => (
        Icons.memory,
        'Memory pressure: ${level.name}',
        source,
      ),
      LifecycleEvent(:final foreground) => (
        foreground ? Icons.visibility : Icons.visibility_off,
        foreground ? 'App in foreground' : 'App in background',
        null,
      ),
    };
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: Text(_time.format(event.timestamp)),
    );
  }
}
