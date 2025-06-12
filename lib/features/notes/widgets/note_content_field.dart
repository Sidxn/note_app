
import 'package:flutter/material.dart';
import '../../../shared/theme/colorScheme.dart';

class NoteContentField extends StatelessWidget {
  final TextEditingController controller;
  final double fontSize;
  final bool isBold;
  final bool isItalic;
  final TextAlign textAlign;

  const NoteContentField({
    super.key,
    required this.controller,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        
        
      
        
      ),
      child: TextField(
        
        controller: controller,
        maxLines: null,
        expands: true,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textDark,
          fontFamily: 'Urbanist',
        ),
        
        decoration: InputDecoration(
          
          hintText: 'Start typing...',
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textGray,
            fontSize: fontSize,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
