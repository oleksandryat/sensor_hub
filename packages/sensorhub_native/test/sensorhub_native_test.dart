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

  test('shareText maps PlatformException to NativeException', () async {
    mockHandler(
      (_) async => throw PlatformException(code: 'no_activity', message: 'm'),
    );

    expect(
      SensorhubNative().shareText('x'),
      throwsA(
        isA<NativeException>()
            .having((e) => e.code, 'code', 'no_activity')
            .having((e) => e.message, 'message', 'm'),
      ),
    );
  });

  group('accelerometerStream', () {
    const eventChannel = EventChannel(SensorhubNative.accelerometerChannelName);
    late Object? listenArgs;
    var cancelled = false;

    void mockStream(void Function(MockStreamHandlerEventSink sink) onListen) {
      messenger.setMockStreamHandler(
        eventChannel,
        MockStreamHandler.inline(
          onListen: (args, sink) {
            listenArgs = args;
            onListen(sink);
          },
          onCancel: (_) => cancelled = true,
        ),
      );
    }

    setUp(() => cancelled = false);
    tearDown(() => messenger.setMockStreamHandler(eventChannel, null));

    test('maps events, passes the rate and cancels natively', () async {
      mockStream((sink) {
        sink.success({'x': 1, 'y': 2.0, 'z': 2.0, 'timestamp': 1000});
      });

      final sub = SensorhubNative()
          .accelerometerStream(samplingHz: 20)
          .listen(
            expectAsync1((sample) {
              expect(sample.x, 1.0);
              expect(sample.magnitude, 3.0);
              expect(sample.timestamp.millisecondsSinceEpoch, 1000);
            }),
          );
      await pumpEventQueue();
      await sub.cancel();
      await pumpEventQueue();

      expect(listenArgs, {'samplingHz': 20});
      expect(cancelled, isTrue);
    });

    test('maps stream errors to NativeException', () async {
      mockStream((sink) => sink.error(code: 'unavailable', message: 'none'));

      expect(
        SensorhubNative().accelerometerStream(),
        emitsError(
          isA<NativeException>().having((e) => e.code, 'code', 'unavailable'),
        ),
      );
    });
  });
}
