import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../providers/group_chat_provider.dart';
import '../models/user.dart';
import '../models/question_thread.dart';
import './chat_screen.dart';
import './user_settings_screen.dart';
import './question_thread_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);
    final groupChatProvider = Provider.of<GroupChatProvider>(context);
    final contacts = friendsProvider.contacts;
    final onlineUsers = contacts.where((user) => user.isOnline).toList();
    final suggestedGroup = friendsProvider.suggestedGroup;
    final questionThreads = groupChatProvider.questionThreads;

    return Scaffold(
      backgroundColor: const Color(0xFF1D1D35),
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF1D1D35),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Chats",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
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
          // AI Suggested Group Section
          if (suggestedGroup != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFF2C2C3A),
              child: Row(
                children: [
                  const Icon(Icons.group, color: Colors.orange, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI Suggestion: Join "$suggestedGroup"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Joined "$suggestedGroup"!')),
                      );
                    },
                    child: const Text(
                      'Join',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      friendsProvider.dismissSuggestedGroup();
                    },
                    child: const Text(
                      'Dismiss',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

          // Question Threads & Group Chats Section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Question Threads",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Question Threads List
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: questionThreads.length,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemBuilder: (context, index) {
                final thread = questionThreads[index];
                return QuestionThreadCard(thread: thread);
              },
            ),
          ),

          const Divider(color: Color(0xFF2C2C3A), height: 1),

          // Direct Chats Label
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Direct Messages",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Contacts List
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final user = contacts[index];
                String subtitle = 'Offline';
                Color subtitleColor = Colors.white70;

                if (user.isOnline) {
                  subtitle = 'Online';
                  subtitleColor = const Color(0xFF00BF6D);
                } else if (user.lastSeen != null) {
                  final now = DateTime.now();
                  final difference = now.difference(user.lastSeen!);
                  if (difference.inDays > 0) {
                    subtitle = 'Last seen ${difference.inDays}d ago';
                  } else if (difference.inHours > 0) {
                    subtitle = 'Last seen ${difference.inHours}h ago';
                  } else if (difference.inMinutes > 0) {
                    subtitle = 'Last seen ${difference.inMinutes}m ago';
                  } else {
                    subtitle = 'Last seen just now';
                  }
                }

                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user.avatarUrl),
                    backgroundColor: Colors.grey,
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(color: subtitleColor, fontSize: 13),
                      ),
                      if (user.commonGroups.isNotEmpty)
                        Text(
                          'Common Groups: ${user.commonGroups.join(', ')}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(recipient: user),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00BF6D),
        child: const Icon(Icons.add_comment, color: Colors.white),
        onPressed: () {
          // Create new chat or question thread
        },
      ),
    );
  }
}

class QuestionThreadCard extends StatelessWidget {
  final QuestionThread thread;

  const QuestionThreadCard({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionThreadScreen(thread: thread),
          ),
        );
      },
      child: Container(
        width: 240,
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C3A),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Tag
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: _getSubjectColor(thread.subject),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getSubjectIcon(thread.subject),
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    thread.subject,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Question Title
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
              child: Text(
                thread.question,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            // Thread Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "${thread.participants.length} participants · ${thread.replies} replies",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
            const Spacer(),
            // Participants
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Participant avatars
                  SizedBox(
                    width: 100,
                    height: 32, // Add a fixed height constraint
                    child: Stack(
                      clipBehavior:
                          Clip.none, // Important to allow overflow positioning
                      children: List.generate(
                        thread.participants.length > 3
                            ? 3
                            : thread.participants.length,
                        (index) => Positioned(
                          left: index * 20.0,
                          child: UserAvatarWithBadge(
                            user: thread.participants[index],
                          ),
                        ),
                      )..add(
                        thread.participants.length > 3
                            ? Positioned(
                              left: 3 * 20.0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "+${thread.participants.length - 3}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  // Last update time
                  Text(
                    _getTimeAgo(thread.lastUpdate),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'biology':
        return Colors.green.shade700;
      case 'chemistry':
        return Colors.purple.shade700;
      case 'physics':
        return Colors.blue.shade700;
      case 'math':
        return Colors.orange.shade700;
      default:
        return Colors.teal.shade700;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'biology':
        return Icons.biotech;
      case 'chemistry':
        return Icons.science;
      case 'physics':
        return Icons.waves;
      case 'math':
        return Icons.functions;
      default:
        return Icons.menu_book;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }
}

class UserAvatarWithBadge extends StatelessWidget {
  final User user;
  final double radius;

  const UserAvatarWithBadge({super.key, required this.user, this.radius = 14});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2 + 4, // Ensure fixed width
      height: radius * 2 + 4, // Ensure fixed height
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: CircleAvatar(
              radius: radius,
              backgroundImage: NetworkImage(user.avatarUrl),
              backgroundColor: Colors.grey,
            ),
          ),
          if (user.achievements.isNotEmpty)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _getAchievementColor(user.achievements[0]),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2C2C3A),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  _getAchievementIcon(user.achievements[0]),
                  size: radius * 0.5,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getAchievementColor(String achievement) {
    if (achievement.contains('expert')) {
      return Colors.amber;
    } else if (achievement.contains('master')) {
      return Colors.indigoAccent;
    } else if (achievement.contains('helper')) {
      return Colors.green;
    } else {
      return Colors.teal;
    }
  }

  IconData _getAchievementIcon(String achievement) {
    if (achievement.contains('expert')) {
      return Icons.star;
    } else if (achievement.contains('master')) {
      return Icons.workspace_premium;
    } else if (achievement.contains('helper')) {
      return Icons.handshake;
    } else {
      return Icons.emoji_events;
    }
  }
}
