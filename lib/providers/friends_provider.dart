import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import '../models/user.dart';

class FriendsProvider with ChangeNotifier {
  List<User> _contacts = [];
  String? _suggestedGroup;

  List<User> get contacts => _contacts;
  String? get suggestedGroup => _suggestedGroup;

  bool autoJoinGroups = true;
  bool friendsSeeGroups = true;
  bool showLastSeen = true;
  bool allowAIGroups = false;

  FriendsProvider() {
    _initContacts();
    _suggestedGroup = 'Biobuilders';
  }

  Future<void> _initContacts() async {
    final svg = await FluttermojiFunctions().encodeMySVGtoString();
    _contacts = [
      User(
        id: '1',
        name: 'Alice',
        isOnline: true,
        avatarSvg: svg,
        avatarUrl: 'https://robohash.org/alice.png?set=set4',
        commonGroups: ['Amylase Enthusiasts', 'Catalysts Corner'],
        achievements: ['biology expert'],
      ),
      User(
        id: '2',
        name: 'Bob',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 10)),
        avatarSvg: svg,
        avatarUrl: 'https://robohash.org/bob.png?set=set4',
        commonGroups: [],
        achievements: ['chemistry helper'],
      ),
      User(
        id: '3',
        name: 'Charlie',
        isOnline: true,
        avatarSvg: svg,
        avatarUrl: 'https://robohash.org/charlie.png?set=set4',
        commonGroups: ['Amylase Enthusiasts'],
        achievements: ['biology enthusiast', 'consistent learner'],
      ),
    ];
    notifyListeners();
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
}
