class User {
  final String id;
  final String name;
  final String fluttermojiString;
  final DateTime? lastSeen;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.fluttermojiString,
    this.lastSeen,
    this.isOnline = false,
  });
}
