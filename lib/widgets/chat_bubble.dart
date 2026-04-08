import 'package:campus_connect/ai/backend/ai_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';


class ChatBubble extends StatelessWidget {
  final AiChatMessage message;
  final bool isUser;
  final VoidCallback? onRegenerate;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser
        ? const Color(0xFF2563EB)
        : const Color(0xFF2D2F39);

    final avatarColor = isUser
        ? const Color(0xFF1D4ED8)
        : const Color(0xFF10B981);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: avatarColor,
              child: const Text(
                "AI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownBody(
                    data: message.content,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.5,
                      ),
                      strong: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!isUser) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _smallIcon(
                          icon: Icons.copy_rounded,
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: message.content),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Copied")),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        _smallIcon(
                          icon: Icons.refresh_rounded,
                          onTap: onRegenerate,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 18,
              backgroundColor: avatarColor,
              child: const Text(
                "U",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _smallIcon({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }
}