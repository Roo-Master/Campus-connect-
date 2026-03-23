import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../ai/backend/ai_model.dart';

class AiChatService {

  final String apiKey = "YOUR_OPENAI_API_KEY";

  Stream<String> sendMessageStream(List<AiChatMessage> messages) async* {

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final request = http.Request("POST", url);

    request.headers.addAll({
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey"
    });

    request.body = jsonEncode({
      "model": "gpt-4o-mini",
      "stream": true,
      "messages": messages.map((m) => m.toJson()).toList()
    });

    final response = await request.send();

    final stream = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (var line in stream) {

      if (line.startsWith("data: ")) {

        final jsonStr = line.substring(6);

        if (jsonStr == "[DONE]") break;

        final data = jsonDecode(jsonStr);

        final content =
        data["choices"][0]["delta"]["content"];

        if (content != null) {
          yield content;
        }
      }
    }
  }
}