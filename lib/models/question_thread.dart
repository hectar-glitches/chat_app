import 'user.dart';

class QuestionThread {
  final String id;
  final String subject;
  final String question;
  final List<User> participants;
  final int replies;
  final DateTime lastUpdate;
  final String createdBy;

  const QuestionThread({
    required this.id,
    required this.subject,
    required this.question,
    required this.participants,
    required this.replies,
    required this.lastUpdate,
    required this.createdBy,
  });

  QuestionThread copyWith({
    String? id,
    String? subject,
    String? question,
    List<User>? participants,
    int? replies,
    DateTime? lastUpdate,
    String? createdBy,
  }) {
    return QuestionThread(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      question: question ?? this.question,
      participants: participants ?? this.participants,
      replies: replies ?? this.replies,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
