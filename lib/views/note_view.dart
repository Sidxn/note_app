import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';

class AddNoteView extends StatelessWidget {
  final NoteController noteController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final Note? noteToEdit;

  AddNoteView({super.key, this.noteToEdit});

  @override
  Widget build(BuildContext context) {
    // Pre-fill if editing
    if (noteToEdit != null) {
      titleController.text = noteToEdit!.title;
      contentController.text = noteToEdit!.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          noteToEdit == null ? 'Add Note' : 'Edit Note',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: 'Start typing your note...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: () {
                if (noteToEdit == null) {
                  final note = Note(
                    id: const Uuid().v4(),
                    title: titleController.text,
                    content: contentController.text,
                    createdAt: DateTime.now(),
                  );
                  noteController.addNote(note);
                } else {
                  noteController.updateNote(
                    noteToEdit!.id,
                    titleController.text,
                    contentController.text,
                  );
                }
                Get.back();
              },
              child: Text(
                noteToEdit == null ? 'Save Note' : 'Update Note',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
