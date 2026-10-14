import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/core/router/app_router.dart';
import 'package:sensor_hub/features/native_lab/device_info/cubit/device_info_cubit.dart';
import 'package:sensor_hub/features/native_lab/device_info/view/device_info_screen.dart';
import 'package:sensor_hub/features/native_lab/view/native_lab_screen.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../helpers/helpers.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakeRoute extends Fake implements PageRouteInfo {}

class MockDeviceInfoCubit extends MockCubit<DeviceInfoState>
    implements DeviceInfoCubit {}

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

    verify(() => router.push(const DeviceInfoRoute())).called(1);
    verify(() => router.push(const ExportRoute())).called(1);
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
}
