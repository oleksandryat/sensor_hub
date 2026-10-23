import Foundation
import Security

/// Credentials stored as one generic-password Keychain item (JSON payload).
final class SecureVaultHandler: SecureVaultApi {
  private let service = "sensorhub_vault"
  private let account = "credentials"

  private var baseQuery: [CFString: Any] {
    [kSecClass: kSecClassGenericPassword, kSecAttrService: service, kSecAttrAccount: account]
  }

  // Keychain calls are synchronous IPC, so they run off the main actor.
  func save(credentials: VaultCredentials) async throws {
    try await Task.detached { [self] in
      let payload = try JSONEncoder().encode(["username": credentials.username, "password": credentials.password])
      // Replace instead of update: an upsert needs two code paths for the same result.
      SecItemDelete(baseQuery as CFDictionary)
      var item = baseQuery
      item[kSecValueData] = payload
      // Readable after the first unlock (background work) but never migrated to another device.
      item[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
      let status = SecItemAdd(item as CFDictionary, nil)
      guard status == errSecSuccess else { throw Self.failure(status) }
    }.value
  }

  func load() async throws -> VaultCredentials? {
    try await Task.detached { [self] in
      var query = baseQuery
      query[kSecReturnData] = true
      query[kSecMatchLimit] = kSecMatchLimitOne
      var result: CFTypeRef?
      let status = SecItemCopyMatching(query as CFDictionary, &result)
      if status == errSecItemNotFound { return nil }
      guard status == errSecSuccess, let data = result as? Data else { throw Self.failure(status) }
      guard let fields = try? JSONDecoder().decode([String: String].self, from: data),
        let username = fields["username"], let password = fields["password"]
      else {
        SecItemDelete(baseQuery as CFDictionary)
        throw PigeonError(code: "vault_corrupted", message: "Stored credentials cannot be decoded", details: nil)
      }
      return VaultCredentials(username: username, password: password)
    }.value
  }

  func clear() async throws {
    try await Task.detached { [self] in
      let status = SecItemDelete(baseQuery as CFDictionary)
      guard status == errSecSuccess || status == errSecItemNotFound else { throw Self.failure(status) }
    }.value
  }

  private static func failure(_ status: OSStatus) -> PigeonError {
    let text = SecCopyErrorMessageString(status, nil) as String? ?? "OSStatus \(status)"
    return PigeonError(code: "vault_failure", message: text, details: nil)
  }
}
