import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../models/user.dart';
import '../models/chat_message.dart';
import 'group_chats_screen.dart';
import '../widgets/chat_message_list_item.dart';

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
      appBar: AppBar(
        leadingWidth: 24,
        title: Row(
          children: [
            recipientUser.avatarSvg != null
                ? CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.string(recipientUser.avatarSvg!),
                )
                : CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(recipientUser.avatarUrl),
                ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipientUser.name,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                if (lastSeenStatus.isNotEmpty)
                  Text(
                    lastSeenStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color:
                          recipientUser.isOnline
                              ? Colors.greenAccent
                              : const Color.fromARGB(179, 128, 96, 43),
                    ),
                  ),
              ],
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupChatsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
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
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.7),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.white70,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
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
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
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
                ],
              ),
            ),
          ],
        ),
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
