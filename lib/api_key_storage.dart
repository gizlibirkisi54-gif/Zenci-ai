
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyStorage {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _keyName = 'gemini_api_key';

  Future<void> save(String apiKey) async {
    await _storage.write(
      key: _keyName,
      value: apiKey.trim(),
    );
  }

  Future<String?> read() async {
    return await _storage.read(key: _keyName);
  }

  Future<void> delete() async {
    await _storage.delete(key: _keyName);
  }

  Future<bool> hasKey() async {
    final key = await read();
    return key != null && key.isNotEmpty;
  }
}
