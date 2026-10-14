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

/// Thin Dart facade over the `sensorhub_native` platform channel.
class SensorhubNative {
  static const channelName = 'sensorhub_native';

  final MethodChannel _channel;

  SensorhubNative({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(channelName);

  Future<NativeDeviceInfo> getDeviceInfo() async {
    final map = await _channel.invokeMapMethod<Object?, Object?>(
      'getDeviceInfo',
    );
    return NativeDeviceInfo.fromMap(map!);
  }

  /// Opens the native share sheet with [text].
  ///
  /// Throws [PlatformException] with code `no_activity` when there is no UI
  /// to present from, or `invalid_arguments` for an empty [text].
  Future<ShareOutcome> shareText(String text, {String? subject}) async {
    final outcome = await _channel.invokeMethod<String>('shareText', {
      'text': text,
      'subject': subject,
    });
    return ShareOutcome.values.byName(outcome!);
  }
}
