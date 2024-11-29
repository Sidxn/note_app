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

  // Constructor to optionally pass an existing note
  AddNoteView({Key? key, this.noteToEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pre-fill controllers with existing note data if editing
    if (noteToEdit != null) {
      titleController.text = noteToEdit!.title;
      contentController.text = noteToEdit!.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(noteToEdit == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (noteToEdit == null) {
                  // Add new note
                  final note = Note(
                    id: Uuid().v4(),
                    title: titleController.text,
                    content: contentController.text,
                    createdAt: DateTime.now(),
                  );
                  noteController.addNote(note);
                } else {
                  // Edit existing note
                  noteController.updateNote(
                    noteToEdit!.id,
                    titleController.text,
                    contentController.text,
                  );
                }
                Get.back();
              },
              child: Text(noteToEdit == null ? 'Save Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
