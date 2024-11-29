import 'package:app_note/views/note_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';

class NotesSearchDelegate extends SearchDelegate {
  final NoteController noteController = Get.find();

  // Filter notes based on search query
  List<Note> _filterNotes(String query) {
    return noteController.notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // Clear search action
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredNotes = _filterNotes(query);

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.content),
          onTap: () {
            // Navigate to Edit Note View with the selected note
            Get.to(() => AddNoteView(noteToEdit: note));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredNotes = _filterNotes(query);

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.content),
          onTap: () {
            // Navigate to Edit Note View with the selected note
            Get.to(() => AddNoteView(noteToEdit: note));
          },
        );
      },
    );
  }
}
