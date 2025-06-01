
import 'package:app_note/views/note_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';

class NotesSearchDelegate extends SearchDelegate {
  final NoteController noteController = Get.find();

  List<Note> _filterNotes(String query) {
    return noteController.notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildNoteResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildNoteResults();
  }

  Widget _buildNoteResults() {
    final filteredNotes = _filterNotes(query);

    if (filteredNotes.isEmpty) {
      return const Center(child: Text('No notes found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final note = filteredNotes[index];

        return InkWell(
          onTap: () => Get.to(() => AddNoteView(noteToEdit: note)),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
