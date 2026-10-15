import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/features/native_lab/device_info/cubit/device_info_cubit.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

class MockNative extends Mock implements SensorhubNative {}

void main() {
  late MockNative native;
  const info = NativeDeviceInfo(
    platform: 'iOS',
    manufacturer: 'Apple',
    model: 'iPhone',
    osVersion: 'iOS 19',
  );

  setUp(() => native = MockNative());

  blocTest<DeviceInfoCubit, DeviceInfoState>(
    'load emits loaded with info',
    setUp: () =>
        when(() => native.getDeviceInfo()).thenAnswer((_) async => info),
    build: () => DeviceInfoCubit(native),
    act: (c) => c.load(),
    expect: () => [
      const DeviceInfoState(),
      const DeviceInfoState(status: DeviceInfoStatus.loaded, info: info),
    ],
  );

  blocTest<DeviceInfoCubit, DeviceInfoState>(
    'load maps NativeException to error',
    setUp: () =>
        when(() => native.getDeviceInfo())
            .thenThrow(NativeException('boom', 'native failed')),
    build: () => DeviceInfoCubit(native),
    act: (c) => c.load(),
    expect: () => [
      const DeviceInfoState(),
      const DeviceInfoState(
        status: DeviceInfoStatus.error,
        error: 'native failed',
      ),
    ],
  );
}
