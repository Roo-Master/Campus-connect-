import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/ai_chart_services.dart';
import '../services/ai_chat_services.dart';
import '../services/faq_data.dart';
import 'backend/ai_model.dart';

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

  List<AiChatMessage> _messages = [
    AiChatMessage(
      role: "system",
      content: "You are a helpful Campus Connect Assistant.",
    ),
  ];

  StreamSubscription<String>? _streamSubscription;

  bool _isLoading = false;
  bool _isListening = false;

  /// 🌐 Check Internet
  Future<bool> isOnline() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// 🎤 Start Listening
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);

      _speech.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });
      });
    }
  }

  /// 🛑 Stop Listening
  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  /// 📩 Send Message
  void _sendMessage({bool regenerate = false}) async {
    final text = regenerate
        ? _messages.lastWhere((m) => m.role == "user").content
        : _controller.text.trim();

    if (text.isEmpty || _isLoading) return;

    _controller.clear();

    bool online = await isOnline();

    /// 🔴 OFFLINE MODE
    if (!online) {
      final response = faq.entries
          .firstWhere(
            (e) => text.toLowerCase().contains(e.key),
            orElse: () =>
                const MapEntry("default", "No offline answer available."),
          )
          .value;

      setState(() {
        _messages.add(AiChatMessage(role: "user", content: text));
        _messages.add(AiChatMessage(role: "assistant", content: response));
      });

      _scrollToBottom();
      return;
    }

    /// 🟢 ONLINE MODE (Firebase + AI)
    final campusData = await _campusService.getCampusContext();

    final enhancedMessage = """
You are Campus Connect Assistant.

$campusData

User: $text
""";

    setState(() {
      _messages.add(AiChatMessage(role: "user", content: text));
      _messages.add(AiChatMessage(role: "assistant", content: ""));
      _isLoading = true;
    });

    _scrollToBottom();

    _streamSubscription?.cancel();

    _streamSubscription = _chatService.sendMessageStream([
      ..._messages,
      AiChatMessage(role: "user", content: enhancedMessage),
    ]).listen((chunk) {
      setState(() {
        _messages.last = AiChatMessage(
          role: "assistant",
          content: _messages.last.content + chunk,
        );
      });
      _scrollToBottom();
    }, onDone: () {
      setState(() => _isLoading = false);
    }, onError: (_) {
      setState(() {
        _messages.last = AiChatMessage(
          role: "assistant",
          content: "⚠️ Something went wrong.",
        );
        _isLoading = false;
      });
    });
  }

  /// 🛑 Stop AI Generation
  void _stopGeneration() {
    _streamSubscription?.cancel();
    setState(() => _isLoading = false);
  }

  /// ⬇ Scroll
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  /// 🖥 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF343541),
      appBar: AppBar(
        backgroundColor: const Color(0xFF202123),
        title: const Text("Campus AI Assistant"),
      ),
      body: Column(
        children: [
          /// 💬 Chat List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                final msg = _messages[index];
                if (msg.role == "system") return const SizedBox();

                final isUser = msg.role == "user";

                return Container(
                  color: isUser
                      ? const Color(0xFF343541)
                      : const Color(0xFF444654),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: isUser ? Colors.blue : Colors.green,
                        child: Text(
                          isUser ? "U" : "AI",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MarkdownBody(
                              data: msg.content,
                              selectable: true,
                              styleSheet: MarkdownStyleSheet(
                                p: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if (!isUser)
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy,
                                        color: Colors.white70, size: 18),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: msg.content));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(content: Text("Copied")),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh,
                                        color: Colors.white70, size: 18),
                                    onPressed: () =>
                                        _sendMessage(regenerate: true),
                                  ),
                                ],
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          /// ⏹ Stop Button
          if (_isLoading)
            TextButton(
              onPressed: _stopGeneration,
              child: const Text("Stop generating"),
            ),

          /// ✍ Input Bar
          _buildInputBar(),
        ],
      ),
    );
  }

  /// ✍ Input UI
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFF202123),
      child: Row(
        children: [
          /// 🎤 Mic
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
            onPressed: _isListening ? _stopListening : _startListening,
          ),

          /// ✍ Text
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ask about campus...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF40414F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// 📤 Send
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
