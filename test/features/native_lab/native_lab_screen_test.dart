import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/core/router/app_router.dart';
import 'package:sensor_hub/features/native_lab/device_info/cubit/device_info_cubit.dart';
import 'package:sensor_hub/features/native_lab/device_info/view/device_info_screen.dart';
import 'package:sensor_hub/features/native_lab/phone_sensor/cubit/phone_sensor_cubit.dart';
import 'package:sensor_hub/features/native_lab/phone_sensor/view/phone_sensor_screen.dart';
import 'package:sensor_hub/features/native_lab/view/native_lab_screen.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../helpers/helpers.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakeRoute extends Fake implements PageRouteInfo {}

class MockDeviceInfoCubit extends MockCubit<DeviceInfoState>
    implements DeviceInfoCubit {}

class MockPhoneSensorCubit extends MockCubit<PhoneSensorState>
    implements PhoneSensorCubit {}

void main() {
  setUpAll(() => registerFallbackValue(FakeRoute()));

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

    verify(() => router.push(const DeviceInfoRoute())).called(1);
    verify(() => router.push(const ExportRoute())).called(1);
    verify(() => router.push(const PhoneSensorRoute())).called(1);
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
}
