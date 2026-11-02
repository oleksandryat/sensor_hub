import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorhub_native/sensorhub_native.dart';
import 'package:sensorhub_stats/sensorhub_stats.dart';

import '../../../../domain/latency_stats.dart';

part 'benchmark_cubit.freezed.dart';
part 'benchmark_state.dart';

typedef BenchmarkCall = FutureOr<void> Function();

class BenchmarkCubit extends Cubit<BenchmarkState> {
  final Map<BenchmarkMechanism, BenchmarkCall> _targets;
  final int callCount;
  final int warmUpCount;

  BenchmarkCubit(this._targets, {this.callCount = 1000, this.warmUpCount = 50})
    : super(const BenchmarkState());

  Future<void> run() async {
    if (state.status == BenchmarkStatus.running) return;
    emit(
      state.copyWith(status: BenchmarkStatus.running, results: [], error: null),
    );
    try {
      final results = <BenchmarkResult>[];
      for (final MapEntry(:key, :value) in _targets.entries) {
        // First calls pay for JIT and channel setup; keep them out.
        for (var i = 0; i < warmUpCount; i++) {
          await value();
        }
        final samples = <Duration>[];
        for (var i = 0; i < callCount; i++) {
          final watch = Stopwatch()..start();
          // Await only real futures
          final pending = value();
          if (pending is Future) await pending;
          samples.add(watch.elapsed);
        }
        results.add(
          BenchmarkResult(mechanism: key, stats: LatencyStats.of(samples)),
        );
        emit(state.copyWith(results: [...results]));
      }
      emit(state.copyWith(status: BenchmarkStatus.done));
    } on NativeException catch (e) {
      emit(
        state.copyWith(
          status: BenchmarkStatus.error,
          error: e.message ?? e.code,
        ),
      );
    } on StatsException catch (e) {
      emit(state.copyWith(status: BenchmarkStatus.error, error: e.message));
    }
  }
}
