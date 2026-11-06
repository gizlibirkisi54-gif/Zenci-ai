
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String model = 'gemini-3.8-flash';

  Future<String> sendMessage({
    required String apiKey,
    required String message,
    List<Map<String, String>> history = const [],
  }) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('Gemini API anahtarı girilmemiş.');
    }

    final conversation = history.map((item) {
      final role = item['role'] == 'assistant'
          ? 'Zenci AI'
          : 'Kullanıcı';

      return '$role: ${item['text'] ?? ''}';
    }).join('\n\n');

    final prompt = '''
$conversation

Kullanıcı: $message
''';

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/interactions',
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey.trim(),
      },
      body: jsonEncode({
        'model': model,
        'input': prompt,
        'system_instruction':
            'Sen Zenci AI adlı Türkçe konuşan akıllı bir asistansın. '
            'Doğal, anlaşılır ve yardımcı cevaplar ver.',
        'store': false,
        'generation_config': {
          'max_output_tokens': 2048,
          'thinking_level': 'medium',
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini bağlantı hatası (${response.statusCode}): '
        '${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final steps = data['steps'] as List?;

    if (steps == null) {
      throw Exception('Gemini yanıtı bulunamadı.');
    }

    final output = steps
        .where((step) => step['type'] == 'model_output')
        .expand((step) => step['content'] as List? ?? [])
        .where((part) => part['type'] == 'text')
        .map((part) => part['text'].toString())
        .join('\n');

    if (output.trim().isEmpty) {
      throw Exception('Gemini boş yanıt döndürdü.');
    }

    return output;
  }
}
