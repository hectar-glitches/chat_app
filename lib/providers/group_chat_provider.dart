import 'package:flutter/foundation.dart';
import '../models/question_thread.dart';
import '../models/user.dart';

class GroupChatProvider with ChangeNotifier {
  List<QuestionThread> _questionThreads = [];

  List<QuestionThread> get questionThreads => _questionThreads;

  GroupChatProvider() {
    // Initialize with mock data
    _loadMockThreads();
  }

  void _loadMockThreads() {
    _questionThreads = [
      QuestionThread(
        id: '1',
        subject: 'Anatomists',
        question: 'How do cells maintain homeostasis during osmotic stress?',
        participants: [
          User(
            id: '1',
            name: 'Emma Johnson',
            avatarUrl:
                'https://i.pravatar.cc/150?img=5',
            isOnline: true,
            achievements: ['biology expert'],
            commonGroups: ['Biology 101'],
            lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          User(
            id: '2',
            name: 'Alex Chen',
            avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
            isOnline: true,
            achievements: ['biology helper'],
            commonGroups: ['Biology 101', 'Study Group'],
            lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          User(
            id: '3',
            name: 'Sarah Williams',
            avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
            isOnline: false,
            achievements: ['science enthusiast'],
            commonGroups: ['Biology 101'],
            lastSeen: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
        replies: 24,
        lastUpdate: DateTime.now().subtract(const Duration(minutes: 10)),
        createdBy: '1', // Added createdBy parameter (Emma Johnson's ID)
      ),
      QuestionThread(
        id: '2',
        subject: 'Alchemists',
        question:
            'Can someone explain the difference between SN1 and SN2 reactions?',
        participants: [
          User(
            id: '4',
            name: 'Michael Brown',
            avatarUrl: 'https://randomuser.me/api/portraits/men/43.jpg',
            isOnline: false,
            achievements: ['chemistry master'],
            commonGroups: ['Chemistry Club'],
            lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          User(
            id: '5',
            name: 'Jessica Lee',
            avatarUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
            isOnline: true,
            achievements: [],
            commonGroups: [],
            lastSeen: DateTime.now(),
          ),
        ],
        replies: 8,
        lastUpdate: DateTime.now().subtract(const Duration(hours: 2)),
        createdBy: '4', // Added createdBy parameter (Michael Brown's ID)
      ),
      QuestionThread(
        id: '3',
        subject: 'Biobuilders',
        question:
            'What are the stages of mitosis and how do they differ from meiosis?',
        participants: [
          User(
            id: '1',
            name: 'Emma Johnson',
            avatarUrl:
                'https://randomuser.me/api/portraits/men/22.jpg',
            isOnline: true,
            achievements: ['biology expert'],
            commonGroups: ['Biology 101'],
            lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          User(
            id: '6',
            name: 'David Smith',
            avatarUrl: 'https://randomuser.me/api/portraits/men/22.jpg',
            isOnline: false,
            achievements: ['consistent learner'],
            commonGroups: ['Study Group'],
            lastSeen: DateTime.now().subtract(const Duration(days: 2)),
          ),
          User(
            id: '7',
            name: 'Lisa Garcia',
            avatarUrl: 'https://randomuser.me/api/portraits/women/55.jpg',
            isOnline: true,
            achievements: ['biology master'],
            commonGroups: ['Biology 101', 'Advanced Bio'],
            lastSeen: DateTime.now(),
          ),
          User(
            id: '8',
            name: 'John Doe',
            avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg',
            isOnline: false,
            achievements: [],
            commonGroups: ['Biology 101'],
            lastSeen: DateTime.now().subtract(const Duration(days: 1)),
          ),
          User(
            id: '9',
            name: 'Maria Rodriguez',
            avatarUrl: 'https://randomuser.me/api/portraits/women/16.jpg',
            isOnline: true,
            achievements: ['helpful peer'],
            commonGroups: ['Advanced Bio'],
            lastSeen: DateTime.now().subtract(const Duration(minutes: 45)),
          ),
        ],
        replies: 37,
        lastUpdate: DateTime.now().subtract(const Duration(minutes: 30)),
        createdBy: '7',
      ),
      QuestionThread(
        id: '4',
        subject: 'What if the apple didn\'t fall?',
        question: 'How does projectile motion change with increase in height?',
        participants: [
          User(
            id: '10',
            name: 'Robert Miller',
            avatarUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
            isOnline: true,
            achievements: ['physics expert'],
            commonGroups: ['Physics Club'],
            lastSeen: DateTime.now(),
          ),
        ],
        replies: 3,
        lastUpdate: DateTime.now().subtract(const Duration(days: 1)),
        createdBy: '10',
      ),
    ];
  }

  void addQuestionThread(QuestionThread thread) {
    _questionThreads.add(thread);
    notifyListeners();
  }

  void addReplyToThread(String threadId) {
    final threadIndex = _questionThreads.indexWhere((t) => t.id == threadId);
    if (threadIndex != -1) {
      _questionThreads[threadIndex] = _questionThreads[threadIndex].copyWith(
        replies: _questionThreads[threadIndex].replies + 1,
        lastUpdate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void addParticipantToThread(String threadId, User user) {
    final threadIndex = _questionThreads.indexWhere((t) => t.id == threadId);
    if (threadIndex != -1) {
      final updatedParticipants = List<User>.from(
        _questionThreads[threadIndex].participants,
      );
      if (!updatedParticipants.any((p) => p.id == user.id)) {
        updatedParticipants.add(user);
        _questionThreads[threadIndex] = _questionThreads[threadIndex].copyWith(
          participants: updatedParticipants,
        );
        notifyListeners();
      }
    }
  }
}
