import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const ChatMessageListItem({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message Bubble
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isCurrentUser)
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(message.sender.avatarUrl),
                  backgroundColor: Colors.grey[800],
                ),
              if (!isCurrentUser) const SizedBox(width: 8),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isCurrentUser
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                      bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                    ),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.5, // Improve readability
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Timestamp
          Text(
            DateFormat('hh:mm a').format(message.timestamp),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          // Reactions Row
          if (message.reactions != null && message.reactions!.isNotEmpty)
            Row(
              mainAxisAlignment:
                  isCurrentUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children:
                  message.reactions!.map((reaction) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        reaction,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }
}
