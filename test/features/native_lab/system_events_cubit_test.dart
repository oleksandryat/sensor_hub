import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/features/native_lab/system_events/cubit/system_events_cubit.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

class MockNative extends Mock implements SensorhubNative {}

void main() {
  late MockNative native;
  late StreamController<SystemEvent> events;

  LifecycleEvent lifecycle(int ms) => LifecycleEvent(
    foreground: ms.isEven,
    timestamp: DateTime.fromMillisecondsSinceEpoch(ms),
  );

  setUpAll(() => registerFallbackValue(PingCodec.json));

  setUp(() {
    native = MockNative();
    events = StreamController.broadcast();
    when(() => native.systemEvents).thenAnswer((_) => events.stream);
  });

  tearDown(() => events.close());

  SystemEventsCubit build() =>
      SystemEventsCubit(native, pingCount: 3, warmUpCount: 1);

  blocTest<SystemEventsCubit, SystemEventsState>(
    'prepends native events',
    build: build,
    act: (c) async {
      c.start();
      events
        ..add(lifecycle(1))
        ..add(lifecycle(2));
      await pumpEventQueue();
    },
    expect: () => [
      SystemEventsState(events: [lifecycle(1)]),
      SystemEventsState(events: [lifecycle(2), lifecycle(1)]),
    ],
  );

  blocTest<SystemEventsCubit, SystemEventsState>(
    'keeps at most maxEvents',
    build: build,
    act: (c) async {
      c.start();
      for (var i = 0; i <= SystemEventsCubit.maxEvents; i++) {
        events.add(lifecycle(i));
      }
      await pumpEventQueue();
    },
    skip: SystemEventsCubit.maxEvents,
    expect: () => [
      isA<SystemEventsState>()
          .having((s) => s.events.length, 'length', SystemEventsCubit.maxEvents)
          .having(
            (s) => s.events.first,
            'newest',
            lifecycle(SystemEventsCubit.maxEvents),
          ),
    ],
  );

  blocTest<SystemEventsCubit, SystemEventsState>(
    'runPing excludes warm-up and reports stats per codec and payload',
    setUp: () {
      var call = 0;
      // Warm-up call of each series is slow; it must not reach the stats.
      when(() => native.ping(any(), payload: any(named: 'payload'))).thenAnswer(
        (_) async => Duration(milliseconds: call++ % 4 == 0 ? 100 : call % 4),
      );
    },
    build: build,
    act: (c) => c.runPing(),
    expect: () => [
      const SystemEventsState(pingStatus: PingStatus.running),
      isA<SystemEventsState>()
          .having((s) => s.pingStatus, 'status', PingStatus.done)
          .having(
            (s) => [for (final r in s.results) (r.codec, r.payloadSize)],
            'series',
            [
              (PingCodec.json, 1),
              (PingCodec.standard, 1),
              (PingCodec.json, 1000),
              (PingCodec.standard, 1000),
            ],
          )
          .having(
            (s) => s.results.map((r) => r.stats.max),
            'max',
            everyElement(lessThan(const Duration(milliseconds: 100))),
          )
          .having(
            (s) => s.results.map((r) => r.stats.count),
            'count',
            everyElement(3),
          ),
    ],
    verify: (_) =>
        verify(() => native.ping(any(), payload: any(named: 'payload')))
            .called(16),
  );

  blocTest<SystemEventsCubit, SystemEventsState>(
    'runPing reports native errors',
    setUp: () => when(
      () => native.ping(any(), payload: any(named: 'payload')),
    ).thenThrow(const NativeException('unavailable', 'No native ping handler')),
    build: build,
    act: (c) => c.runPing(),
    expect: () => [
      const SystemEventsState(pingStatus: PingStatus.running),
      const SystemEventsState(
        pingStatus: PingStatus.error,
        error: 'No native ping handler',
      ),
    ],
  );

  test('close cancels the native events subscription', () async {
    final cubit = build()..start();
    await cubit.close();

    expect(events.hasListener, isFalse);
  });
}
