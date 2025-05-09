import 'package:flutter/material.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  bool autoJoinGroups = true;
  bool friendsSeeGroups = true;
  bool showLastSeen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Profile Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Automatically join suggested groups'),
            value: autoJoinGroups,
            onChanged: (val) => setState(() => autoJoinGroups = val),
            subtitle: const Text(
              'Allow the app to add you to new groups based on suggestions.',
            ),
          ),
          SwitchListTile(
            title: const Text('Allow friends to see my groups'),
            value: friendsSeeGroups,
            onChanged: (val) => setState(() => friendsSeeGroups = val),
            subtitle: const Text(
              'Control whether your friends can view your group memberships.',
            ),
          ),
          SwitchListTile(
            title: const Text('Show my last seen'),
            value: showLastSeen,
            onChanged: (val) => setState(() => showLastSeen = val),
            subtitle: const Text(
              'Allow others to see when you were last online.',
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Change Profile'),
            subtitle: const Text(
              'Update your name, avatar, or other profile details.',
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile change coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
