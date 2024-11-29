class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
  });
}
