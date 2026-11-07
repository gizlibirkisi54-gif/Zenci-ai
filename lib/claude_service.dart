
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeService {
  Future<String> sendMessage({
    required String apiKey,
    required String prompt,
    List<Map<String, String>> history = const [],
  }) async {
    final messages = <Map<String, dynamic>>[];

    for (final item in history) {
      final role = item['role'];
      final text = item['text'];

      if ((role == 'user' || role == 'assistant') &&
          text != null &&
          text.isNotEmpty) {
        messages.add({
          'role': role,
          'content': text,
        });
      }
    }

    messages.add({
      'role': 'user',
      'content': prompt,
    });

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-5-20250929',
        'max_tokens': 2048,
        'messages': messages,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['error']?['message'] ?? 'Claude bağlantı hatası',
      );
    }

    final content = data['content'] as List<dynamic>? ?? [];

    return content
        .where((item) => item['type'] == 'text')
        .map((item) => item['text'] as String)
        .join('\n');
  }
}
