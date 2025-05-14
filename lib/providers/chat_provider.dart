import '../models/question_thread.dart';

import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import '../models/chat_message.dart';
import '../models/user.dart';
import '../widgets/date_separator.dart';

class ChatProvider with ChangeNotifier {
  User? _currentUser;
  List<ChatMessage>? _messages;
  bool _isLoading = true;

  final Map<String, User> _users = {}; // store all users
  String? _currentChatUserId; // track the current chat user

  // Pagination parameters
  static const int messagesPerPage = 20;
  int _currentPage = 1;
  bool _hasMoreMessages = true;

  // Getter for pagination status
  bool get hasMoreMessages => _hasMoreMessages;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  ChatProvider() {
    _initUsers();
  }

  Future<void> _initUsers() async {
    // get Fluttermoji SVG for avatar
    String? svg;
    try {
      svg = await FluttermojiFunctions().encodeMySVGtoString();
    } catch (e) {
      // handle error if Fluttermoji is not properly initialized
      print('Error initializing Fluttermoji: $e');
      svg = null;
    }

    _currentUser = User(
      id: 'currentUser',
      name: 'Me',
      avatarSvg: svg,
      isOnline: true,
      avatarUrl: 'https://robohash.org/currentUser.png?set=set4',
    );

    // a list of users with different online statuses
    for (int i = 1; i <= 3; i++) {
      _users['user$i'] = User(
        id: 'user$i',
        name: 'User $i',
        avatarSvg: svg,
        lastSeen: DateTime.now().subtract(Duration(minutes: i * 5)),
        isOnline: i % 2 == 0,
        avatarUrl: 'https://robohash.org/user$i.png?set=set4',
        // Add some sample achievements and groups for testing
        achievements:
            i == 1
                ? ['biology expert']
                : i == 2
                ? ['chemistry helper']
                : ['math enthusiast'],
        commonGroups:
            i == 1
                ? ['Biology 101', 'Study Group']
                : i == 2
                ? ['Chemistry Club']
                : ['Physics Forum'],
      );
    }

    // Set a valid default chat user
    _currentChatUserId = 'user1';

    _messages = [
      ChatMessage(
        id: '0',
        text: 'Hello',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        sender: _users['user1']!,
        reactions: ['👍', '❤️'],
      ),
      ChatMessage(
        id: '1',
        text: 'Heyyy, how are you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        sender: _currentUser!,
        reactions: ['😂'],
      ),
      ChatMessage(
        id: '2',
        text: 'I am doing great, thanks for asking!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        sender: _users['user1']!,
        reactions: ['😊'],
      ),
    ];

    _messages!.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    _isLoading = false;
    notifyListeners();
  }

  /// Returns messages with date separators interleaved
  /// This creates a list that contains both ChatMessage objects and DateSeparator objects
  /// to display in the ListView with proper date grouping
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
    return items.toList();
  }

  User? get currentUser => _currentUser;
  User? get otherUser =>
      _currentChatUserId != null ? _users[_currentChatUserId] : null;
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

  void addReaction(String messageId, String reaction) {
    final messageIndex = _messages?.indexWhere((msg) => msg.id == messageId);
    if (messageIndex != null && messageIndex >= 0) {
      final message = _messages![messageIndex];
      List<String> reactions = message.reactions?.toList() ?? [];

      // Toggle the reaction (add if not present, remove if already there)
      if (reactions.contains(reaction)) {
        reactions.remove(reaction);
      } else {
        reactions.add(reaction);
      }

      // a new message with updated reactions
      final updatedMessage = ChatMessage(
        id: message.id,
        text: message.text,
        timestamp: message.timestamp,
        sender: message.sender,
        reactions: reactions,
        isTyping: message.isTyping,
      );

      _messages![messageIndex] = updatedMessage;
      notifyListeners();
    }
  }

  // Add method to get all users
  List<User> get allUsers => _users.values.toList();

  /// Adds a user to the users map if they don't exist already
  /// This ensures we have the user's information available when needed
  ///
  /// @param user The user object to add to the chat provider's user map
  /// @throws ArgumentError if the user object is invalid (has empty id)
  void addUserIfNeeded(User user) {
    // Validate input to prevent data corruption
    if (user.id.isEmpty) {
      throw ArgumentError('Cannot add user with empty id');
    }

    // Only add if the user doesn't exist yet
    if (!_users.containsKey(user.id)) {
      _users[user.id] = user;

      // Initialize the message list for this user if they're the current chat user
      if (_currentChatUserId == user.id &&
          (_messages == null || _messages!.isEmpty)) {
        _messages = [];
      }
    } else {
      // Update user information if they already exist (to keep online status etc. updated)
      _users[user.id] = user;
    }
  }

  // Set current chat user
  void setCurrentChatUser(String userId) {
    _currentChatUserId = userId;
    // Initialize messages for this user
    if (_messages == null || _messages!.isEmpty) {
      _messages = [];
    }
    // Reset pagination when changing chat users
    _resetPagination();
    notifyListeners();
  }

  // Get user by ID
  User? getUserById(String id) {
    if (id == 'currentUser') return _currentUser;
    return _users[id];
  }

  // Method to create a group message/question thread
  void createGroupMessage(String subjectName, String questionText) {
    if (questionText.isEmpty || subjectName.isEmpty || _currentUser == null) {
      return;
    }

    // Generate a unique ID for the thread
    final threadId = 'thread_${DateTime.now().millisecondsSinceEpoch}';

    // create initial participants list with current user
    final List<User> initialParticipants = [_currentUser!];

    // random users who might be interested in this subject
    final potentialParticipants =
        _users.values.where((user) {
          // Check if user's achievements or common groups relate to the subject
          return user.achievements.any(
                (a) => a.toLowerCase().contains(subjectName.toLowerCase()),
              ) ||
              user.commonGroups.any(
                (g) => g.toLowerCase().contains(subjectName.toLowerCase()),
              );
        }).toList();

    // adding up to 2 related users
    if (potentialParticipants.isNotEmpty) {
      potentialParticipants.shuffle();
      final numToAdd =
          potentialParticipants.length > 2 ? 2 : potentialParticipants.length;
      initialParticipants.addAll(potentialParticipants.take(numToAdd));
    }

    // create a the question thread
    final newThread = QuestionThread(
      id: threadId,
      subject: subjectName,
      question: questionText,
      participants: initialParticipants,
      replies: 0,
      lastUpdate: DateTime.now(),
      createdBy: _currentUser!.id,
    );

    // Add the thread to the list (assuming you have a list to store threads)
    _addQuestionThread(newThread);

    // Create an initial message in this thread
    _addThreadMessage(
      threadId: threadId,
      text: questionText,
      sender: _currentUser!,
    );

    // Notify about the new thread creation
    notifyListeners();
  }

  // Helper method to add a question thread
  void _addQuestionThread(QuestionThread thread) {
    // Initialize _questionThreads list if it doesn't exist
    _questionThreads ??= [];

    // Add the new thread
    _questionThreads!.add(thread);

    // Sort threads by last update time
    _questionThreads!.sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));
  }

  // Helper method to add a message to a thread
  void _addThreadMessage({
    required String threadId,
    required String text,
    required User sender,
  }) {
    // Initialize _threadMessages map if it doesn't exist
    _threadMessages ??= {};

    // Initialize the thread's message list if it doesn't exist
    _threadMessages![threadId] ??= [];

    // Create the new message
    final newMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      timestamp: DateTime.now(),
      sender: sender,
      threadId: threadId,
    );

    // Add message to the thread
    _threadMessages![threadId]!.add(newMessage);

    // Update thread's last message timestamp and reply count
    final threadIndex =
        _questionThreads?.indexWhere((t) => t.id == threadId) ?? -1;
    if (threadIndex >= 0) {
      final currentThread = _questionThreads![threadIndex];
      _questionThreads![threadIndex] = currentThread.copyWith(
        lastUpdate: DateTime.now(),
        replies: currentThread.replies + 1,
      );
    }
  }

  // Add these properties to store question threads and their messages
  List<QuestionThread>? _questionThreads;
  Map<String, List<ChatMessage>>? _threadMessages;

  // Getters for the new properties
  List<QuestionThread> get questionThreads => _questionThreads ?? [];
  List<ChatMessage> getThreadMessages(String threadId) =>
      _threadMessages?[threadId] ?? [];

  // Load more messages (pagination)
  Future<void> loadMoreMessages() async {
    if (_isLoadingMore || !_hasMoreMessages) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      // Simulate network delay for loading older messages
      await Future.delayed(const Duration(milliseconds: 800));

      // In a real app, load messages from API with pagination parameters
      final oldestMessageDate =
          _messages?.isNotEmpty == true
              ? _messages!.first.timestamp
              : DateTime.now();

      // Simulating older messages for demonstration
      List<ChatMessage> olderMessages = [];

      // Create some mock older messages for pagination demo
      for (int i = 1; i <= messagesPerPage; i++) {
        final messageDate = oldestMessageDate.subtract(
          Duration(days: (_currentPage > 1) ? _currentPage - 1 : 0, hours: i),
        );

        // Alternate between current user and other user
        final sender = i % 2 == 0 ? _currentUser! : _users[_currentChatUserId]!;

        olderMessages.add(
          ChatMessage(
            id: 'old_${_currentPage}_$i',
            text: 'This is an older message #$i from page $_currentPage',
            timestamp: messageDate,
            sender: sender,
            reactions: i % 5 == 0 ? ['👍'] : null,
          ),
        );
      }

      // Stop pagination after a few pages in this demo
      if (_currentPage >= 3) {
        _hasMoreMessages = false;
      }

      // Add older messages at the beginning of the list
      if (olderMessages.isNotEmpty) {
        // Sort to ensure correct order
        olderMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        _messages = [...olderMessages, ..._messages!];
        _currentPage++;
      } else {
        _hasMoreMessages = false;
      }
    } catch (e) {
      print('Error loading more messages: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Reset pagination when changing users
  void _resetPagination() {
    _currentPage = 1;
    _hasMoreMessages = true;
  }
}
