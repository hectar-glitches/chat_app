import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  // Toggle states
  bool _autoJoinGroups = true;
  bool _showFriendsGroups = true;
  bool _showLastSeen = true;
  bool _allowAiSuggestions = false;
  bool _receiveNotifications = true;
  bool _darkMode = true;
  bool _allowMessageRequests = true;

  @override
  void initState() {
    super.initState();
    // Initialize toggle states from provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _autoJoinGroups = userProvider.autoJoinGroups;
    _showFriendsGroups = userProvider.showFriendsGroups;
    _showLastSeen = userProvider.showLastSeen;
    _allowAiSuggestions = userProvider.allowAiSuggestions;
    _receiveNotifications = userProvider.receiveNotifications;
    _darkMode = userProvider.darkMode;
    _allowMessageRequests = userProvider.allowMessageRequests;
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF101014);
    final Color cardColor = const Color(0xFF202024);
    final Color accentColor = const Color(
      0xFF00BF6D,
    ); // Using green from switches
    final Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Privacy & Profile Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(cardColor, textColor),

            const SizedBox(height: 16),

            _buildPrivacyToggles(accentColor, cardColor, textColor),

            const SizedBox(height: 16),

            _buildNotificationSection(accentColor, cardColor, textColor),

            const SizedBox(height: 16),

            _buildDisplaySection(accentColor, cardColor, textColor),

            const SizedBox(height: 16),

            _buildDeleteSection(cardColor, Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(Color cardColor, Color textColor) {
    return InkWell(
      onTap: () {
        // Navigate to detailed profile editing screen
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            const Icon(Icons.person, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Profile',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Update your name, avatar, or other profile details.',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyToggles(
    Color accentColor,
    Color cardColor,
    Color textColor,
  ) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggleSetting(
          icon: Icons.group_add,
          title: 'Automatically join suggested groups',
          subtitle:
              'Allow the app to add you to new groups based on suggestions.',
          value: _autoJoinGroups,
          onChanged: (value) {
            setState(() => _autoJoinGroups = value);
            userProvider.updateAutoJoinGroups(value);
          },
          accentColor: accentColor,
          textColor: textColor,
        ),
        _buildToggleSetting(
          icon: Icons.visibility,
          title: 'Allow friends to see my groups',
          subtitle:
              'Control whether your friends can view your group memberships.',
          value: _showFriendsGroups,
          onChanged: (value) {
            setState(() => _showFriendsGroups = value);
            userProvider.updateShowFriendsGroups(value);
          },
          accentColor: accentColor,
          textColor: textColor,
        ),
        _buildToggleSetting(
          icon: Icons.access_time,
          title: 'Show my last seen',
          subtitle: 'Allow others to see when you were last online.',
          value: _showLastSeen,
          onChanged: (value) => setState(() => _showLastSeen = value),
          accentColor: accentColor,
          textColor: textColor,
        ),
        _buildToggleSetting(
          icon: Icons.smart_toy,
          title: 'Allow AI collected data points to suggest groups',
          subtitle: 'Enable AI to suggest groups based on your activity.',
          value: _allowAiSuggestions,
          onChanged: (value) => setState(() => _allowAiSuggestions = value),
          accentColor: accentColor,
          textColor: textColor,
        ),
        _buildToggleSetting(
          icon: Icons.person_add,
          title: 'Allow message requests',
          subtitle: 'Control who can send you message requests.',
          value: _allowMessageRequests,
          onChanged: (value) => setState(() => _allowMessageRequests = value),
          accentColor: accentColor,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildNotificationSection(
    Color accentColor,
    Color cardColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            'Notifications',
            style: TextStyle(
              color: textColor.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildToggleSetting(
          icon: Icons.notifications,
          title: 'Push notifications',
          subtitle: 'Receive notifications when you get new messages.',
          value: _receiveNotifications,
          onChanged: (value) => setState(() => _receiveNotifications = value),
          accentColor: accentColor,
          textColor: textColor,
        ),
        _buildSettingItem(
          icon: Icons.do_not_disturb_on,
          title: 'Do Not Disturb',
          subtitle: 'Schedule quiet hours',
          onTap: () {
            // Navigate to DND settings
          },
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildDisplaySection(
    Color accentColor,
    Color cardColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            'Display',
            style: TextStyle(
              color: textColor.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildToggleSetting(
          icon: Icons.dark_mode,
          title: 'Dark mode',
          subtitle: 'Use dark theme',
          value: _darkMode,
          onChanged: (value) => setState(() => _darkMode = value),
          accentColor: accentColor,
          textColor: textColor,
        ),
        _buildSettingItem(
          icon: Icons.format_size,
          title: 'Text size',
          subtitle: 'Change the size of text in the app',
          onTap: () {
            // Navigate to text size settings
          },
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildDeleteSection(Color cardColor, Color redColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  backgroundColor: const Color(0xFF202024),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Delete account logic
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Delete', style: TextStyle(color: redColor)),
                    ),
                  ],
                ),
          );
        },
        child: Row(
          children: [
            Icon(Icons.delete_forever, color: redColor),
            const SizedBox(width: 16),
            Text(
              'Delete Account',
              style: TextStyle(
                color: redColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color accentColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: accentColor,
            activeTrackColor: accentColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
