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
    return InkWell(
      onTap: () => Get.to(() => AddNoteView(noteToEdit: note)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: -8,
              child: IconButton(
                icon: Icon(
                  note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: note.isPinned ? Colors.orange : Colors.grey,
                ),
                onPressed: () => noteController.togglePin(note.id),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          ],
        ),
      ),
    );
  }
}
