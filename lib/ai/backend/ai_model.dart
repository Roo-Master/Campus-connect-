import 'dart:convert';

/// ===============================
/// Chat Message Model
/// ===============================
class AiChatMessage {
  final String role; // system | user | assistant
  final String content;

  AiChatMessage({
    required this.role,
    required this.content,
  });

  /// Convert object → JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "content": content,
    };
  }

  /// Convert JSON → object (for API response)
  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      role: json["role"] ?? "",
      content: json["content"] ?? "",
    );
  }
}

/// ===============================
/// Chat Request Model
/// ===============================
class ChatRequest {
  final List<AiChatMessage> messages;

  ChatRequest({required this.messages});

  Map<String, dynamic> toJson() {
    return {
      "messages": messages.map((m) => m.toJson()).toList(),
    };
  }
}

/// ===============================
/// Chat Response Model
/// (Matches OpenAI response format)
/// ===============================
class ChatResponse {
  final String content;

  ChatResponse({required this.content});

  factory ChatResponse.fromRawJson(String str) =>
      ChatResponse.fromJson(json.decode(str));

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      content:
      json["choices"]?[0]?["message"]?["content"] ?? "",
    );
  }
}
