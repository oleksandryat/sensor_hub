import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Static description of the device the app runs on.
@immutable
class NativeDeviceInfo {
  final String platform;
  final String manufacturer;
  final String model;
  final String osVersion;

  const NativeDeviceInfo({
    required this.platform,
    required this.manufacturer,
    required this.model,
    required this.osVersion,
  });

  factory NativeDeviceInfo.fromMap(Map<Object?, Object?> map) {
    return NativeDeviceInfo(
      platform: map['platform']! as String,
      manufacturer: map['manufacturer']! as String,
      model: map['model']! as String,
      osVersion: map['osVersion']! as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is NativeDeviceInfo &&
      other.platform == platform &&
      other.manufacturer == manufacturer &&
      other.model == model &&
      other.osVersion == osVersion;

  @override
  int get hashCode => Object.hash(platform, manufacturer, model, osVersion);
}

/// What is known about the share sheet once the native call returns.
///
/// iOS reports the real outcome after the user interacts with the sheet;
/// Android only knows that the chooser was launched.
enum ShareOutcome { completed, dismissed, launched }

/// Error reported by native code, decoupled from [PlatformException].
///
/// Known codes: `no_activity`, `invalid_arguments`, `unavailable`.
@immutable
class NativeException implements Exception {
  final String code;
  final String? message;

  const NativeException(this.code, [this.message]);

  factory NativeException.fromPlatform(PlatformException e) =>
      NativeException(e.code, e.message);

  @override
  String toString() => 'NativeException($code, $message)';
}

/// One accelerometer reading in m/s², Android axis convention.
@immutable
class AccelerometerSample {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  const AccelerometerSample({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  factory AccelerometerSample.fromMap(Map<Object?, Object?> map) {
    return AccelerometerSample(
      x: (map['x']! as num).toDouble(),
      y: (map['y']! as num).toDouble(),
      z: (map['z']! as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']! as int),
    );
  }

  /// Length of the acceleration vector; about 9.81 at rest.
  double get magnitude => sqrt(x * x + y * y + z * z);

  @override
  bool operator ==(Object other) =>
      other is AccelerometerSample &&
      other.x == x &&
      other.y == y &&
      other.z == z &&
      other.timestamp == timestamp;

  @override
  int get hashCode => Object.hash(x, y, z, timestamp);
}

/// Codec used by a ping channel; both echo the same payload.
enum PingCodec { json, standard }

enum MemoryPressure { moderate, critical }

/// Event pushed by native code over the system events channel.
sealed class SystemEvent {
  final DateTime timestamp;

  const SystemEvent(this.timestamp);

  /// Returns null for unknown event types, so newer native code stays compatible.
  static SystemEvent? fromMap(Map<Object?, Object?> map) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      map['timestamp']! as int,
    );
    return switch (map['type']) {
      'memory' => MemoryPressureEvent(
        level: MemoryPressure.values.byName(map['level']! as String),
        source: map['source']! as String,
        timestamp: timestamp,
      ),
      'lifecycle' => LifecycleEvent(
        foreground: map['state'] == 'foreground',
        timestamp: timestamp,
      ),
      _ => null,
    };
  }
}

/// Android `onTrimMemory`/`onLowMemory` or iOS memory warning.
final class MemoryPressureEvent extends SystemEvent {
  final MemoryPressure level;

  /// Native name of the signal, e.g. `TRIM_MEMORY_BACKGROUND`.
  final String source;

  const MemoryPressureEvent({
    required this.level,
    required this.source,
    required DateTime timestamp,
  }) : super(timestamp);

  @override
  bool operator ==(Object other) =>
      other is MemoryPressureEvent &&
      other.level == level &&
      other.source == source &&
      other.timestamp == timestamp;

  @override
  int get hashCode => Object.hash(level, source, timestamp);
}

/// The app moved to the foreground or background, as seen by native code.
final class LifecycleEvent extends SystemEvent {
  final bool foreground;

  const LifecycleEvent({required this.foreground, required DateTime timestamp})
    : super(timestamp);

  @override
  bool operator ==(Object other) =>
      other is LifecycleEvent &&
      other.foreground == foreground &&
      other.timestamp == timestamp;

  @override
  int get hashCode => Object.hash(foreground, timestamp);
}

/// Thin Dart facade over the `sensorhub_native` platform channels.
class SensorhubNative {
  static const channelName = 'sensorhub_native';
  static const accelerometerChannelName = 'sensorhub_native/accelerometer';
  static const systemEventsChannelName = 'sensorhub_native/system_events';
  static const pingJsonChannelName = 'sensorhub_native/ping/json';
  static const pingStandardChannelName = 'sensorhub_native/ping/standard';

  final MethodChannel _channel;
  final EventChannel _accelerometer;
  final _systemEvents = const BasicMessageChannel<Object?>(
    systemEventsChannelName,
    JSONMessageCodec(),
  );
  final _pings = const {
    PingCodec.json: BasicMessageChannel<Object?>(
      pingJsonChannelName,
      JSONMessageCodec(),
    ),
    PingCodec.standard: BasicMessageChannel<Object?>(
      pingStandardChannelName,
      StandardMessageCodec(),
    ),
  };
  var _pingSeq = 0;

  // A channel has a single message handler, so all listeners share one.
  late final StreamController<SystemEvent> _systemEventsController =
      StreamController.broadcast(
        onListen: () => _systemEvents.setMessageHandler((message) async {
          final event = SystemEvent.fromMap(message! as Map);
          if (event != null) _systemEventsController.add(event);
          return null;
        }),
        onCancel: () => _systemEvents.setMessageHandler(null),
      );

  SensorhubNative({MethodChannel? channel, EventChannel? accelerometerChannel})
    : _channel = channel ?? const MethodChannel(channelName),
      _accelerometer =
          accelerometerChannel ?? const EventChannel(accelerometerChannelName);

  /// Memory pressure and lifecycle events initiated by native code.
  ///
  /// Events sent while nobody listens are dropped by the engine.
  Stream<SystemEvent> get systemEvents => _systemEventsController.stream;

  /// Sends [payload] to native and measures the round trip until its echo.
  ///
  /// Throws [NativeException] `unavailable` without a native handler and
  /// `bad_reply` when the echo does not match.
  Future<Duration> ping(PingCodec codec, {Object? payload}) async {
    final seq = _pingSeq++;
    final watch = Stopwatch()..start();
    final reply = await _pings[codec]!.send({'seq': seq, 'payload': payload});
    watch.stop();
    if (reply == null) {
      throw const NativeException('unavailable', 'No native ping handler');
    }
    if (reply is! Map || reply['seq'] != seq) {
      throw NativeException('bad_reply', 'Unexpected echo: $reply');
    }
    return watch.elapsed;
  }

  Future<NativeDeviceInfo> getDeviceInfo() => _guard(() async {
    final map = await _channel.invokeMapMethod<Object?, Object?>(
      'getDeviceInfo',
    );
    return NativeDeviceInfo.fromMap(map!);
  });

  /// Live accelerometer readings; the sensor runs only while listened to.
  ///
  /// Errors arrive as [NativeException] (`unavailable` without a sensor).
  Stream<AccelerometerSample> accelerometerStream({int samplingHz = 50}) {
    return _accelerometer
        .receiveBroadcastStream({'samplingHz': samplingHz})
        .map((event) => AccelerometerSample.fromMap(event as Map))
        .transform(
          StreamTransformer.fromHandlers(
            handleError: (error, stack, sink) => sink.addError(
              error is PlatformException
                  ? NativeException.fromPlatform(error)
                  : error,
              stack,
            ),
          ),
        );
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on PlatformException catch (e) {
      throw NativeException.fromPlatform(e);
    }
  }

  /// Opens the native share sheet with [text].
  ///
  /// Throws [NativeException] with code `no_activity` when there is no UI
  /// to present from, or `invalid_arguments` for an empty [text].
  Future<ShareOutcome> shareText(String text, {String? subject}) =>
      _guard(() async {
        final outcome = await _channel.invokeMethod<String>('shareText', {
          'text': text,
          'subject': subject,
        });
        return ShareOutcome.values.byName(outcome!);
      });
}
