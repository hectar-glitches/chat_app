import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question_thread.dart';
import '../models/user.dart';
import '../providers/group_chat_provider.dart';

class QuestionThreadScreen extends StatefulWidget {
  final QuestionThread thread;

  const QuestionThreadScreen({super.key, required this.thread});

  @override
  State<QuestionThreadScreen> createState() => _QuestionThreadScreenState();
}

class _QuestionThreadScreenState extends State<QuestionThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1D35),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _getSubjectColor(widget.thread.subject),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.thread.subject,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.thread.participants.length} participants · ${widget.thread.replies} replies",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Participants',
            onPressed: () {
              _showParticipantsModal(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Question card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C3A),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40, // Fixed height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        widget.thread.participants.length > 3
                            ? 3
                            : widget.thread.participants.length,
                    itemBuilder: (context, index) {
                      final user = widget.thread.participants[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: UserAvatarWithBadge(user: user),
                      );
                    },
                  ),
                ),
                if (widget.thread.participants.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "+${widget.thread.participants.length - 3} more participants",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  widget.thread.question,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getTimeAgo(widget.thread.lastUpdate),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {},
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {},
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider with replies count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: Container(height: 1, color: Colors.white24)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${widget.thread.replies} Replies",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(child: Container(height: 1, color: Colors.white24)),
              ],
            ),
          ),

          // Reply thread
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              itemCount: 5, // Mock replies
              itemBuilder: (context, index) {
                // Get a random user from participants
                final user =
                    widget.thread.participants.isNotEmpty
                        ? widget.thread.participants[index %
                            widget.thread.participants.length]
                        : null;

                if (user == null) {
                  return const SizedBox.shrink(); // Return empty widget if no user
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C3A),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Add this
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserAvatarWithBadge(user: user),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min, // Add this
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      // Wrap in Flexible
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        overflow:
                                            TextOverflow.ellipsis, // Add this
                                      ),
                                    ),
                                    if (user.achievements.isNotEmpty)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getAchievementColor(
                                            user.achievements[0],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _getAchievementIcon(
                                                user.achievements[0],
                                              ),
                                              size: 10,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              user.achievements[0],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _getMockReply(index, widget.thread.subject),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      "${(index + 1) * 3}h ago",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.thumb_up_outlined,
                                        size: 16,
                                        color: Colors.white70,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${index * 2 + 1}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.reply,
                                        size: 16,
                                        color: Colors.white70,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(color: Color(0xFF2C2C3A)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add your reply...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1D1D35),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.white70,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF00BF6D),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        Provider.of<GroupChatProvider>(
                          context,
                          listen: false,
                        ).addReplyToThread(widget.thread.id);
                        _messageController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reply added to thread'),
                            duration: Duration(seconds: 1),
                          ),
                        );
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

  void _showParticipantsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C3A),
      isScrollControlled: true, // Allow scrolling
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.4, // Start with 40% of screen
            minChildSize: 0.2, // Min 20% of screen
            maxChildSize: 0.8, // Max 80% of screen
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Participants',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.thread.participants.isEmpty)
                      const Text(
                        'No participants yet',
                        style: TextStyle(color: Colors.white70),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: widget.thread.participants.length,
                          itemBuilder: (context, index) {
                            final user = widget.thread.participants[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: UserAvatarWithBadge(
                                user: user,
                                radius: 18, // Slightly larger for the modal
                              ),
                              title: Text(
                                user.name,
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle:
                                  user.achievements.isNotEmpty
                                      ? Text(
                                        user.achievements.join(', '),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                      : null,
                              trailing: Icon(
                                user.isOnline
                                    ? Icons.circle
                                    : Icons.circle_outlined,
                                size: 12,
                                color:
                                    user.isOnline ? Colors.green : Colors.grey,
                              ),
                            );
                          },
                        ),
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

  String _getMockReply(int index, String subject) {
    if (subject.toLowerCase() == 'biology') {
      List<String> replies = [
        "Cells maintain homeostasis during osmotic stress by regulating the movement of water and solutes through the cell membrane. This happens through processes like osmoregulation and the action of membrane proteins.",
        "The cell's response to osmotic stress involves the activation of various pathways, including MAP kinase cascades and the production of compatible solutes like glycerol.",
        "During hyperosmotic stress, cells experience water loss and shrinkage. They respond by activating ion transporters to increase internal solute concentration and draw water back in.",
        "It's important to note that different cell types have evolved specific mechanisms. For example, plant cells have cell walls that provide mechanical protection against osmotic lysis.",
        "Homeostatic responses also include changes in gene expression, particularly genes encoding membrane transporters and enzymes involved in osmolyte synthesis.",
      ];
      return replies[index % replies.length];
    } else {
      return "This is a sample reply to the thread question. It would contain relevant information about $subject.";
    }
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
                  size: radius * 0.5, // Scale icon size based on radius
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
