import 'package:sensorhub_native/sensorhub_native.dart';

import '../domain/credentials_vault.dart';
import '../domain/stored_credentials.dart';

/// [CredentialsVault] backed by the native Pigeon vault.
class NativeCredentialsVault implements CredentialsVault {
  final SecureVault _vault;

  NativeCredentialsVault(this._vault);

  @override
  Future<StoredCredentials?> load() => _guard(() async {
    final credentials = await _vault.load();
    return credentials == null
        ? null
        : StoredCredentials(
            username: credentials.username,
            password: credentials.password,
          );
  });

  @override
  Future<void> save(StoredCredentials credentials) => _guard(
    () => _vault.save(
      VaultCredentials(
        username: credentials.username,
        password: credentials.password,
      ),
    ),
  );

  @override
  Future<void> clear() => _guard(_vault.clear);

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on NativeException catch (e) {
      throw VaultException(e.message ?? e.code);
    }
  }
}
