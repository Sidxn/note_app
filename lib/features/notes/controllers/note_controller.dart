import 'package:app_note/features/notes/models/note.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;
  var isGrid = true.obs;

  var selectedNotes = <String>{}.obs;
  var isSelectionMode = false.obs;

  late final Box<Note> _noteBox;

  @override
  void onInit() {
    super.onInit();
    _noteBox = Hive.box<Note>('notes');
    notes.value = _noteBox.values.toList();

    _noteBox.watch().listen((_) {
      // Automatically refresh notes on any change
      notes.value = _noteBox.values.toList();
    });
  }

  void loadNotesFromBox() {
    notes.assignAll(_noteBox.values.toList());
  }

  List<Note> getAllNotes() => notes.toList();

  List<Note> getPinnedNotes() =>
      notes.where((note) => note.isPinned == true).toList();

  List<Note> getUnpinnedNotes() =>
      notes.where((note) => note.isPinned != true).toList();

  void toggleViewMode() {
    isGrid.value = !isGrid.value;
  }

  Future<void> addNote(Note note) async {
    await _noteBox.put(note.id, note);
    notes.value = _noteBox.values.toList();
  }

  Future<void> deleteNoteById(String id) async {
    await _noteBox.delete(id);
    notes.value = _noteBox.values.toList();
  }

  Future<void> deleteSelectedNotes() async {
    for (String id in selectedNotes) {
      await _noteBox.delete(id);
    }
    clearSelection();
    notes.value = _noteBox.values.toList();
  }

  Future<void> updateNote(String id, String title, String content, {required bool isPinned}) async {
    Note? existing = _noteBox.get(id);
    if (existing != null) {
      Note updated = Note(
        id: id,
        title: title,
        content: content,
        createdAt: existing.createdAt,
        isPinned: isPinned,
      );
      await _noteBox.put(id, updated);
      notes.value = _noteBox.values.toList();
    }
  }

  Future<void> togglePin(String id) async {
    Note? note = _noteBox.get(id);
    if (note != null) {
      Note updated = Note(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        isPinned: !note.isPinned,
      );
      await _noteBox.put(id, updated);
      notes.value = _noteBox.values.toList();
    }
  }

  // ─── Selection Mode ──────────────────────────────────────────────────────────

  void enterSelectionMode(String id) {
    isSelectionMode.value = true;
    selectedNotes.add(id);
  }

  void toggleNoteSelection(String id) {
    if (selectedNotes.contains(id)) {
      selectedNotes.remove(id);
      if (selectedNotes.isEmpty) {
        isSelectionMode.value = false;
      }
    } else {
      selectedNotes.add(id);
    }
  }

  void clearSelection() {
    selectedNotes.clear();
    isSelectionMode.value = false;
  }

  void selectAll() {
    selectedNotes.addAll(notes.map((note) => note.id));
  }

  void deselectAll() {
    selectedNotes.clear();
    isSelectionMode.value = false;
  }
}
