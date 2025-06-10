// text_model.dart

import 'package:flutter/material.dart';

class TextEditorState {
  final String content;
  final double fontSize;
  final bool isBold;
  final bool isItalic;
  final TextAlign textAlign;

  TextEditorState({
    required this.content,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.textAlign,
  });

  bool equals(TextEditorState other) {
    return content == other.content &&
           fontSize == other.fontSize &&
           isBold == other.isBold &&
           isItalic == other.isItalic &&
           textAlign == other.textAlign;
  }
}
