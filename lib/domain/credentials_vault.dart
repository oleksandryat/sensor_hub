import 'stored_credentials.dart';

/// Thrown when the secure storage fails or its entry is unreadable.
class VaultException implements Exception {
  final String message;

  const VaultException(this.message);

  @override
  String toString() => 'VaultException($message)';
}

/// Secure storage for broker credentials.
abstract interface class CredentialsVault {
  Future<StoredCredentials?> load();

  Future<void> save(StoredCredentials credentials);

  Future<void> clear();
}
