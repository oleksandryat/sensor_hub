import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../domain/latency_stats.dart';
import '../cubit/benchmark_cubit.dart';

// Duration has µs resolution, so sub-µs FFI calls read as 0.
String _us(Duration d) => d == Duration.zero ? '<1' : '${d.inMicroseconds}';

@RoutePage()
class BenchmarkScreen extends StatelessWidget {
  const BenchmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BenchmarkCubit>(),
      child: const BenchmarkView(),
    );
  }
}

class BenchmarkView extends StatelessWidget {
  const BenchmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BenchmarkCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Call latency')),
      body: BlocBuilder<BenchmarkCubit, BenchmarkState>(
        builder: (context, state) {
          final running = state.status == BenchmarkStatus.running;
          return ListView(
            children: [
              ListTile(
                title: Text(
                  'MethodChannel vs Pigeon vs FFI',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  'Same work and same 50-sample window on every call: mean, '
                  'std dev and z-score. ${cubit.callCount} calls each, '
                  'median / p95. Use a release build for meaningful numbers.',
                ),
                trailing: FilledButton(
                  key: const Key('benchmark_run'),
                  onPressed: running ? null : cubit.run,
                  child: Text(running ? 'Running…' : 'Run'),
                ),
              ),
              if (state.status == BenchmarkStatus.error)
                ListTile(
                  key: const Key('benchmark_error'),
                  leading: const Icon(Icons.error_outline),
                  title: Text(state.error ?? 'Unknown error'),
                ),
              if (running) const LinearProgressIndicator(),
              for (final result in state.results)
                _ResultTile(result, fastest: state.fastestMedian),
            ],
          );
        },
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final BenchmarkResult result;
  final Duration? fastest;

  const _ResultTile(this.result, {required this.fastest});

  @override
  Widget build(BuildContext context) {
    final LatencyStats(:median, :p95) = result.stats;
    final (title, detail) = switch (result.mechanism) {
      BenchmarkMechanism.methodChannel => ('MethodChannel', 'Kotlin / Swift'),
      BenchmarkMechanism.pigeon => ('Pigeon', 'Kotlin / Swift, typed'),
      BenchmarkMechanism.ffi => ('FFI', 'C, synchronous'),
    };
    final fastest = this.fastest;
    final String comparison;
    if (fastest == null || median <= fastest) {
      comparison = 'fastest';
    } else if (fastest == Duration.zero) {
      // The baseline is under 1 µs, so the real ratio is at least this.
      comparison = '≥×${median.inMicroseconds} vs fastest';
    } else {
      final factor = median.inMicroseconds / fastest.inMicroseconds;
      comparison = '×${factor.toStringAsFixed(1)} vs fastest';
    }
    return ListTile(
      key: Key('benchmark_${result.mechanism.name}'),
      title: Text(title),
      subtitle: Text('$detail · $comparison'),
      trailing: Text('${_us(median)} / ${_us(p95)} µs'),
    );
  }
}
