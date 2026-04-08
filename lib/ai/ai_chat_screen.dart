import 'dart:async';
import 'package:campus_connect/ai/backend/ai_chat_message.dart';
import 'package:campus_connect/services/ai_chat_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/ai_chart_services.dart';
import '../services/faq_data.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/typing_indicator.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final AiChatService _chatService = AiChatService();
  final CampusDataService _campusService = CampusDataService();
  final SpeechToText _speech = SpeechToText();

  StreamSubscription<String>? _streamSubscription;

  final List<AiChatMessage> _messages = [
    AiChatMessage(
      role: "assistant",
      content:
          "Hello 👋\n\nWelcome to **Campus AI Assistant**.\nAsk me about:\n- Fees\n- Results\n- Attendance\n- Hostel\n- Registration",
    ),
  ];

  bool _isLoading = false;
  bool _isListening = false;

  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (!available) return;

    setState(() => _isListening = true);

    _speech.listen(
      onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
      },
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _sendMessage({bool regenerate = false}) async {
    final text = regenerate
        ? _messages.lastWhere((m) => m.role == "user").content
        : _controller.text.trim();

    if (text.isEmpty || _isLoading) return;

    if (!regenerate) _controller.clear();
    _stopListening();

    final online = await isOnline();

    /// 🔴 OFFLINE MODE
    if (!online) {
      final response = faq.entries
          .firstWhere(
            (e) => text.toLowerCase().contains(e.key),
            orElse: () => const MapEntry(
              "default",
              "You are offline. No exact offline answer found.",
            ),
          )
          .value;

      setState(() {
        _messages.add(AiChatMessage(role: "user", content: text));
        _messages.add(AiChatMessage(role: "assistant", content: response));
      });

      _scrollToBottom();
      return;
    }

    /// 🟢 ONLINE MODE
    final campusData = await _campusService.getCampusContext();

    final enhancedPrompt = """
You are Campus Connect Assistant.

$campusData

User Question: $text
""";

    setState(() {
      _messages.add(AiChatMessage(role: "user", content: text));
      _messages.add(AiChatMessage(role: "assistant", content: ""));
      _isLoading = true;
    });

    _scrollToBottom();
    _streamSubscription?.cancel();

    _streamSubscription = _chatService
        .sendMessageStream([
          ..._messages,
          AiChatMessage(role: "user", content: enhancedPrompt),
        ])
        .listen(
      (chunk) {
        if (!mounted) return;

        setState(() {
          final current = _messages.last;
          _messages[_messages.length - 1] = AiChatMessage(
            role: current.role,
            content: current.content + chunk,
          );
        });

        _scrollToBottom();
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _isLoading = false);
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _messages[_messages.length - 1] = AiChatMessage(
            role: "assistant",
            content: "⚠️ Something went wrong. Please try again.",
          );
          _isLoading = false;
        });
      },
    );
  }

  void _stopGeneration() {
    _streamSubscription?.cancel();
    setState(() => _isLoading = false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _streamSubscription?.cancel();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF343541),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF202123),
        title: const Text(
          "Campus AI Assistant",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (_isLoading)
            IconButton(
              onPressed: _stopGeneration,
              icon: const Icon(Icons.stop_circle_outlined),
              tooltip: "Stop generating",
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      "Start chatting...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (_isLoading && index == _messages.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFF10B981),
                                child: Text(
                                  "AI",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              TypingIndicator(),
                            ],
                          ),
                        );
                      }

                      final msg = _messages[index];
                      return ChatBubble(
                        message: msg,
                        isUser: msg.role == "user",
                        onRegenerate: msg.role == "assistant"
                            ? () => _sendMessage(regenerate: true)
                            : null,
                      );
                    },
                  ),
          ),
          ChatInputBar(
            controller: _controller,
            isListening: _isListening,
            onMicTap: _isListening ? _stopListening : _startListening,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}