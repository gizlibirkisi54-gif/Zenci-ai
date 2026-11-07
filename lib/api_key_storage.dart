
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyStorage {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  Future<void> save(String apiKey) async {
    await saveGemini(apiKey);
  }

  Future<String?> read() async {
    return readGemini();
  }

  Future<void> delete() async {
    await deleteGemini();
  }

  Future<void> saveGemini(String key) async {
    await _storage.write(
      key: 'gemini_api_key',
      value: key.trim(),
    );
  }

  Future<String?> readGemini() async {
    return _storage.read(key: 'gemini_api_key');
  }

  Future<void> deleteGemini() async {
    await _storage.delete(key: 'gemini_api_key');
  }

  Future<void> saveClaude(String key) async {
    await _storage.write(
      key: 'claude_api_key',
      value: key.trim(),
    );
  }

  Future<String?> readClaude() async {
    return _storage.read(key: 'claude_api_key');
  }

  Future<void> deleteClaude() async {
    await _storage.delete(key: 'claude_api_key');
  }
}
  Future<void> saveProvider(String provider) async {
    await _storage.write(
      key: 'active_ai_provider',
      value: provider,
    );
  }

  Future<String> readProvider() async {
    return await _storage.read(
          key: 'active_ai_provider',
        ) ??
        'gemini';
  }
  
