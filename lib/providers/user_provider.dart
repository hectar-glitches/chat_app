import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _currentUser = User(
    id: 'current_user_id',
    name: 'Current User',
    avatarUrl: '',
    isOnline: true,
  );

  User get currentUser => _currentUser;

  // Settings preferences
  bool _autoJoinGroups = true;
  bool _showFriendsGroups = true;
  bool _showLastSeen = true;
  bool _allowAiSuggestions = false;
  bool _receiveNotifications = true;
  bool _darkMode = true;
  bool _allowMessageRequests = true;

  // Getters
  bool get autoJoinGroups => _autoJoinGroups;
  bool get showFriendsGroups => _showFriendsGroups;
  bool get showLastSeen => _showLastSeen;
  bool get allowAiSuggestions => _allowAiSuggestions;
  bool get receiveNotifications => _receiveNotifications;
  bool get darkMode => _darkMode;
  bool get allowMessageRequests => _allowMessageRequests;

  // Settings updaters
  void updateAutoJoinGroups(bool value) {
    _autoJoinGroups = value;
    notifyListeners();
  }

  void updateShowFriendsGroups(bool value) {
    _showFriendsGroups = value;
    notifyListeners();
  }

  void updateShowLastSeen(bool value) {
    _showLastSeen = value;
    notifyListeners();
  }

  void updateAllowAiSuggestions(bool value) {
    _allowAiSuggestions = value;
    notifyListeners();
  }

  void updateReceiveNotifications(bool value) {
    _receiveNotifications = value;
    notifyListeners();
  }

  void updateDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void updateAllowMessageRequests(bool value) {
    _allowMessageRequests = value;
    notifyListeners();
  }

  // Profile update methods
  void updateUserName(String name) {
    _currentUser = _currentUser.copyWith(name: name);
    notifyListeners();
  }

  void updateUserAvatar(String avatarUrl) {
    _currentUser = _currentUser.copyWith(avatarUrl: avatarUrl);
    notifyListeners();
  }

  void updateUserStatus(bool isOnline) {
    _currentUser = _currentUser.copyWith(isOnline: isOnline);
    notifyListeners();
  }

  // Method to simulate account deletion
  Future<void> deleteUserAccount() async {
    // In a real app, this would make an API call to delete the user account
    await Future.delayed(const Duration(seconds: 1));

    // Reset user data or perform logout operations
    // For now we'll just notify listeners
    notifyListeners();
  }
}
