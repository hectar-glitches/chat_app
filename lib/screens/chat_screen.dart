import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat_2/dash_chat_2.dart' as dash_chat_2;
import '../providers/chat_provider.dart';
import '../models/user.dart';
import '../models/chat_message.dart';

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
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              child: SvgPicture.string(widget.recipient.fluttermojiString),
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
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: dash_chat_2.DashChat(
          currentUser: dash_chat_2.ChatUser(
            id: chatProvider.currentUser!.id,
            firstName: chatProvider.currentUser!.name,
          ),
          onSend: (dashMsg) {
            chatProvider.addMessage(dashMsg.text);
          },
          messages:
              chatProvider.messagesWithSeparators
                  .whereType<ChatMessage>()
                  .map(
                    (msg) => dash_chat_2.ChatMessage(
                      user: dash_chat_2.ChatUser(
                        id: msg.sender.id,
                        firstName: msg.sender.name,
                      ),
                      text: msg.text,
                      createdAt: msg.timestamp,
                    ),
                  )
                  .toList()
                  .reversed
                  .toList(),
          inputOptions: dash_chat_2.InputOptions(
            inputDecoration: InputDecoration(
              hintText: "Type your message...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            sendButtonBuilder:
                (onSend) => IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: onSend,
                ),
          ),
          messageOptions: dash_chat_2.MessageOptions(
            currentUserContainerColor: Colors.teal[800],
            containerColor: Colors.grey, // Very dark grey for others
            textColor: const Color.fromARGB(
              255,
              255,
              255,
              255,
            ), // White text for others
            currentUserTextColor: Colors.white, // White text for self
            borderRadius: 16,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
