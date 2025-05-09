import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import './chat_screen.dart';
import './user_settings_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);
    final contacts = friendsProvider.contacts;
    final suggestedGroup = friendsProvider.suggestedGroup;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (suggestedGroup != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Suggested for you: Join $suggestedGroup',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final user = contacts[index];
                String subtitle = 'Offline';
                Color subtitleColor = Colors.white70;

                if (user.isOnline) {
                  subtitle = 'Online';
                  subtitleColor = Colors.greenAccent;
                } else if (user.lastSeen != null) {
                  final now = DateTime.now();
                  final difference = now.difference(user.lastSeen!);
                  if (difference.inDays > 0) {
                    subtitle =
                        'Last seen ${DateFormat.yMd().format(user.lastSeen!)}';
                  } else if (difference.inHours > 0) {
                    subtitle = 'Last seen ${difference.inHours}h ago';
                  } else if (difference.inMinutes > 0) {
                    subtitle = 'Last seen ${difference.inMinutes}m ago';
                  } else {
                    subtitle = 'Last seen just now';
                  }
                }

                final commonGroups = friendsProvider.getUserGroups(user.id);
                final isTyping = friendsProvider.isTyping(user.id);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GFListTile(
                      avatar: GFAvatar(
                        backgroundColor: Colors.white,
                        child:
                            (user.fluttermojiString.trim().isNotEmpty)
                                ? SvgPicture.string(
                                  user.fluttermojiString,
                                  width: 40,
                                  height: 40,
                                )
                                : const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                      ),
                      titleText: user.name,
                      subTitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 13,
                            ),
                          ),
                          if (isTyping)
                            Row(
                              children: const [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color.fromARGB(255, 11, 140, 45),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Typing...',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 127, 231, 148),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          if (commonGroups.isNotEmpty)
                            Text(
                              'Common groups: ${commonGroups.join(', ')}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 22, 20, 112),
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      icon: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(recipient: user),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 72,
                      endIndent: 16,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for new chat/contact functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New chat functionality coming soon!'),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.black),
      ),
    );
  }
}
