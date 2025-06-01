
import 'package:app_note/features/notes/controllers/note_controller.dart' show NoteController;
import 'package:app_note/features/notes/views/note_view.dart';
import 'package:app_note/features/notes/widgets/appheader.dart';
import 'package:app_note/features/notes/widgets/notecard.dart';
import 'package:app_note/features/notes/widgets/searchbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddNoteView()),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const AppHeader(),
              const SizedBox(height: 20),
              const CustomSearchBar(),
              const SizedBox(height: 20),

              // Notes Grid
              Expanded(
                child: Obx(() {
                  final notes = noteController.notes;

                  if (notes.isEmpty) {
                    return const Center(child: Text("No notes found."));
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return NoteCard(note: note);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
