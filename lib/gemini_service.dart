
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String model = 'gemini-2.5-flash';

  Future<String> sendMessage({
    required String apiKey,
    required String message,
    List<Map<String, String>> history = const [],
  }) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('Gemini API anahtarı girilmemiş.');
    }

    final contents = <Map<String, dynamic>>[];

    for (final item in history) {
      final role = item['role'] == 'assistant'
          ? 'model'
          : 'user';

      final text = item['text'] ?? '';

      if (text.trim().isNotEmpty) {
        contents.add({
          'role': role,
          'parts': [
            {'text': text}
          ]
        });
      }
    }

    contents.add({
      'role': 'user',
      'parts': [
        {'text': message}
      ]
    });

    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/$model:generateContent',
      {'key': apiKey},
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'system_instruction': {
          'parts': [
            {
              'text': 'Sen Zenci AI adlı Türkçe konuşan, '
                  'yardımcı ve akıllı bir yapay zekâ asistanısın. '
                  'Kullanıcıya doğal, anlaşılır ve doğrudan cevap ver.'
            }
          ]
        },
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 2048,
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini bağlantı hatası (${response.statusCode}): '
        '${response.body}'
      );
    }

    final data = jsonDecode(response.body);

    final candidates = data['candidates'];

    if (candidates == null || candidates.isEmpty) {
      throw Exception('Gemini boş yanıt döndürdü.');
    }

    final parts = candidates[0]['content']['parts'] as List;

    final answer = parts
        .where((part) => part['text'] != null)
        .map((part) => part['text'].toString())
        .join('\n');

    if (answer.trim().isEmpty) {
      throw Exception('Gemini yanıtı okunamadı.');
    }

    return answer;
  }
}
