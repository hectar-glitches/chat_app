import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Profile Settings'),
        backgroundColor: const Color(0xFF1A1A2E), // Dark background for AppBar
        foregroundColor: Colors.white, // White text for AppBar
      ),
      body: Container(
        color: const Color(0xFF1A1A2E), // Dark background for the screen
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                'Change Profile',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Update your name, avatar, or other profile details.',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile change coming soon!')),
                );
              },
            ),
            const Divider(color: Colors.white24),
            SwitchListTile(
              title: const Text(
                'Automatically join suggested groups',
                style: TextStyle(color: Colors.white),
              ),
              value: friendsProvider.autoJoinGroups,
              onChanged: friendsProvider.toggleAutoJoinGroups,
              subtitle: const Text(
                'Allow the app to add you to new groups based on suggestions.',
                style: TextStyle(color: Colors.white70),
              ),
              activeColor: Colors.tealAccent,
            ),
            SwitchListTile(
              title: const Text(
                'Allow friends to see my groups',
                style: TextStyle(color: Colors.white),
              ),
              value: friendsProvider.friendsSeeGroups,
              onChanged: friendsProvider.toggleFriendsSeeGroups,
              subtitle: const Text(
                'Control whether your friends can view your group memberships.',
                style: TextStyle(color: Colors.white70),
              ),
              activeColor: Colors.tealAccent,
            ),
            SwitchListTile(
              title: const Text(
                'Show my last seen',
                style: TextStyle(color: Colors.white),
              ),
              value: friendsProvider.showLastSeen,
              onChanged: friendsProvider.toggleShowLastSeen,
              subtitle: const Text(
                'Allow others to see when you were last online.',
                style: TextStyle(color: Colors.white70),
              ),
              activeColor: Colors.tealAccent,
            ),
            SwitchListTile(
              title: const Text(
                'Allow AI collected data points to suggest groups',
                style: TextStyle(color: Colors.white),
              ),
              value: friendsProvider.allowAIGroups,
              onChanged: friendsProvider.toggleAllowAIGroups,
              subtitle: const Text(
                'Enable AI to suggest groups based on your activity.',
                style: TextStyle(color: Colors.white70),
              ),
              activeColor: Colors.tealAccent,
            ),
          ],
        ),
      ),
    );
  }
}
