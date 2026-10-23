package com.sensorhub.sensorhub_native

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONException
import org.json.JSONObject
import java.security.GeneralSecurityException
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Credentials encrypted with an AES-GCM key that never leaves the Android Keystore.
 * The ciphertext (IV + data) lives in private SharedPreferences.
 */
class SecureVaultHandler(context: Context) : SecureVaultApi {
  private val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

  // Keystore calls can block on hardware, so they stay off the main thread.
  override suspend fun save(credentials: VaultCredentials) = io {
    val json = JSONObject()
      .put("username", credentials.username)
      .put("password", credentials.password)
      .toString()
    val cipher = Cipher.getInstance(TRANSFORMATION).apply { init(Cipher.ENCRYPT_MODE, secretKey()) }
    // GCM generates a fresh IV per encryption; it is stored next to the data.
    val blob = cipher.iv + cipher.doFinal(json.toByteArray())
    prefs.edit().putString(ENTRY, Base64.encodeToString(blob, Base64.NO_WRAP)).apply()
  }

  override suspend fun load(): VaultCredentials? = io {
    val stored = prefs.getString(ENTRY, null) ?: return@io null
    try {
      val blob = Base64.decode(stored, Base64.NO_WRAP)
      val cipher = Cipher.getInstance(TRANSFORMATION).apply {
        init(
          Cipher.DECRYPT_MODE,
          secretKey(),
          GCMParameterSpec(TAG_BITS, blob, 0, IV_BYTES),
        )
      }
      val json = JSONObject(String(cipher.doFinal(blob, IV_BYTES, blob.size - IV_BYTES)))
      VaultCredentials(json.getString("username"), json.getString("password"))
    } catch (e: Exception) {
      when (e) {
        // A reinstall or lock-screen change can invalidate the key: wipe and report.
        is GeneralSecurityException, is JSONException, is IllegalArgumentException -> {
          prefs.edit().remove(ENTRY).apply()
          throw FlutterError("vault_corrupted", "Stored credentials cannot be decrypted", null)
        }
        else -> throw e
      }
    }
  }

  override suspend fun clear() = io {
    prefs.edit().remove(ENTRY).apply()
  }

  // Maps any unexpected native failure to a typed error for Dart.
  private suspend fun <T> io(block: () -> T): T = withContext(Dispatchers.IO) {
    try {
      block()
    } catch (e: FlutterError) {
      throw e
    } catch (e: Exception) {
      throw FlutterError("vault_failure", e.message, null)
    }
  }

  private fun secretKey(): SecretKey {
    val store = KeyStore.getInstance(KEYSTORE).apply { load(null) }
    (store.getKey(KEY_ALIAS, null) as? SecretKey)?.let { return it }
    val spec = KeyGenParameterSpec.Builder(
      KEY_ALIAS,
      KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
    )
      .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
      .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
      .setKeySize(256)
      .build()
    return KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, KEYSTORE)
      .apply { init(spec) }
      .generateKey()
  }

  private companion object {
    const val KEYSTORE = "AndroidKeyStore"
    const val KEY_ALIAS = "sensorhub_vault_key"
    const val PREFS_NAME = "sensorhub_vault"
    const val ENTRY = "credentials"
    const val TRANSFORMATION = "AES/GCM/NoPadding"
    const val IV_BYTES = 12
    const val TAG_BITS = 128
  }
}
