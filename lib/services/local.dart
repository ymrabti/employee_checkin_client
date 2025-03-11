import "dart:async";
import "dart:convert";
import "dart:typed_data";
import "package:crypto/crypto.dart";
import "package:encrypt/encrypt.dart";
import "package:shared_preferences/shared_preferences.dart";

abstract class EmployeeChecksLocalServices {
  static String _encryptValues(String encryptionKey, String value) {
    Key keyEcry = Key.fromUtf8(encryptionKey);
    IV iv = IV.fromLength(16);
    Encrypter encrypter = Encrypter(AES(keyEcry));
    String encrypted = encrypter.encrypt(value, iv: iv).base16;
    String ivString = iv.base16;
    String encryptedString = "$encrypted:$ivString";
    return encryptedString;
  }

  static String? _decryptValue(String encryptionKey, String string) {
    Key keyEcry = Key.fromUtf8(encryptionKey);
    Encrypter encrypter = Encrypter(AES(keyEcry));
    List<String> parts = string.split(':');
    if (parts.length != 2) return null;
    String decrypted = encrypter.decrypt(Encrypted.fromBase16(parts[0]), iv: IV.fromBase16(parts[1]));
    return decrypted;
  }

  static Future<void> saveEncrypted({
    required String key,
    required String value,
    required String encryptionKey,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encryptedValue = _encryptValues(encryptionKey, value);
    await prefs.setString(_encryptKey(key), encryptedValue);
  }

  static Future<String?> loadEncrypted({
    required String key,
    required String encryptionKey,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString(_encryptKey(key));
    if (string == null) return null;
    String? decrypted = _decryptValue(encryptionKey, string);
    return decrypted;
  }

  static String _encryptKey(String key) {
    Uint8List bytes = utf8.encode(key);
    Digest digest = md5.convert(bytes);
    return digest.toString();
  }

  static Future<void> remove({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_encryptKey(key));
  }

  /* static Future<T?> loadObject<T>({
    required String key,
    required String encryptionKey,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString(_encryptKey(key));
    if (string == null) return null;
    String? decrypted = _decryptValue(encryptionKey, string);
    if (decrypted == null) return null;
    if (T == num) return num.tryParse(decrypted) as T?;
    if (T == bool) return bool.tryParse(decrypted) as T?;
    if (T == int) return int.tryParse(decrypted) as T?;
    if (T == double) return double.tryParse(decrypted) as T?;
    return null;
  } */

  static Future<Set<String>> keys() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  static Future<void> clearAll() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
