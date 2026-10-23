import 'package:sensor_hub/domain/credentials_vault.dart';
import 'package:sensor_hub/domain/stored_credentials.dart';

class FakeCredentialsVault implements CredentialsVault {
  StoredCredentials? stored;
  VaultException? failure;

  FakeCredentialsVault({this.stored});

  @override
  Future<StoredCredentials?> load() async {
    if (failure != null) throw failure!;
    return stored;
  }

  @override
  Future<void> save(StoredCredentials credentials) async {
    if (failure != null) throw failure!;
    stored = credentials;
  }

  @override
  Future<void> clear() async {
    if (failure != null) throw failure!;
    stored = null;
  }
}
