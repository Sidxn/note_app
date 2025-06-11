import 'package:app_note/features/notes/models/note.dart';
import 'package:app_note/shared/theme/colorScheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onPinToggle;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
    required this.onPinToggle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteController>();

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Obx(() {
        final bool isSelected = controller.selectedNotes.contains(note.id);

        return Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue.withOpacity(0.1)
                : AppColors.lightCard,
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with title (and check if selected) + pin icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.primaryBlue,
                              size: 24,
                            ),
                          ),
                        if (note.title.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              note.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onPinToggle,
                    child: Icon(
                      note.isPinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      size: 20,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (note.content.isNotEmpty)
                Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w400,
                      ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        );
      }),
    );
  }
}
