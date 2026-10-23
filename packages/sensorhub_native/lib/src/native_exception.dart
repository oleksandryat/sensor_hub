import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Error reported by native code, decoupled from [PlatformException].
///
/// Known codes: `no_activity`, `invalid_arguments`, `unavailable`,
/// `vault_corrupted`, `vault_failure`.
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

/// Runs [call], converting [PlatformException] into [NativeException].
Future<T> guardNative<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on PlatformException catch (e) {
    throw NativeException.fromPlatform(e);
  }
}
