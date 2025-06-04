import 'package:app_note/features/notes/widgets/notecard.dart';
import 'package:app_note/features/notes/widgets/notesummery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/note_controller.dart';
import '../models/note.dart';
import 'note_view.dart';

class HomeView extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());
  final RxString searchQuery = ''.obs;

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Obx(() => Text(
        noteController.isSelectionMode.value
            ? '${noteController.selectedNotes.length} selected'
            : 'My Notes',
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
  centerTitle: true,
  leading: Obx(() => noteController.isSelectionMode.value
      ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => noteController.clearSelection(),
        )
      : const SizedBox.shrink()),
  actions: [
    Obx(() {
      if (noteController.isSelectionMode.value) {
        return IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Get.defaultDialog(
              title: 'Delete Notes',
              middleText: 'Are you sure you want to delete selected notes?',
              confirm: TextButton(
                onPressed: () {
                  noteController.deleteSelectedNotes();
                  Get.back();
                },
                child: const Text("Yes"),
              ),
              cancel: TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
            );
          },
        );
      } else {
        return IconButton(
          icon: Icon(
            noteController.isGrid.value ? Icons.view_list : Icons.grid_view,
          ),
          onPressed: () {
            noteController.isGrid.toggle();
          },
        );
      }
    }),
  ],
),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddNoteView()),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        final query = searchQuery.value.toLowerCase();
        final List<Note> filteredNotes = noteController.notes.where((note) {
          return note.title.toLowerCase().contains(query) ||
              note.content.toLowerCase().contains(query);
        }).toList();

        final List<Note> pinnedNotes =
            filteredNotes.where((note) => note.isPinned).toList();
        final List<Note> otherNotes =
            filteredNotes.where((note) => !note.isPinned).toList();

        return ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            NoteSummaryCard(),
            const SizedBox(height: 16),

            // 🔍 Inline Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (value) => searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredNotes.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          "No notes found.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📌 Pinned Notes Section
                        if (pinnedNotes.isNotEmpty) ...[
                          const Text(
                            '📌 Pinned Notes',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          noteController.isGrid.value
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: pinnedNotes.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.85,
                                  ),
                                  itemBuilder: (context, index) {
                                    return NoteTile(note: pinnedNotes[index]);
                                  },
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: pinnedNotes.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    return NoteTile(note: pinnedNotes[index]);
                                  },
                                ),
                          const SizedBox(height: 24),
                        ],

                        // 🗂 Other Notes Section
                        if (otherNotes.isNotEmpty) ...[
                          const Text(
                            'All Notes',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          noteController.isGrid.value
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: otherNotes.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.85,
                                  ),
                                  itemBuilder: (context, index) {
                                    return NoteTile(note: otherNotes[index]);
                                  },
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: otherNotes.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    return NoteTile(note: otherNotes[index]);
                                  },
                                ),
                        ],
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }
}
