import './user.dart'; // Import the User model

class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final User sender;

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.sender,
  });
}
