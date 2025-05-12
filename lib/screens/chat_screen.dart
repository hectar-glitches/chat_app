import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../models/user.dart';
import '../models/chat_message.dart';
import 'group_chats_screen.dart';
import '../widgets/chat_message_list_item.dart';

final Color backgroundColor = const Color(0xFF101014); // Dark background
final Color messageInputBg = const Color(
  0xFF202024,
); // Slightly lighter for input area
final Color userMessageBubble = const Color(
  0xFF00BF6D,
); // Keep the accent color for user messages
final Color otherMessageBubble = const Color(
  0xFF2C2C3A,
); // Dark bubble for others' messages
final Color accentColor = const Color(
  0xFFFF6B6B,
); // Salmon accent color for buttons and highlights

class ChatScreen extends StatefulWidget {
  final User recipient;
  const ChatScreen({super.key, required this.recipient});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set current chat user ID in the provider
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      // Add the recipient to chat provider's users if not already there
      chatProvider.addUserIfNeeded(widget.recipient);

      // Set it as the current chat user
      chatProvider.setCurrentChatUser(widget.recipient.id);

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _addReaction(String messageId, String reaction) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.addReaction(messageId, reaction);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    if (chatProvider.isLoading ||
        chatProvider.currentUser == null ||
        chatProvider.otherUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final User recipientUser = widget.recipient;
    String lastSeenStatus = 'Offline';
    if (recipientUser.isOnline) {
      lastSeenStatus = 'Online';
    } else if (recipientUser.lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(recipientUser.lastSeen!);
      if (difference.inDays > 0) {
        lastSeenStatus =
            'Last seen ${DateFormat.yMd().add_jm().format(recipientUser.lastSeen!)}';
      } else {
        lastSeenStatus =
            'Last seen ${DateFormat.jm().format(recipientUser.lastSeen!)}';
      }
    }
    return Scaffold(
      backgroundColor: backgroundColor, // Dark background
      appBar: AppBar(
        backgroundColor: backgroundColor, // Dark app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // White back button
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  recipientUser.avatarUrl.isNotEmpty
                      ? NetworkImage(recipientUser.avatarUrl)
                      : null,
              backgroundColor: Colors.grey.shade700,
              child:
                  recipientUser.avatarUrl.isEmpty
                      ? Text(
                        recipientUser.name.isNotEmpty
                            ? recipientUser.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipientUser.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  recipientUser.isOnline ? 'Online' : 'Last seen 3:08 PM',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            color: Colors.white70,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.white70,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Date separator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Center(
              child: Text(
                'Today',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ),
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: chatProvider.messagesWithSeparators.length,
              itemBuilder: (context, index) {
                final item = chatProvider.messagesWithSeparators[index];
                if (item is ChatMessage) {
                  return GestureDetector(
                    onLongPress: () {
                      _showReactionOptions(context, item.id);
                    },
                    child: ChatMessageListItem(
                      message: item,
                      isCurrentUser:
                          item.sender.id == chatProvider.currentUser!.id,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white54)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            item.toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.white54)),
                      ],
                    ),
                  );
                }
              },
            ),
          ),

          // Message input area
          Container(
            padding: const EdgeInsets.all(8.0),
            color: messageInputBg, // Darker background for input area
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.sentiment_satisfied_alt),
                  color: Colors.white70,
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.white54),
                      fillColor: backgroundColor, // Darker fill color
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        chatProvider.addMessage(text);
                        _textController.clear();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: accentColor, // Salmon color for send button
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        chatProvider.addMessage(_textController.text);
                        _textController.clear();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReactionOptions(BuildContext context, String messageId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              _reactionButton('👍', messageId),
              _reactionButton('❤️', messageId),
              _reactionButton('😂', messageId),
              _reactionButton('😮', messageId),
              _reactionButton('😢', messageId),
              _reactionButton('🔥', messageId),
            ],
          ),
        );
      },
    );
  }

  Widget _reactionButton(String emoji, String messageId) {
    return GestureDetector(
      onTap: () {
        _addReaction(messageId, emoji);
        Navigator.pop(context);
      },
      child: Text(emoji, style: const TextStyle(fontSize: 30)),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
