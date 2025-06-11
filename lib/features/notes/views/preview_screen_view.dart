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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Preview',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primaryBlue),
            onPressed: () {
              Get.to(() => AddNoteView(noteToEdit: note));
            },
          ),
        ],
      ),
      body: Obx(() {
        // Get the latest version of the note from controller:
        Note? currentNote = noteController.notes.firstWhereOrNull((n) => n.id == note.id);

        if (currentNote == null) {
          return const Center(child: Text('Note not found.'));
        }

        TextStyle contentStyle = TextStyle(
          fontSize: currentNote.fontSize,
          fontWeight: currentNote.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: currentNote.isItalic ? FontStyle.italic : FontStyle.normal,
        );

        TextAlign textAlign;
        switch (currentNote.textAlignIndex) {
          case 0:
            textAlign = TextAlign.left;
            break;
          case 1:
            textAlign = TextAlign.center;
            break;
          case 2:
            textAlign = TextAlign.right;
            break;
          case 3:
            textAlign = TextAlign.justify;
            break;
          default:
            textAlign = TextAlign.left;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  currentNote.title.isNotEmpty ? currentNote.title : 'Untitled',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                // Date
                Text(
                  _formatDate(currentNote.createdAt),
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.5,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                // Content box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    currentNote.content,
                    textAlign: textAlign,
                    style: contentStyle.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      height: 1.7,
                      fontSize: currentNote.fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
