import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/data/native_credentials_vault.dart';
import 'package:sensor_hub/domain/credentials_vault.dart';
import 'package:sensor_hub/domain/stored_credentials.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

class _FakeVaultApi implements SecureVaultApi {
  VaultCredentials? stored;
  PlatformException? failure;

  @override
  Future<void> save(VaultCredentials credentials) async {
    if (failure != null) throw failure!;
    stored = credentials;
  }

  @override
  Future<VaultCredentials?> load() async {
    if (failure != null) throw failure!;
    return stored;
  }

  @override
  Future<void> clear() async {
    if (failure != null) throw failure!;
    stored = null;
  }

  // Generated base members (messenger, suffix) are irrelevant to the fake.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeVaultApi api;
  late NativeCredentialsVault vault;
  const credentials = StoredCredentials(username: 'u', password: 'p');

  setUp(() {
    api = _FakeVaultApi();
    vault = NativeCredentialsVault(SecureVault(api: api));
  });

  test('load returns null when nothing is stored', () async {
    expect(await vault.load(), isNull);
  });

  test('save then load round-trips through the native types', () async {
    await vault.save(credentials);

    expect(api.stored, VaultCredentials(username: 'u', password: 'p'));
    expect(await vault.load(), credentials);
  });

  test('clear removes the entry', () async {
    await vault.save(credentials);
    await vault.clear();

    expect(await vault.load(), isNull);
  });

  test('native failures become VaultException', () async {
    api.failure = PlatformException(code: 'vault_failure', message: 'boom');

    await expectLater(
      vault.load(),
      throwsA(
        isA<VaultException>().having((e) => e.message, 'message', 'boom'),
      ),
    );
  });
}
