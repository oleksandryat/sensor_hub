import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

class _FakeDeviceInfoApi implements DeviceInfoApi {
  PlatformException? failure;

  @override
  Future<DeviceInfoMessage> getDeviceInfo() async {
    if (failure != null) throw failure!;
    return DeviceInfoMessage(
      platform: 'Android',
      manufacturer: 'Google',
      model: 'Pixel',
      osVersion: 'Android 15 (API 35)',
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('getDeviceInfoTyped', () {
    test('maps the Pigeon message', () async {
      final native = SensorhubNative(deviceInfoApi: _FakeDeviceInfoApi());
      expect(
        await native.getDeviceInfoTyped(),
        const NativeDeviceInfo(
          platform: 'Android',
          manufacturer: 'Google',
          model: 'Pixel',
          osVersion: 'Android 15 (API 35)',
        ),
      );
    });

    test('maps PlatformException to NativeException', () async {
      final api = _FakeDeviceInfoApi()
        ..failure = PlatformException(code: 'unavailable');
      await expectLater(
        SensorhubNative(deviceInfoApi: api).getDeviceInfoTyped(),
        throwsA(isA<NativeException>()),
      );
    });
  });
}
