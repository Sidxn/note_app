import 'package:app_note/views/note_view.dart';
import 'package:app_note/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';

class HomeView extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  // Variable to hold the current view type (ListView or GridView)
  var isGridView = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          // View toggle button
          Obx(
            () => IconButton(
              icon: Icon(
                isGridView.value ? Icons.view_list : Icons.grid_view,
              ),
              onPressed: () {
                // Toggle between grid and list view
                isGridView.value = !isGridView.value;
              },
            ),
          ),
          // Search Icon Button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Show search bar when clicked
              showSearch(context: context, delegate: NotesSearchDelegate());
            },
          ),
          // Sorting Dropdown
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle sorting based on the selected value
              switch (value) {
                case 'Alphabetical Ascending':
                  noteController.sortByTitleAsc();
                  break;
                case 'Alphabetical Descending':
                  noteController.sortByTitleDesc();
                  break;
                case 'Date Ascending':
                  noteController.sortByDateAsc();
                  break;
                case 'Date Descending':
                  noteController.sortByDateDesc();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Alphabetical Ascending',
                child: Text('Alphabetical Ascending'),
              ),
              PopupMenuItem(
                value: 'Alphabetical Descending',
                child: Text('Alphabetical Descending'),
              ),
              PopupMenuItem(
                value: 'Date Ascending',
                child: Text('Date Ascending'),
              ),
              PopupMenuItem(
                value: 'Date Descending',
                child: Text('Date Descending'),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        // Determine which view to display based on isGridView
        return isGridView.value
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      2, // You can adjust this number based on screen size
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: noteController.notes.length,
                itemBuilder: (context, index) {
                  final note = noteController.notes[index];
                  return Card(
                    elevation: 4.0,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => AddNoteView(noteToEdit: note));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(note.content),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                note.isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                                color: note.isPinned ? Colors.yellow : null,
                              ),
                              onPressed: () {
                                noteController.togglePin(note.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : ListView.builder(
                itemCount: noteController.notes.length,
                itemBuilder: (context, index) {
                  final note = noteController.notes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                    trailing: IconButton(
                      icon: Icon(
                        note.isPinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        color: note.isPinned ? Colors.yellow : null,
                      ),
                      onPressed: () {
                        noteController.togglePin(note.id);
                      },
                    ),
                    onTap: () {
                      Get.to(() => AddNoteView(noteToEdit: note));
                    },
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddNoteView());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
