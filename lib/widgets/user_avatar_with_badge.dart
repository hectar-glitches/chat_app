import 'package:flutter/material.dart';
import '../models/user.dart';

class UserAvatarWithBadge extends StatelessWidget {
  final User user;
  static const double _avatarRadius = 14;
  static const double _iconSize = 8;
  static const double _badgePadding = 2;
  static const double _badgeBorderWidth = 1.5;

  const UserAvatarWithBadge({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final hasAchievement = user.achievements.isNotEmpty;
    final firstAchievement = hasAchievement ? user.achievements.first : null;

    return Stack(
      children: [
        CircleAvatar(
          radius: _avatarRadius,
          backgroundImage: user.avatarUrl.isNotEmpty
              ? NetworkImage(user.avatarUrl)
              : const AssetImage('assets/default_avatar.png') as ImageProvider,
          backgroundColor: Colors.grey,
        ),
        if (hasAchievement && firstAchievement != null)
          Positioned(
            right: -2,
            bottom: -2,
            child: Tooltip(
              message: firstAchievement,
              child: Container(
                padding: const EdgeInsets.all(_badgePadding),
                decoration: BoxDecoration(
                  color: _getAchievementColor(firstAchievement),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2C2C3A),
                    width: _badgeBorderWidth,
                  ),
                ),
                child: Icon(
                  _getAchievementIcon(firstAchievement),
                  size: _iconSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getAchievementColor(String achievement) { ... }

  IconData _getAchievementIcon(String achievement) { ... }
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
