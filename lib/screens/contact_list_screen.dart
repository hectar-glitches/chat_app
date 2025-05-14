import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/friends_provider.dart';
import '../providers/group_chat_provider.dart';
import '../models/user.dart';
import '../models/question_thread.dart';
import './chat_screen.dart';
import './user_settings_screen.dart';
import './question_thread_screen.dart';

final Color backgroundColor = const Color(
  0xFF101014,
); // Darker black background
final Color cardColor = const Color(
  0xFF202024,
); // Slightly lighter card background
final Color accentColor = const Color(0xFFFF6B6B); // Coral/red accent color
final Color correctColor = const Color(0xFF4CAF50); // Green for correct answers

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  // Helper method to create a fallback widget when avatar fails to load
  Widget _buildAvatarFallback(User user) {
    return Text(
      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);
    final groupChatProvider = Provider.of<GroupChatProvider>(context);
    final contacts = friendsProvider.contacts;
    final onlineUsers = contacts.where((user) => user.isOnline).toList();
    final suggestedGroup = friendsProvider.suggestedGroup;
    final questionThreads = groupChatProvider.questionThreads;

    return Scaffold(
      backgroundColor: backgroundColor, // Darker background like in screenshot
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: backgroundColor, // Match background
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
            height: 220,
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

          const Divider(
            color: Color(0xFF2A2A2E),
            height: 1,
          ), // Slightly lighter divider
          // Direct Chats Label
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Direct Messages & Joined Groups",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Combined list of contacts and joined groups
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length + friendsProvider.joinedGroups.length,
              itemBuilder: (context, index) {
                // Display joined groups at the top
                if (index < friendsProvider.joinedGroups.length) {
                  final group = friendsProvider.joinedGroups[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: _getSubjectColor(group.subject),
                      child: Icon(
                        _getSubjectIcon(group.subject),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      group.subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "${group.participants.length} members",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00BF6D),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "11",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => QuestionThreadScreen(thread: group),
                        ),
                      );
                    },
                  );
                }

                // Display regular contacts after joined groups
                final user =
                    contacts[index - friendsProvider.joinedGroups.length];
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
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage:
                        user.avatarUrl.isNotEmpty
                            ? NetworkImage(user.avatarUrl)
                            : null,
                    onBackgroundImageError:
                        user.avatarUrl.isNotEmpty
                            ? (_, __) {
                              // Silently handle image loading errors
                            }
                            : null,
                    child:
                        (user.avatarUrl.isEmpty || user.avatarSvg != null)
                            ? (user.avatarSvg != null
                                ? SvgPicture.string(
                                  user.avatarSvg!,
                                  placeholderBuilder:
                                      (context) => _buildAvatarFallback(user),
                                )
                                : _buildAvatarFallback(user))
                            : null,
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
        backgroundColor: accentColor, // Changed to coral accent color
        tooltip: 'Invite new contact',
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ), // Changed icon from add_comment to person_add
        onPressed: () {
          // Show invite contact dialog
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  backgroundColor: const Color(0xFF2C2C3A),
                  title: const Text(
                    'Invite New Contact',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter email or username',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: const Color(0xFF1D1D35),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            accentColor, // Changed to coral accent color
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invitation sent!')),
                        );
                      },
                      child: const Text('Send Invite'),
                    ),
                  ],
                ),
          );
        },
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

class QuestionThreadCard extends StatelessWidget {
  final QuestionThread thread;

  const QuestionThreadCard({super.key, required this.thread});

  // Add these methods to fix the error
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

  String _getThreadTime(DateTime dateTime) {
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

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(
      context,
      listen: false,
    );
    final bool isJoined = friendsProvider.joinedGroups.any(
      (g) => g.id == thread.id,
    );

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
        // Increase height further to accommodate content
        height: isJoined ? 240 : 280,
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: cardColor, // Updated card color
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Use mainAxisSize.max and let Expanded handle the space distribution
          mainAxisSize: MainAxisSize.max,
          children: [
            // Subject Tag - keep compact
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 5.0, // Slightly reduced vertical padding
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

            // Main content area with scrollable content if needed
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Question Title
                      Text(
                        thread.question,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),
                      // Thread Stats
                      Text(
                        "${thread.participants.length} participants · ${thread.replies} replies",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Bottom row with avatars and time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Participant avatars
                          SizedBox(
                            width: 160, // Fixed width instead of percentage
                            height: 24,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ...List.generate(
                                  thread.participants.length > 3
                                      ? 3
                                      : thread.participants.length,
                                  (index) => Positioned(
                                    left: index * 18.0,
                                    child: UserAvatarWithBadge(
                                      user: thread.participants[index],
                                      radius: 12,
                                    ),
                                  ),
                                ),
                                if (thread.participants.length > 3)
                                  Positioned(
                                    left: 3 * 18.0,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade700,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "+${thread.participants.length - 3}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Last update time
                          Text(
                            _getThreadTime(thread.lastUpdate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Join Group Button - only when not joined
            if (!isJoined)
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 30, // Fixed height for button
                  child: OutlinedButton(
                    onPressed: () {
                      friendsProvider.joinGroup(thread);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Joined ${thread.subject}!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accentColor, // Changed to coral accent
                      side: BorderSide(color: accentColor), // Coral border
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero, // Minimal padding
                    ),
                    child: Text(
                      'Join Group',
                      style: TextStyle(
                        fontSize: 13,
                        color: accentColor,
                      ), // Coral text
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class UserAvatarWithBadge extends StatelessWidget {
  final User user;
  final double radius;

  const UserAvatarWithBadge({super.key, required this.user, this.radius = 14});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2 + 4,
      height: radius * 2 + 4,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey.shade700,
              backgroundImage:
                  user.avatarUrl.isNotEmpty
                      ? NetworkImage(user.avatarUrl)
                      : null,
              child:
                  user.avatarSvg != null
                      ? SvgPicture.string(user.avatarSvg!)
                      : Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: radius * 0.8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
          if (user.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: radius * 0.8,
                height: radius * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xFF00BF6D),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2C2C3A),
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
