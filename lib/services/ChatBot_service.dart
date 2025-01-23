import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotService {
  final String _endpoint = 'https://api.openai.com/v1/chat/completions';
  String? _apiKey; // Nullable String to handle cases where the key might not be fetched

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatbotService() {
    fetchApiKey().then((key) {
      _apiKey = key;  // Set the fetched API key for later use
    }).catchError((error) {
      print('Failed to fetch API key: $error');
    });
  }

  Future<String> fetchApiKey() async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('config')
          .doc('apiKeys')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String apiKey = data['chatbotApiKey'];
        if (apiKey.isNotEmpty) {
          return apiKey;
        } else {
          throw Exception('API key is empty.');
        }
      } else {
        throw Exception('API key document does not exist.');
      }
    } catch (e) {
      throw Exception('Failed to fetch API key: $e');
    }
  }

  Future<String> sendMessage(String message) async {
    // Ensure API key is loaded
    if (_apiKey == null || _apiKey!.isEmpty) {
      _apiKey = await fetchApiKey(); // Re-fetch API key if it's not loaded or empty
    }

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo", // Specify the model you prefer
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
      throw Exception('Error using API key: $e');
    }
  }
}
