
import 'package:flutter/material.dart';
import 'api_key_storage.dart';

class GeminiSettings extends StatefulWidget {
  const GeminiSettings({super.key});

  @override
  State<GeminiSettings> createState() => _GeminiSettingsState();
}

class _GeminiSettingsState extends State<GeminiSettings> {
  final ApiKeyStorage storage = ApiKeyStorage();

  final TextEditingController geminiController =
      TextEditingController();

  final TextEditingController claudeController =
      TextEditingController();

  String selectedProvider = 'gemini';
  bool isLoading = true;
  bool hideGeminiKey = true;
  bool hideClaudeKey = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final gemini = await storage.readGemini();
    final claude = await storage.readClaude();
    final provider = await storage.readProvider();

    if (!mounted) return;

    setState(() {
      geminiController.text = gemini ?? '';
      claudeController.text = claude ?? '';
      selectedProvider = provider;
      isLoading = false;
    });
  }

  Future<void> saveSettings() async {
    await storage.saveGemini(geminiController.text);
    await storage.saveClaude(claudeController.text);
    await storage.saveProvider(selectedProvider);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ayarlar kaydedildi.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    geminiController.dispose();
    claudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE50914);
    const background = Color(0xFF101010);

    if (isLoading) {
      return const Scaffold(
        backgroundColor: background,
        body: Center(
          child: CircularProgressIndicator(color: red),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Yapay Zekâ Ayarları'),
        backgroundColor: background,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'AKTİF YAPAY ZEKÂ',
            style: TextStyle(
              color: red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: selectedProvider,
            dropdownColor: const Color(0xFF222222),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF222222),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'gemini',
                child: Text('Google Gemini'),
              ),
              DropdownMenuItem(
                value: 'claude',
                child: Text('Anthropic Claude'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                selectedProvider = value;
              });
            },
          ),

          const SizedBox(height: 30),

          const Text(
            'GEMINI API KEY',
            style: TextStyle(
              color: red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: geminiController,
            obscureText: hideGeminiKey,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Gemini API anahtarını gir',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF222222),
              suffixIcon: IconButton(
                icon: Icon(
                  hideGeminiKey
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    hideGeminiKey = !hideGeminiKey;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'CLAUDE API KEY',
            style: TextStyle(
              color: red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: claudeController,
            obscureText: hideClaudeKey,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Claude API anahtarını gir',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF222222),
              suffixIcon: IconButton(
                icon: Icon(
                  hideClaudeKey
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    hideClaudeKey = !hideClaudeKey;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 35),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'AYARLARI KAYDET',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
