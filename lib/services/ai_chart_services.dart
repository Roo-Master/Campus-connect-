import 'dart:async';

import 'package:campus_connect/ai/backend/ai_chat_message.dart';


class AiChatService {
  Stream<String> sendMessageStream(List<AiChatMessage> messages) async* {
    final userMessage = messages.last.content.toLowerCase();

    String response = _generateDemoResponse(userMessage);

    for (int i = 0; i < response.length; i++) {
      await Future.delayed(const Duration(milliseconds: 18));
      yield response[i];
    }
  }

  String _generateDemoResponse(String input) {
    if (input.contains("fees")) {
      return "You can check your **fee balance**, **payment history**, and **pending charges** from the Fees section in Campus Connect.";
    } else if (input.contains("results")) {
      return "Your **exam results** can be viewed once officially released by the university in the Results section.";
    } else if (input.contains("attendance")) {
      return "You can view your **attendance records** and signed sessions under the Attendance section.";
    } else if (input.contains("hostel")) {
      return "Hostel details such as **room allocation**, **status**, and **availability** are available under the Hostel section.";
    } else if (input.contains("registration")) {
      return "You can register units/courses through the **Course Registration** section once registration is open.";
    } else if (input.contains("hello") || input.contains("hi")) {
      return "Hello 👋\n\nWelcome to **Campus AI Assistant**. How can I help you today?";
    }

    return "I understand your question.\n\nPlease check the relevant section inside **Campus Connect**, or ask me something specific like:\n- Fees\n- Results\n- Attendance\n- Hostel\n- Registration";
  }
}