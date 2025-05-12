import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import '../models/user.dart';
import '../models/question_thread.dart'; // Add this import statement

class FriendsProvider with ChangeNotifier {
  List<User> _contacts = [];
  String? _suggestedGroup;

  List<User> get contacts => _contacts;
  String? get suggestedGroup => _suggestedGroup;

  bool autoJoinGroups = true;
  bool friendsSeeGroups = true;
  bool showLastSeen = true;
  bool allowAIGroups = false;

  List<QuestionThread> _joinedGroups = [];
  List<QuestionThread> get joinedGroups => _joinedGroups;

  FriendsProvider() {
    _initContacts();
    _initJoinedGroups();
    _suggestedGroup = 'Biobuilders';
  }

  // Update the avatar URLs in your contacts list

  Future<void> _initContacts() async {
    final svg = await FluttermojiFunctions().encodeMySVGtoString();
    _contacts = [
      User(
        id: '1',
        name: 'Alice',
        isOnline: true,
        avatarSvg: svg,
        avatarUrl: 'https://i.pravatar.cc/150?img=1', // More reliable service
        commonGroups: ['Amylase Enthusiasts', 'Catalysts Corner'],
        achievements: ['biology expert'],
      ),
      User(
        id: '2',
        name: 'Bob',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 10)),
        avatarSvg: svg,
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        commonGroups: [],
        achievements: ['chemistry helper'],
      ),
      User(
        id: '3',
        name: 'Charlie',
        isOnline: true,
        avatarSvg: svg,
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        commonGroups: ['Amylase Enthusiasts'],
        achievements: ['biology enthusiast', 'consistent learner'],
      ),
    ];
    notifyListeners();
  }

  void _initJoinedGroups() {
    // This would be replaced with actual groups the user has joined
    // For now, let's use some sample data
    _joinedGroups = [
      QuestionThread(
        id: 'joined1',
        subject: 'Biology Club',
        question: 'Discussion group for Biology enthusiasts',
        participants:
            _contacts
                .where((u) => u.commonGroups.contains('Biology 101'))
                .toList(),
        replies: 120,
        lastUpdate: DateTime.now().subtract(const Duration(minutes: 30)),
        createdBy: '1',
      ),
      QuestionThread(
        id: 'joined2',
        subject: 'Study Group',
        question: 'General academic discussion and help',
        participants:
            _contacts
                .where((u) => u.commonGroups.contains('Study Group'))
                .toList(),
        replies: 78,
        lastUpdate: DateTime.now().subtract(const Duration(hours: 2)),
        createdBy: '2',
      ),
    ];
  }

  void dismissSuggestedGroup() {
    _suggestedGroup = null;
    notifyListeners();
  }

  void toggleAutoJoinGroups(bool value) {
    autoJoinGroups = value;
    notifyListeners();
  }

  void toggleFriendsSeeGroups(bool value) {
    friendsSeeGroups = value;
    notifyListeners();
  }

  void toggleShowLastSeen(bool value) {
    showLastSeen = value;
    notifyListeners();
  }

  void toggleAllowAIGroups(bool value) {
    allowAIGroups = value;
    notifyListeners();
  }

  // Add a method to join a group
  void joinGroup(QuestionThread thread) {
    // Avoid duplicates
    if (!_joinedGroups.any((g) => g.id == thread.id)) {
      _joinedGroups.add(thread);
      notifyListeners();
    }
  }

  // Add a method to leave a group
  void leaveGroup(String threadId) {
    _joinedGroups.removeWhere((g) => g.id == threadId);
    notifyListeners();
  }
}
