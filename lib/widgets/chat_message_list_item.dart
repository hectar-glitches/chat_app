import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/chat_message.dart';

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const ChatMessageListItem({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  Widget _buildAvatar(BuildContext context) {
    final svgString = message.sender.fluttermojiString;
    if (svgString.isNotEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: Colors.transparent,
        child: SvgPicture.string(svgString),
      );
    }
    // fallback to default Fluttermoji if string is empty
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      child: Icon(
        Icons.person,
        size: 20,
        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _buildAvatar(context);
    final messageCard = Card(
      elevation: 2.0, // Added elevation
      color:
          isCurrentUser
              ? Theme.of(context).primaryColorDark
              : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(
            isCurrentUser ? 16 : 4,
          ), // More "speech bubble" like
          bottomRight: Radius.circular(
            isCurrentUser ? 4 : 16,
          ), // More "speech bubble" like
        ),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color:
                    isCurrentUser
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: TextStyle(
                color:
                    isCurrentUser
                        ? Colors.white70
                        : Theme.of(context).textTheme.bodySmall?.color ??
                            Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 6.0,
      ), // Increased vertical padding slightly
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            CrossAxisAlignment.end, // Align avatar with bottom of message card
        children: [
          if (!isCurrentUser) ...[avatar, const SizedBox(width: 8)],
          Flexible(
            child: ConstrainedBox(
              // Ensure message card doesn't exceed a certain width
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: messageCard,
            ),
          ),
          if (isCurrentUser) ...[const SizedBox(width: 8), avatar],
        ],
      ),
    );
  }
}
