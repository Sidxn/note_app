import 'package:get/get.dart';
import '../models/note.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;

  void addNote(Note note) {
    notes.add(note);
  }

  void deleteNoteById(String id) {
    notes.removeWhere((note) => note.id == id);
  }

  void updateNote(String id, String title, String content) {
    int index = notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      notes[index] = Note(
        id: id,
        title: title,
        content: content,
        createdAt: notes[index].createdAt,
      );
    }
  }

  void togglePin(String id) {
    final index = notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      notes[index].isPinned = !notes[index].isPinned;
      notes.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return 0;
      });
    }
  }

  // Sort alphabetically (ascending)
  void sortByTitleAsc() {
    notes.sort((a, b) => a.title.compareTo(b.title));
  }

  // Sort alphabetically (descending)
  void sortByTitleDesc() {
    notes.sort((a, b) => b.title.compareTo(a.title));
  }

  // Sort by created date (ascending)
  void sortByDateAsc() {
    notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  // Sort by created date (descending)
  void sortByDateDesc() {
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
