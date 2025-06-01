import 'package:flutter/material.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final bool isPinned;
  final DateTime createdAt;
  final Color color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isPinned = false,
    required this.createdAt,
    this.color = Colors.blue, // Default dot color
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      isPinned: json['isPinned'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      color: Color(json['color']), // assuming stored as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'color': color.value, // store as int
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    Color? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
    );
  }
}
