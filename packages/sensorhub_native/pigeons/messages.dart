import 'package:pigeon/pigeon.dart';

// Regenerate: dart run pigeon --input pigeons/messages.dart
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    dartPackageName: 'sensorhub_native',
    kotlinOut:
        'android/src/main/kotlin/com/sensorhub/sensorhub_native/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.sensorhub.sensorhub_native'),
    swiftOut: 'ios/sensorhub_native/Sources/sensorhub_native/Messages.g.swift',
  ),
)
class DeviceInfoMessage {
  DeviceInfoMessage({
    required this.platform,
    required this.manufacturer,
    required this.model,
    required this.osVersion,
  });

  String platform;
  String manufacturer;
  String model;
  String osVersion;
}

class VaultCredentials {
  VaultCredentials({required this.username, required this.password});

  String username;
  String password;
}

/// Same data as the `getDeviceInfo` MethodChannel call, but typed.
@HostApi()
abstract class DeviceInfoApi {
  DeviceInfoMessage getDeviceInfo();
}

class WindowStatsMessage {
  WindowStatsMessage({
    required this.mean,
    required this.stdDev,
    required this.zScore,
  });

  double mean;
  double stdDev;
  double zScore;
}

/// Same computation as the `analyzeWindow` MethodChannel call, for the benchmark.
@HostApi()
abstract class WindowStatsApi {
  WindowStatsMessage analyzeWindow(List<double> window, double value);
}

/// Credentials kept in the Android Keystore / iOS Keychain.
///
/// Errors: `vault_corrupted` (entry cannot be decrypted and was wiped),
/// `vault_failure` (any other native failure).
@HostApi()
abstract class SecureVaultApi {
  @async
  void save(VaultCredentials credentials);

  @async
  VaultCredentials? load();

  @async
  void clear();
}
