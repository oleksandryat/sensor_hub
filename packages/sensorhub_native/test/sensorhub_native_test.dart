import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel(SensorhubNative.channelName);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late List<MethodCall> calls;

  void mockHandler(Future<Object?> Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(channel, (call) {
      calls.add(call);
      return handler(call);
    });
  }

  setUp(() => calls = []);
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('getDeviceInfo maps the native map', () async {
    mockHandler(
      (_) async => {
        'platform': 'Android',
        'manufacturer': 'Google',
        'model': 'Pixel',
        'osVersion': 'Android 15 (API 35)',
      },
    );

    final info = await SensorhubNative().getDeviceInfo();

    expect(calls.single.method, 'getDeviceInfo');
    expect(
      info,
      const NativeDeviceInfo(
        platform: 'Android',
        manufacturer: 'Google',
        model: 'Pixel',
        osVersion: 'Android 15 (API 35)',
      ),
    );
  });

  test('shareText sends arguments and parses the outcome', () async {
    mockHandler((_) async => 'completed');

    final outcome = await SensorhubNative().shareText('a,b', subject: 'Log');

    expect(outcome, ShareOutcome.completed);
    expect(calls.single.arguments, {'text': 'a,b', 'subject': 'Log'});
  });

  test('shareText surfaces PlatformException from native', () async {
    mockHandler((_) async => throw PlatformException(code: 'no_activity'));

    expect(
      SensorhubNative().shareText('x'),
      throwsA(
        isA<PlatformException>().having((e) => e.code, 'code', 'no_activity'),
      ),
    );
  });
}
