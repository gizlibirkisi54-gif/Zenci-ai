
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

  bool loading = true;
  bool hideGemini = true;
  bool hideClaude = true;

  String status = '';

  @override
  void initState() {
    super.initState();
    loadKeys();
  }

  Future<void> loadKeys() async {
    final gemini = await storage.readGemini();
    final claude = await storage.readClaude();

    if (!mounted) return;

    setState(() {
      geminiController.text = gemini ?? '';
      claudeController.text = claude ?? '';
      loading = false;
    });
  }

  Future<void> saveKeys() async {
    try {
      await storage.saveGemini(geminiController.text);
      await storage.saveClaude(claudeController.text);

      if (!mounted) return;

      setState(() {
        status = 'API anahtarları kaydedildi.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = 'Kaydetme hatası: $e';
      });
    }
  }

  Widget apiField({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required bool hidden,
    required VoidCallback toggle,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xffed1c35)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          obscureText: hidden,
          decoration: InputDecoration(
            hintText: 'API anahtarını gir...',
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              onPressed: toggle,
              icon: Icon(
                hidden ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
        ),
      ],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapay Zekâ Bağlantıları'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'ZENCİ AI MOTORLARI',
                  style: TextStyle(
                    color: Color(0xffed1c35),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 25),

                apiField(
                  title: 'Google Gemini',
                  subtitle: 'Gemini API bağlantı anahtarı',
                  controller: geminiController,
                  hidden: hideGemini,
                  toggle: () {
                    setState(() => hideGemini = !hideGemini);
                  },
                  icon: Icons.auto_awesome,
                ),

                const SizedBox(height: 30),

                apiField(
                  title: 'Anthropic Claude',
                  subtitle: 'Claude API bağlantı anahtarı',
                  controller: claudeController,
                  hidden: hideClaude,
                  toggle: () {
                    setState(() => hideClaude = !hideClaude);
                  },
                  icon: Icons.psychology,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: saveKeys,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffed1c35),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'BAĞLANTILARI KAYDET',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Center(
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
    );
  }
}
