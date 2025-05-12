import 'package:flutter/material.dart';
import '../models/user.dart';

class UserAvatarWithBadge extends StatelessWidget {
  final User user;

  const UserAvatarWithBadge({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage(user.avatarUrl),
          backgroundColor: Colors.grey,
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
                border: Border.all(color: const Color(0xFF2C2C3A), width: 1.5),
              ),
              child: Icon(
                _getAchievementIcon(user.achievements[0]),
                size: 8,
                color: Colors.white,
              ),
            ),
          ),
      ],
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
