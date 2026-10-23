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

  blocTest<DeviceInfoCubit, DeviceInfoState>(
    'load with the pigeon source uses the typed API',
    setUp: () =>
        when(() => native.getDeviceInfoTyped()).thenAnswer((_) async => info),
    build: () => DeviceInfoCubit(native),
    act: (c) => c.load(DeviceInfoSource.pigeon),
    expect: () => [
      const DeviceInfoState(source: DeviceInfoSource.pigeon),
      const DeviceInfoState(
        status: DeviceInfoStatus.loaded,
        source: DeviceInfoSource.pigeon,
        info: info,
      ),
    ],
    verify: (_) => verifyNever(() => native.getDeviceInfo()),
  );

  blocTest<DeviceInfoCubit, DeviceInfoState>(
    'pigeon errors keep the selected source',
    setUp: () =>
        when(() => native.getDeviceInfoTyped())
            .thenThrow(NativeException('boom')),
    build: () => DeviceInfoCubit(native),
    act: (c) => c.load(DeviceInfoSource.pigeon),
    expect: () => [
      const DeviceInfoState(source: DeviceInfoSource.pigeon),
      const DeviceInfoState(
        status: DeviceInfoStatus.error,
        source: DeviceInfoSource.pigeon,
        error: 'boom',
      ),
    ],
  );
}
