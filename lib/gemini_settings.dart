
import 'package:flutter/material.dart';
import 'api_key_storage.dart';

class GeminiSettings extends StatefulWidget {
  const GeminiSettings({super.key});

  @override
  State<GeminiSettings> createState() => _GeminiSettingsState();
}

class _GeminiSettingsState extends State<GeminiSettings> {
  final TextEditingController _controller =
      TextEditingController();

  final ApiKeyStorage _storage = ApiKeyStorage();

  bool _loading = true;
  bool _obscure = true;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    final key = await _storage.read();

    if (!mounted) return;

    setState(() {
      _controller.text = key ?? '';
      _loading = false;
    });
  }

  Future<void> _saveKey() async {
    final key = _controller.text.trim();

    if (key.isEmpty) {
      setState(() => _status = 'API anahtarı boş olamaz.');
      return;
    }

    try {
      await _storage.save(key);

      if (!mounted) return;

      setState(() => _status = 'API anahtarı kaydedildi.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Kaydetme hatası: $e');
    }
  }

  Future<void> _deleteKey() async {
    await _storage.delete();

    if (!mounted) return;

    setState(() {
      _controller.clear();
      _status = 'API anahtarı silindi.';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text('Gemini Ayarları'),
        backgroundColor: const Color(0xFF171717),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GEMINI API BAĞLANTISI',
                    style: TextStyle(
                      color: Color(0xFFFF3030),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    obscureText: _obscure,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Gemini API anahtarını gir',
                      hintStyle: const TextStyle(
                        color: Colors.white38,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF222222),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() => _obscure = !_obscure);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveKey,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text('API ANAHTARINI KAYDET'),
                    ),
                  ),
                  TextButton(
                    onPressed: _deleteKey,
                    child: const Text(
                      'Anahtarı sil',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _status,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
    );
  }
}
