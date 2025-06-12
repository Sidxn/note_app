import 'package:app_note/features/notes/controllers/note_controller.dart';
import 'package:app_note/features/notes/models/note.dart';
import 'package:app_note/features/notes/views/note_view.dart';
import 'package:app_note/shared/theme/colorScheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotePreviewScreen extends StatelessWidget {
  final Note note;
  NotePreviewScreen({super.key, required this.note});

  final NoteController noteController = Get.find<NoteController>();

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy  •  h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
    
        title:  Text(
          'Preview',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textDark, fontWeight: FontWeight.bold, fontFamily: 'Urbanist'),
        ),
        centerTitle: false,
        actions: [
          // Pin Icon
          Obx(() {
            final currentNote = noteController.notes.firstWhereOrNull((n) => n.id == note.id);
            final isPinned = currentNote?.isPinned ?? false;
            return IconButton(
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: isPinned ? AppColors.primaryBlue : AppColors.textGray,
              ),
              onPressed: () {
                if (currentNote != null) {
                  noteController.togglePin(currentNote.id);
                }
              },
            );
          }),
          // Edit Icon
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primaryBlue),
           onPressed: () async {
  final updatedNote = noteController.notes.firstWhereOrNull((n) => n.id == note.id);
  if (updatedNote != null) {
    final result = await Get.to(() => AddNoteView(noteToEdit: updatedNote));

    // If the result is 'deleted', go back to home screen
    if (result == 'deleted') {
      Get.back(); // Go back from preview screen
    }
  }
},

          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() {
            final noteIndex = noteController.notes.indexWhere((n) => n.id == note.id);
            if (noteIndex == -1) {
              return const Center(child: Text('Note not found.'));
            }

            final updatedNote = noteController.notes[noteIndex];

            final TextStyle contentStyle = TextStyle(
              fontSize: updatedNote.fontSize,
              fontWeight: updatedNote.isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: updatedNote.isItalic ? FontStyle.italic : FontStyle.normal,
            );

            final TextAlign textAlign = [
              TextAlign.left,
              TextAlign.center,
              TextAlign.right,
              TextAlign.justify,
            ][updatedNote.textAlignIndex.clamp(0, 3)];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        updatedNote.title.isNotEmpty ? updatedNote.title : 'Untitled',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Date
                      Text(
                        _formatDate(updatedNote.createdAt),
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 0.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Content box
                      Expanded(
                        child: Container(
                          width: double.infinity,
                
                     
                          child: Text(
                            updatedNote.content,
                            textAlign: textAlign,
                            style: contentStyle.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
