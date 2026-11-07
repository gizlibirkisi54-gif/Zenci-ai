
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeService {
  static const String _endpoint =
      'https://api.anthropic.com/v1/messages';

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
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-5',
        'max_tokens': 2048,
        'messages': messages,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final message = data['error']?['message'] ??
          'Claude bağlantısı başarısız oldu.';
      throw Exception(message);
    }

    final content = data['content'] as List<dynamic>? ?? [];

    final answer = content
        .where((item) => item['type'] == 'text')
        .map((item) => item['text'] as String)
        .join('\n');

    if (answer.isEmpty) {
      throw Exception('Claude boş yanıt döndürdü.');
    }

    return answer;
  }
}
