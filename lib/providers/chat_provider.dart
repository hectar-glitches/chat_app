import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import '../models/chat_message.dart';
import '../models/user.dart';
import '../widgets/date_separator.dart';

class ChatProvider with ChangeNotifier {
  User? _currentUser;
  User? _otherUser;
  List<ChatMessage>? _messages;
  bool _isLoading = true;

  ChatProvider() {
    _initUsers();
  }

  Future<void> _initUsers() async {
    final svg = await FluttermojiFunctions().encodeMySVGtoString();
    _currentUser = User(
      id: 'currentUser',
      name: 'Me',
      fluttermojiString: svg,
      isOnline: true,
    );
    _otherUser = User(
      id: 'user2',
      name: 'Friend',
      fluttermojiString: svg,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 10)),
      isOnline: false,
    );
    // Sample messages with varying dates for testing DateSeparator
    _messages = [
      ChatMessage(
        id: '0',
        text: 'Older message from yesterday',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        sender: _otherUser!, // use non-null assertion
      ),
      ChatMessage(
        id: '1',
        text: 'Hey! How are you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        sender: _otherUser!,
      ),
      ChatMessage(
        id: '2',
        text: 'I am good, thanks! Preparing for the big test.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        sender: _currentUser!,
      ),
      ChatMessage(
        id: '3',
        text: 'Awesome! Which topic are you focusing on today?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        sender: _otherUser!,
      ),
      ChatMessage(
        id: '4',
        text: 'Physics, specifically kinematics.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        sender: _currentUser!,
      ),
      ChatMessage(
        id: '5',
        text:
            'Oh, cool! I just finished that. Let me know if you need help with anything.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        sender: _otherUser!,
      ),
      ChatMessage(
        id: '6',
        text: 'Message from two days ago',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        sender: _currentUser!,
      ),
    ];
    _messages!.sort(
      (a, b) => a.timestamp.compareTo(b.timestamp),
    ); // Ensure messages are sorted by time
    _isLoading = false;
    notifyListeners();
  }

  // Updated to return a list of dynamic to include ChatMessage and DateSeparator
  List<dynamic> get messagesWithSeparators {
    if (_messages == null || _messages!.isEmpty) return [];

    List<dynamic> items = [];
    DateTime? lastDate;

    for (var message in _messages!) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      if (lastDate == null || messageDate.isAfter(lastDate)) {
        items.add(DateSeparator(date: messageDate));
        lastDate = messageDate;
      }
      items.add(message);
    }
    return items.reversed
        .toList(); // Reverse to show latest messages and their dates at the bottom
  }

  User? get currentUser => _currentUser;
  User? get otherUser => _otherUser;
  bool get isLoading => _isLoading;

  void addMessage(String text) {
    if (text.isNotEmpty && _currentUser != null && _messages != null) {
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        timestamp: DateTime.now(),
        sender: _currentUser!,
      );
      _messages!.add(newMessage);
      notifyListeners();
    }
  }
}
