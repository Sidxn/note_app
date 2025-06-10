import 'package:hive/hive.dart';
part 'note.g.dart';


@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isPinned;

  @HiveField(5)
  double fontSize;

  @HiveField(6)
  bool isBold;

  @HiveField(7)
  bool isItalic;

  @HiveField(8)
  int textAlignIndex;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
    this.fontSize = 16,
    this.isBold = false,
    this.isItalic = false,
    this.textAlignIndex = 0,
  });
  Note copyWith({
  String? id,
  String? title,
  String? content,
  DateTime? createdAt,
  bool? isPinned,
  double? fontSize,
  bool? isBold,
  bool? isItalic,
  int? textAlignIndex,
}) {
  return Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    isPinned: isPinned ?? this.isPinned,
    fontSize: fontSize ?? this.fontSize,
    isBold: isBold ?? this.isBold,
    isItalic: isItalic ?? this.isItalic,
    textAlignIndex: textAlignIndex ?? this.textAlignIndex,
  );
}

}
