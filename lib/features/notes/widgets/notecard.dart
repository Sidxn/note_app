import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';
import '../views/note_view.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final NoteController noteController = Get.find();

  NoteTile({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = noteController.selectedNotes.contains(note.id);

      return InkWell(
        onTap: () {
          if (noteController.isSelectionMode.value) {
            noteController.toggleSelection(note.id);
          } else {
            Get.to(() => AddNoteView(noteToEdit: note));
          }
        },
        onLongPress: () => noteController.toggleSelection(note.id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
     color: isSelected
    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
    : Theme.of(context).colorScheme.surface,

            borderRadius: BorderRadius.circular(16),
  border: Border.all(
  color: isSelected
      ? Theme.of(context).colorScheme.primary
      : Colors.transparent,
  width: 2,
),

          ),
          child: Stack(
            children: [
              // Selection Check Icon
              if (noteController.isSelectionMode.value)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                 color: isSelected
    ? Theme.of(context).colorScheme.primary
    : Theme.of(context).colorScheme.surface,

                    size: 20,
                  ),
                ),

              // Pin Icon
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(
                    note.isPinned
                        ? Icons.push_pin
                        : Icons.push_pin_outlined,
                    color: note.isPinned ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () => noteController.togglePin(note.id),
                ),
              ),

              // Main Content
              Padding(
                padding: const EdgeInsets.only(top: 28.0), // leave room for top icons
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      note.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
