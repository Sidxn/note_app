import 'package:app_note/features/notes/models/note.dart';
import 'package:app_note/shared/theme/colorScheme.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
 final List<Note> notes;

  const AppHeader({super.key, required this.notes});
  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Notes Summary',
                  style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.white)),
              const SizedBox(height: 4),
              const Text('Total Notes',
                  style: TextStyle(color: AppColors.white)),
              Text('${notes.length}',
                  style: const TextStyle(
                      fontSize: 20,color: AppColors.white ,fontWeight: FontWeight.w600)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Last Note',
                  style: TextStyle(color: AppColors.white)),
              Text(
                notes.isNotEmpty
                    ? '${notes.last.createdAt.day}/${notes.last.createdAt.month}/${notes.last.createdAt.year}'
                    : '-',
                style: const TextStyle(
                    fontSize: 16, color: AppColors.white,fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
