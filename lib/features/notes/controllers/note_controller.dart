import 'package:app_note/features/notes/models/text_model.dart';
import 'package:app_note/features/notes/models/note.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;
  var isGrid = true.obs;

  var selectedNotes = <String>{}.obs;
  var isSelectionMode = false.obs;

  late final Box<Note> _noteBox;

Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
final RxBool isCalendarVisible = false.obs;

void toggleCalendarVisibility() {
  isCalendarVisible.value = !isCalendarVisible.value;
}

void selectDate(DateTime date) {
  selectedDate.value = date;
  isCalendarVisible.value = false; // auto-close
}


List<Note> get filteredNotesByDate {
  if (selectedDate.value == null) return notes;
  return notes.where((note) =>
      note.createdAt.year == selectedDate.value!.year &&
      note.createdAt.month == selectedDate.value!.month &&
      note.createdAt.day == selectedDate.value!.day).toList();
}

void clearDateFilter() {
  selectedDate.value = null;
}


  // ─── Undo / Redo Stack ────────────────────────────────────────────────────────
  var undoStack = <TextEditorState>[].obs;
  var redoStack = <TextEditorState>[].obs;
  bool _isApplyingUndoRedo = false;

  @override
  void onInit() {
    super.onInit();
    _noteBox = Hive.box<Note>('note');
    notes.value = _noteBox.values.toList();

    _noteBox.watch().listen((_) {
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

  /// UPDATED updateNote → now supports fontSize, isBold, isItalic, textAlignIndex
  Future<void> updateNote(
    String id,
    String title,
    String content, {
    required bool isPinned,
    required double fontSize,
    required bool isBold,
    required bool isItalic,
    required int textAlignIndex,
  }) async {
    Note? existing = _noteBox.get(id);
    if (existing != null) {
      Note updated = Note(
        id: id,
        title: title,
        content: content,
        createdAt: existing.createdAt,
        isPinned: isPinned,
        fontSize: fontSize,
        isBold: isBold,
        isItalic: isItalic,
        textAlignIndex: textAlignIndex,
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
        fontSize: note.fontSize,
        isBold: note.isBold,
        isItalic: note.isItalic,
        textAlignIndex: note.textAlignIndex,
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

  // ─── Undo / Redo Functions ────────────────────────────────────────────────────

  void pushToUndoStack(TextEditorState state) {
    if (_isApplyingUndoRedo) return;

    if (undoStack.isEmpty || !_areStatesEqual(undoStack.last, state)) {
      undoStack.add(state);
      redoStack.clear();
      // Optional: Limit stack size to 50
      if (undoStack.length > 50) {
        undoStack.removeAt(0);
      }
    }
  }

  TextEditorState? undo() {
    if (undoStack.length > 1) {
      _isApplyingUndoRedo = true;

      // Pop current state to redoStack
      TextEditorState last = undoStack.removeLast();
      redoStack.add(last);

      // Return previous state
      TextEditorState previous = undoStack.last;

      _isApplyingUndoRedo = false;
      return previous;
    }
    return null;
  }

  TextEditorState? redo() {
    if (redoStack.isNotEmpty) {
      _isApplyingUndoRedo = true;

      // Pop from redoStack
      TextEditorState next = redoStack.removeLast();
      undoStack.add(next);

      _isApplyingUndoRedo = false;
      return next;
    }
    return null;
  }

  void clearUndoRedo() {
    undoStack.clear();
    redoStack.clear();
  }

  bool _areStatesEqual(TextEditorState a, TextEditorState b) {
    return a.content == b.content &&
        a.fontSize == b.fontSize &&
        a.isBold == b.isBold &&
        a.isItalic == b.isItalic &&
        a.textAlign == b.textAlign;
  }
}
