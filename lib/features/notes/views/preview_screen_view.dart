import 'package:app_note/features/notes/models/note.dart';
import 'package:app_note/features/notes/views/note_view.dart';
import 'package:app_note/shared/theme/colorScheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotePreviewScreen extends StatelessWidget {
  final Note note;

  const NotePreviewScreen({super.key, required this.note});

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy • h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle contentStyle = TextStyle(
      fontSize: note.fontSize,
      fontWeight: note.isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: note.isItalic ? FontStyle.italic : FontStyle.normal,
    );

    TextAlign textAlign;
    switch (note.textAlignIndex) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primaryBlue),
            onPressed: () {
              Get.to(() => AddNoteView(noteToEdit: note));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                note.title.isNotEmpty ? note.title : 'Untitled',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              // Date
              Text(
                _formatDate(note.createdAt),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              // Content
              Text(
                note.content,
                textAlign: textAlign,
                style: contentStyle.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  height: 1.6, // nice line height
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
