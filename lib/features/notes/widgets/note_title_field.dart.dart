import 'package:flutter/material.dart';
import '../../../shared/theme/colorScheme.dart';

class NoteTitleField extends StatelessWidget {
  final TextEditingController controller;
  const NoteTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        
        
      
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: isSmallScreen ? 22 : 26,
          fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textDark,
          fontFamily: 'Urbanist',
        ),
        decoration: InputDecoration(
          hintText: 'Title',
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textGray,
            fontWeight: FontWeight.w600,
            fontSize: isSmallScreen ? 22 : 26,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
