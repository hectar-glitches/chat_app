class User {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final DateTime? lastSeen;
  final List<String> commonGroups;
  final List<String> achievements;
  final String? avatarSvg;

  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    this.lastSeen,
    this.commonGroups = const [],
    this.achievements = const [],
    this.avatarSvg,
  });
  }