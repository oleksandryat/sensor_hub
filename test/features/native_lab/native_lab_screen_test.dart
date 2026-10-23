import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/core/router/app_router.dart';
import 'package:sensor_hub/domain/latency_stats.dart';
import 'package:sensor_hub/features/native_lab/device_info/cubit/device_info_cubit.dart';
import 'package:sensor_hub/features/native_lab/device_info/view/device_info_screen.dart';
import 'package:sensor_hub/features/native_lab/phone_sensor/cubit/phone_sensor_cubit.dart';
import 'package:sensor_hub/features/native_lab/phone_sensor/view/phone_sensor_screen.dart';
import 'package:sensor_hub/features/native_lab/system_events/cubit/system_events_cubit.dart';
import 'package:sensor_hub/features/native_lab/system_events/view/system_events_screen.dart';
import 'package:sensor_hub/features/native_lab/view/native_lab_screen.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../helpers/helpers.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakeRoute extends Fake implements PageRouteInfo {}

class MockDeviceInfoCubit extends MockCubit<DeviceInfoState>
    implements DeviceInfoCubit {}

class MockPhoneSensorCubit extends MockCubit<PhoneSensorState>
    implements PhoneSensorCubit {}

class MockSystemEventsCubit extends MockCubit<SystemEventsState>
    implements SystemEventsCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
    registerFallbackValue(DeviceInfoSource.pigeon);
  });

  testWidgets('lab list opens the demo routes', (tester) async {
    final router = MockStackRouter();
    when(() => router.push(any())).thenAnswer((_) async => null);
    await tester.pumpApp(
      StackRouterScope(
        controller: router,
        stateHash: 0,
        child: const NativeLabScreen(),
      ),
    );

    await tester.tap(find.byKey(const Key('demo_device_info')));
    await tester.tap(find.byKey(const Key('demo_export')));
    await tester.tap(find.byKey(const Key('demo_phone_sensor')));
    await tester.tap(find.byKey(const Key('demo_system_events')));

    verify(() => router.push(const DeviceInfoRoute())).called(1);
    verify(() => router.push(const ExportRoute())).called(1);
    verify(() => router.push(const PhoneSensorRoute())).called(1);
    verify(() => router.push(const SystemEventsRoute())).called(1);
  });

  testWidgets('device info shows loaded values', (tester) async {
    await tester.pumpView<DeviceInfoCubit, DeviceInfoState>(
      const DeviceInfoView(),
      cubit: MockDeviceInfoCubit(),
      state: const DeviceInfoState(
        status: DeviceInfoStatus.loaded,
        info: NativeDeviceInfo(
          platform: 'Android',
          manufacturer: 'Google',
          model: 'Pixel 9',
          osVersion: 'Android 16',
        ),
      ),
    );

    expect(find.text('Pixel 9'), findsOneWidget);
    expect(find.text('Android 16'), findsOneWidget);
  });

  testWidgets('device info source toggle reloads through Pigeon', (
    tester,
  ) async {
    final cubit = MockDeviceInfoCubit();
    when(() => cubit.load(any())).thenAnswer((_) async {});
    await tester.pumpView<DeviceInfoCubit, DeviceInfoState>(
      const DeviceInfoView(),
      cubit: cubit,
      state: const DeviceInfoState(status: DeviceInfoStatus.error, error: 'x'),
    );

    await tester.tap(find.text('Pigeon'));

    verify(() => cubit.load(DeviceInfoSource.pigeon)).called(1);
  });

  testWidgets('device info shows the error', (tester) async {
    await tester.pumpView<DeviceInfoCubit, DeviceInfoState>(
      const DeviceInfoView(),
      cubit: MockDeviceInfoCubit(),
      state: const DeviceInfoState(
        status: DeviceInfoStatus.error,
        error: 'native failed',
      ),
    );

    expect(find.byKey(const Key('device_info_error')), findsOneWidget);
    expect(find.text('native failed'), findsOneWidget);
  });

  group('phone sensor', () {
    late MockPhoneSensorCubit cubit;

    setUp(() => cubit = MockPhoneSensorCubit());

    Future<void> pump(WidgetTester tester, PhoneSensorState state) =>
        tester.pumpView<PhoneSensorCubit, PhoneSensorState>(
          const PhoneSensorView(),
          cubit: cubit,
          state: state,
        );

    testWidgets('shows waiting before the first reading', (tester) async {
      await pump(tester, const PhoneSensorState());

      expect(find.byKey(const Key('sensor_waiting')), findsOneWidget);
    });

    testWidgets('shows axis values and magnitude', (tester) async {
      await pump(
        tester,
        PhoneSensorState(
          status: PhoneSensorStatus.streaming,
          sample: AccelerometerSample(
            x: 1,
            y: 2,
            z: 2,
            timestamp: DateTime(2026),
          ),
        ),
      );

      expect(find.text('1.00 m/s²'), findsOneWidget);
      expect(find.text('3.00 m/s²'), findsOneWidget);
    });

    testWidgets('shows the error', (tester) async {
      await pump(
        tester,
        const PhoneSensorState(
          status: PhoneSensorStatus.error,
          error: 'no sensor',
        ),
      );

      expect(find.text('no sensor'), findsOneWidget);
    });

    testWidgets('publish switch is disabled while offline', (tester) async {
      await pump(tester, const PhoneSensorState());

      final tile = tester.widget<SwitchListTile>(
        find.byKey(const Key('sensor_publish_switch')),
      );
      expect(tile.onChanged, isNull);
    });

    testWidgets('publish switch toggles publishing when online', (
      tester,
    ) async {
      await pump(tester, const PhoneSensorState(connected: true));

      await tester.tap(find.byKey(const Key('sensor_publish_switch')));

      verify(() => cubit.setPublishing(true)).called(1);
    });
  });

  group('system events', () {
    late MockSystemEventsCubit cubit;

    setUp(() {
      cubit = MockSystemEventsCubit();
      when(() => cubit.pingCount).thenReturn(100);
      when(() => cubit.runPing()).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, SystemEventsState state) =>
        tester.pumpView<SystemEventsCubit, SystemEventsState>(
          const SystemEventsView(),
          cubit: cubit,
          state: state,
        );

    testWidgets('shows the empty state and starts a ping run', (tester) async {
      await pump(tester, const SystemEventsState());

      expect(find.byKey(const Key('events_empty')), findsOneWidget);
      await tester.tap(find.byKey(const Key('ping_run')));

      verify(() => cubit.runPing()).called(1);
    });

    testWidgets('disables the run button while running', (tester) async {
      await pump(
        tester,
        const SystemEventsState(pingStatus: PingStatus.running),
      );

      final button = tester.widget<FilledButton>(
        find.byKey(const Key('ping_run')),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows ping results and native events', (tester) async {
      await pump(
        tester,
        SystemEventsState(
          pingStatus: PingStatus.done,
          results: const [
            PingResult(
              codec: PingCodec.standard,
              payloadSize: 1000,
              stats: LatencyStats(
                count: 100,
                min: Duration(microseconds: 100),
                median: Duration(microseconds: 250),
                p95: Duration(microseconds: 1200),
                max: Duration(milliseconds: 3),
              ),
            ),
          ],
          events: [
            MemoryPressureEvent(
              level: MemoryPressure.critical,
              source: 'TRIM_MEMORY_RUNNING_LOW',
              timestamp: DateTime(2026, 10, 28, 9, 5, 7, 42),
            ),
            LifecycleEvent(
              foreground: false,
              timestamp: DateTime(2026, 10, 28, 9, 5),
            ),
          ],
        ),
      );

      expect(find.byKey(const Key('ping_standard_1000')), findsOneWidget);
      expect(find.text('0.25 / 1.20 ms'), findsOneWidget);
      expect(find.text('Memory pressure: critical'), findsOneWidget);
      expect(find.text('TRIM_MEMORY_RUNNING_LOW'), findsOneWidget);
      expect(find.text('09:05:07.042'), findsOneWidget);
      expect(find.text('App in background'), findsOneWidget);
    });

    testWidgets('shows the ping error', (tester) async {
      await pump(
        tester,
        const SystemEventsState(pingStatus: PingStatus.error, error: 'boom'),
      );

      expect(find.byKey(const Key('ping_error')), findsOneWidget);
      expect(find.text('boom'), findsOneWidget);
    });
  });
}
