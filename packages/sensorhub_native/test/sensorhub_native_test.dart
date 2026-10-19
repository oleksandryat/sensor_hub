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

  group('systemEvents', () {
    const codec = JSONMessageCodec();

    Future<void> nativeSends(Object message) => messenger.handlePlatformMessage(
      SensorhubNative.systemEventsChannelName,
      codec.encodeMessage(message),
      (_) {},
    );

    test('maps native-initiated memory and lifecycle messages', () async {
      final native = SensorhubNative();
      final events = <SystemEvent>[];
      final sub = native.systemEvents.listen(events.add);

      await nativeSends({
        'type': 'memory',
        'level': 'critical',
        'source': 'TRIM_MEMORY_RUNNING_LOW',
        'timestamp': 1000,
      });
      await nativeSends({
        'type': 'lifecycle',
        'state': 'background',
        'timestamp': 2000,
      });
      await nativeSends({'type': 'future_event', 'timestamp': 3000});
      await sub.cancel();

      expect(events, [
        MemoryPressureEvent(
          level: MemoryPressure.critical,
          source: 'TRIM_MEMORY_RUNNING_LOW',
          timestamp: DateTime.fromMillisecondsSinceEpoch(1000),
        ),
        LifecycleEvent(
          foreground: false,
          timestamp: DateTime.fromMillisecondsSinceEpoch(2000),
        ),
      ]);
    });

    test('drops messages after the last listener cancels', () async {
      final native = SensorhubNative();
      final events = <SystemEvent>[];
      await native.systemEvents.listen(events.add).cancel();

      await nativeSends({
        'type': 'lifecycle',
        'state': 'foreground',
        'timestamp': 0,
      });

      expect(events, isEmpty);
    });
  });

  group('ping', () {
    const channels = {
      PingCodec.json: BasicMessageChannel<Object?>(
        SensorhubNative.pingJsonChannelName,
        JSONMessageCodec(),
      ),
      PingCodec.standard: BasicMessageChannel<Object?>(
        SensorhubNative.pingStandardChannelName,
        StandardMessageCodec(),
      ),
    };

    tearDown(() {
      for (final channel in channels.values) {
        messenger.setMockDecodedMessageHandler(channel, null);
      }
    });

    for (final codec in PingCodec.values) {
      test('${codec.name} returns the round trip of an echo', () async {
        final received = <Object?>[];
        messenger.setMockDecodedMessageHandler(channels[codec]!, (message) {
          received.add(message);
          return Future.value(message);
        });

        final latency = await SensorhubNative().ping(codec, payload: [1.5]);

        expect(latency, isA<Duration>());
        expect(received.single, {
          'seq': 0,
          'payload': [1.5],
        });
      });
    }

    test('throws unavailable without a native handler', () {
      expect(
        SensorhubNative().ping(PingCodec.json),
        throwsA(
          isA<NativeException>().having((e) => e.code, 'code', 'unavailable'),
        ),
      );
    });

    test('throws bad_reply when the echo does not match', () {
      messenger.setMockDecodedMessageHandler(
        channels[PingCodec.standard]!,
        (_) => Future.value({'seq': 99}),
      );

      expect(
        SensorhubNative().ping(PingCodec.standard),
        throwsA(
          isA<NativeException>().having((e) => e.code, 'code', 'bad_reply'),
        ),
      );
    });
  });
}
