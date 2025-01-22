import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String _apiKey = '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'; // Replace with your API key
  final String _endpoint = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo", // Use the model you prefer
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": message},
          ],
          "max_tokens": 100,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to connect to OpenAI API: ${response.body}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
