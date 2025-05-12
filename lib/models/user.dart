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

  User copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isOnline,
    DateTime? lastSeen,
    List<String>? commonGroups,
    List<String>? achievements,
    String? avatarSvg,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      commonGroups: commonGroups ?? this.commonGroups,
      achievements: achievements ?? this.achievements,
      avatarSvg: avatarSvg ?? this.avatarSvg,
    );
  }
}
