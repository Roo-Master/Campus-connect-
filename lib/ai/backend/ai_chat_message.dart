class AiChatMessage {
  final String role;
  final String content;

  AiChatMessage({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "content": content,
    };
  }

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      role: json["role"] ?? "",
      content: json["content"] ?? "",
    );
  }

  AiChatMessage copyWith({
    String? role,
    String? content,
  }) {
    return AiChatMessage(
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }
}