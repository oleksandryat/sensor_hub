import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../../../domain/latency_stats.dart';

part 'system_events_cubit.freezed.dart';
part 'system_events_state.dart';

class SystemEventsCubit extends Cubit<SystemEventsState> {
  static const maxEvents = 50;

  /// Number of doubles in the ping payload: tiny vs a realistic batch.
  static const payloadSizes = [1, 1000];

  final SensorhubNative _native;
  final int pingCount;
  final int warmUpCount;

  StreamSubscription<SystemEvent>? _eventsSub;

  SystemEventsCubit(this._native, {this.pingCount = 100, this.warmUpCount = 10})
    : super(const SystemEventsState());

  void start() {
    _eventsSub ??= _native.systemEvents.listen(
      (event) => emit(
        state.copyWith(events: [event, ...state.events.take(maxEvents - 1)]),
      ),
    );
  }

  Future<void> runPing() async {
    if (state.pingStatus == PingStatus.running) return;
    emit(
      state.copyWith(pingStatus: PingStatus.running, results: [], error: null),
    );
    try {
      final results = <PingResult>[];
      for (final size in payloadSizes) {
        final payload = List.generate(size, (i) => i + 0.5);
        for (final codec in PingCodec.values) {
          // First calls pay for JIT and channel setup; keep them out.
          for (var i = 0; i < warmUpCount; i++) {
            await _native.ping(codec, payload: payload);
          }
          final samples = [
            for (var i = 0; i < pingCount; i++)
              await _native.ping(codec, payload: payload),
          ];
          results.add(
            PingResult(
              codec: codec,
              payloadSize: size,
              stats: LatencyStats.of(samples),
            ),
          );
        }
      }
      emit(state.copyWith(pingStatus: PingStatus.done, results: results));
    } on NativeException catch (e) {
      emit(
        state.copyWith(
          pingStatus: PingStatus.error,
          error: e.message ?? e.code,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _eventsSub?.cancel();
    return super.close();
  }
}
