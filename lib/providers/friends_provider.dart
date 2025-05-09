import 'package:flutter/material.dart';
import '../models/user.dart';

class FriendsProvider with ChangeNotifier {
  final List<User> _contacts = [
    User(
      id: '1',
      name: 'Jacobs',
      isOnline: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 2)),
      fluttermojiString: '',
    ),
    User(
      id: '2',
      name: 'Bob',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
      fluttermojiString: '',
    ),
    User(
      id: '3',
      name: 'Charlie',
      isOnline: true,
      lastSeen: DateTime.now(),
      fluttermojiString: '',
    ),
  ];

  final Map<String, List<String>> _userGroups = {
    '1': ['Physics Channel', 'Math Club'],
    '2': ['Physics Channel', 'Chemistry Chat'],
    '3': ['None'],
  };

  final Set<String> _typingUsers = {'1'};

  String? _suggestedGroup;

  List<User> get contacts => _contacts;
  List<String> getUserGroups(String userId) => _userGroups[userId] ?? [];
  bool isTyping(String userId) => _typingUsers.contains(userId);

  // Set the suggested group for the current user (call this from your logic)
  void setSuggestedGroup(String? group) {
    _suggestedGroup = group;
    notifyListeners();
  }

  // Get the suggested group for the current user
  String? get suggestedGroup => _suggestedGroup;
}
