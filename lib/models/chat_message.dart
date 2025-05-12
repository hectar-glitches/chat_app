import './user.dart';

class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final User sender;
  final List<String>? reactions;
  final bool isTyping;
  final String? threadId;

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.sender,
    this.reactions,
    this.isTyping = false,
    this.threadId,
  });
}
