import 'package:app_note/features/notes/controllers/note_controller.dart';
import 'package:app_note/features/notes/models/note.dart';
import 'package:app_note/features/notes/views/note_view.dart';
import 'package:app_note/features/notes/widgets/appheader.dart';
import 'package:app_note/shared/theme/colorScheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/notecard.dart';

class NotesHomePage extends StatelessWidget {
  NotesHomePage({super.key});

  final NoteController noteController = Get.put(NoteController());
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Obx(() => AppBar(
          leading: noteController.isSelectionMode.value
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: noteController.clearSelection,
                )
              : null,
          title: noteController.isSelectionMode.value
              ? Text('${noteController.selectedNotes.length} selected')
              : const Text('My Notes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  )), 
          actions: noteController.isSelectionMode.value
              ? [
                  IconButton(
                    icon: const Icon(Icons.select_all),
                    onPressed: () {
                      if (noteController.selectedNotes.length ==
                          noteController.notes.length) {
                        noteController.deselectAll();
                      } else {
                        noteController.selectAll();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await noteController.deleteSelectedNotes();
                    },
                  ),
                ]
              : [
                  IconButton(
                    icon: Icon(noteController.isGrid.value
                        ? Icons.grid_view_rounded
                        : Icons.view_agenda),
                    onPressed: noteController.toggleViewMode,
                  )
                ],
        )),
  ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Note page
          Get.to(() => AddNoteView()); // Replace with your note editor page
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body:  Padding(
  padding: const EdgeInsets.all(16),
  child: Obx(() {
    List<Note> allNotes = noteController.getAllNotes();

    // Filter by search query
    List<Note> filteredNotes = allNotes.where((note) {
      final query = searchQuery.value.toLowerCase();
      return note.title.toLowerCase().contains(query) ||
             note.content.toLowerCase().contains(query);
    }).toList();

    // Sort so pinned notes come first
    filteredNotes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;  // a before b
      if (!a.isPinned && b.isPinned) return 1;   // b before a
      return b.createdAt.compareTo(a.createdAt); // Newer first if same pin status
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search notes...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).cardColor,
            filled: true,
          ),
          onChanged: (value) => searchQuery.value = value,
        ),
        const SizedBox(height: 16),
        AppHeader( notes:filteredNotes,),
        const SizedBox(height: 16),
        Expanded(
          child: _buildNotesList(filteredNotes),
        ),
      ],
    );
  }),
),


    );
  }


Widget _buildNotesList(List<Note> notes) {
  return Obx(() {
    final bool isSelectionMode = noteController.isSelectionMode.value;

    return noteController.isGrid.value
        ? GridView.builder(
            itemCount: notes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              final Note note = notes[index];
              return NoteCard(
                note: note,
                onPinToggle: () => noteController.togglePin(note.id),
                onTap: () {
                  if (isSelectionMode) {
                    noteController.toggleNoteSelection(note.id);
                  } else {
                    // Open note (if you want, navigate to detail page)
                    // Get.to(() => NoteView(note: note));
                  }
                },
                onLongPress: () {
                  if (!isSelectionMode) {
                    noteController.enterSelectionMode(note.id);
                  } else {
                    noteController.toggleNoteSelection(note.id);
                  }
                },
              );
            },
          )
        : ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final Note note = notes[index];
              return NoteCard(
                note: note,
                onPinToggle: () => noteController.togglePin(note.id),
                onTap: () {
                  if (isSelectionMode) {
                    noteController.toggleNoteSelection(note.id);
                  } else {
                    // Open note
                    // Get.to(() => NoteView(note: note));
                  }
                },
                onLongPress: () {
                  if (!isSelectionMode) {
                    noteController.enterSelectionMode(note.id);
                  } else {
                    noteController.toggleNoteSelection(note.id);
                  }
                },
              );
            },
          );
  });
}


}
