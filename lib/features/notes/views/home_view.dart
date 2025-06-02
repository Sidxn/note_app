import 'package:app_note/features/notes/views/note_view.dart';
import 'package:app_note/features/notes/views/search_view.dart';
import 'package:app_note/features/notes/widgets/notecard.dart';
import 'package:app_note/features/notes/widgets/notesummery.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';

class HomeView extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NotesSearchDelegate());
            },
          ),
          Obx(() {
            return IconButton(
              icon: Icon(
                noteController.isGridView.value ? Icons.view_list : Icons.grid_view,
              ),
              onPressed: () {
                noteController.toggleViewMode();
              },
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddNoteView()),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        final notes = noteController.notes;

        return ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
             NoteSummaryCard(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: notes.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          'No notes yet. Tap the + button to add one!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : noteController.isGridView.value
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notes.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) {
                            return NoteTile(note: notes[index]);
                          },
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return NoteTile(note: notes[index]);
                          },
                        ),
            ),
          ],
        );
      }),
    );
  }
}
