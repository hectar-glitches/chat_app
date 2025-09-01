import 'package:cloud_firestore/cloud_firestore.dart';
import './user.dart';

class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final User sender;
  final String senderId;
  final List<String>? reactions;
  final bool isTyping;
  final String? threadId;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.sender,
    required this.senderId,
    this.reactions,
    this.isTyping = false,
    this.threadId,
    this.imageUrl,
  });
  
  // Create message from Firestore data
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      sender: User(
        id: map['senderId'] ?? '',
        name: map['senderName'] ?? '',
        avatarUrl: map['senderAvatarUrl'] ?? '',
        isOnline: false,
      ),
      senderId: map['senderId'] ?? '',
      reactions: List<String>.from(map['reactions'] ?? []),
      threadId: map['threadId'],
      imageUrl: map['imageUrl'],
    );
  }
  
  // Convert message to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp,
      'senderId': senderId,
      'senderName': sender.name,
      'senderAvatarUrl': sender.avatarUrl,
      'reactions': reactions ?? [],
      'threadId': threadId,
      'imageUrl': imageUrl,
    };
  }
}
