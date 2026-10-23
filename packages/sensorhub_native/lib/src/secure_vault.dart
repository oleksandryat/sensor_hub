import 'messages.g.dart';
import 'native_exception.dart';

/// Credentials in the Android Keystore / iOS Keychain through Pigeon.
///
/// Native failures arrive as [NativeException]: `vault_corrupted` (the entry
/// could not be decrypted and was wiped) or `vault_failure`.
class SecureVault {
  final SecureVaultApi _api;

  SecureVault({SecureVaultApi? api}) : _api = api ?? SecureVaultApi();

  Future<void> save(VaultCredentials credentials) =>
      guardNative(() => _api.save(credentials));

  Future<VaultCredentials?> load() => guardNative(_api.load);

  Future<void> clear() => guardNative(_api.clear);
}
