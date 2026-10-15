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

/// Thin Dart facade over the `sensorhub_native` platform channels.
class SensorhubNative {
  static const channelName = 'sensorhub_native';
  static const accelerometerChannelName = 'sensorhub_native/accelerometer';

  final MethodChannel _channel;
  final EventChannel _accelerometer;

  SensorhubNative({MethodChannel? channel, EventChannel? accelerometerChannel})
    : _channel = channel ?? const MethodChannel(channelName),
      _accelerometer =
          accelerometerChannel ?? const EventChannel(accelerometerChannelName);

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
