import 'package:get/get.dart';
import '../models/note.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;

// note_controller.dart
var isGrid = true.obs;
 var selectedNotes = <String>{}.obs;
  var isSelectionMode = false.obs;

void toggleViewMode() {
  isGrid.value = !isGrid.value;
}

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
  void toggleSelection(String noteId) {
    if (selectedNotes.contains(noteId)) {
      selectedNotes.remove(noteId);
    } else {
      selectedNotes.add(noteId);
    }

    isSelectionMode.value = selectedNotes.isNotEmpty;
  }

  void clearSelection() {
    selectedNotes.clear();
    isSelectionMode.value = false;
  }

  void deleteSelectedNotes() {
    notes.removeWhere((note) => selectedNotes.contains(note.id));
    clearSelection();
  }

  void deleteNote(String noteId) {
    notes.removeWhere((note) => note.id == noteId);
  }

  // Sort alphabetically (ascending)
void togglePin(String id) {
  final index = notes.indexWhere((note) => note.id == id);
  if (index != -1) {
    notes[index].isPinned = !notes[index].isPinned;
    notes.refresh(); // Notify listeners
  }
}

}
