import 'package:app_note/features/notes/controllers/note_controller.dart';
import 'package:app_note/features/notes/models/note.dart';
import 'package:app_note/features/notes/views/note_view.dart';
import 'package:app_note/features/notes/views/preview_screen_view.dart';
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
                  : const Text(
                      'My Notes',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist'),
                    ),
              centerTitle: false,
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
                        icon: Icon(
                          noteController.isGrid.value
                              ? Icons.grid_view_rounded
                              : Icons.view_agenda,
                          color: AppColors.primaryBlue,
                        ),
                        onPressed: noteController.toggleViewMode,
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: AppColors.primaryBlue),
                        onPressed: noteController.toggleCalendarVisibility,
                      ),
                      Obx(() {
                        return noteController.selectedDate.value != null
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppColors.primaryBlue),
                                tooltip: 'Show all notes',
                                onPressed: noteController.clearDateFilter,
                              )
                            : const SizedBox.shrink();
                      }),
                    ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddNoteView());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          List<Note> notes = noteController.filteredNotesByDate;

          notes = notes.where((note) {
            final query = searchQuery.value.toLowerCase();
            return note.title.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query);
          }).toList();

          notes.sort((a, b) {
            if (a.isPinned && !b.isPinned) return -1;
            if (!a.isPinned && b.isPinned) return 1;
            return b.createdAt.compareTo(a.createdAt);
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

              // Inline Calendar with animation
              Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: noteController.isCalendarVisible.value
                        ? Column(
                            key: const ValueKey("calendar"),
                            children: [
                              CalendarDatePicker(
                                initialDate:
                                    noteController.selectedDate.value ??
                                        DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                onDateChanged: noteController.selectDate,
                              ),
                              const SizedBox(height: 8),
                            ],
                          )
                        : const SizedBox.shrink(key: ValueKey("nocalendar")),
                  )),

              AppHeader(notes: notes),
              const SizedBox(height: 16),

              // Animated View Switcher for Notes List/Grid
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey(noteController.isGrid.value),
                    child: _buildNotesList(notes),
                  ),
                ),
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
              key: const PageStorageKey('grid'),
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
                      Get.to(() => NotePreviewScreen(note: note));
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
              key: const PageStorageKey('list'),
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
                      Get.to(() => NotePreviewScreen(note: note));
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
