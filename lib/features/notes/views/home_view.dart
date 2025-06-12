import 'package:app_note/features/notes/controllers/note_controller.dart';
import 'package:app_note/features/notes/controllers/theme_controller.dart';
import 'package:app_note/features/notes/models/note.dart';
import 'package:app_note/features/notes/views/note_view.dart';
import 'package:app_note/features/notes/views/preview_screen_view.dart';
import 'package:app_note/features/notes/widgets/appheader.dart';
import 'package:app_note/features/notes/widgets/notecard.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesHomePage extends StatelessWidget {
  NotesHomePage({super.key});

  final NoteController noteController = Get.put(NoteController());
  final ThemeController themeController = Get.find();
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => AppBar(
              backgroundColor: noteController.isSelectionMode.value
                  ? Theme.of(context).colorScheme.surface.withOpacity(0.95)
                  : Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
              leading: noteController.isSelectionMode.value
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: noteController.clearSelection,
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                  : null,
              title: Text(
                noteController.isSelectionMode.value
                    ? '${noteController.selectedNotes.length} selected'
                    : 'My Notes',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
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
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await noteController.deleteSelectedNotes();
                        },
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ]
                  : [
                      IconButton(
                        icon: Icon(
                          noteController.isGrid.value
                              ? Icons.grid_view_rounded
                              : Icons.view_agenda,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: noteController.toggleViewMode,
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: noteController.toggleCalendarVisibility,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      Obx(() {
                        return noteController.selectedDate.value != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: 'Show all notes',
                                onPressed: noteController.clearDateFilter,
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                            : const SizedBox.shrink();
                      }),
                      IconButton(
                        icon: Icon(
                          themeController.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        tooltip: themeController.isDarkMode
                            ? 'Switch to Light Mode'
                            : 'Switch to Dark Mode',
                        onPressed: () => themeController.toggleTheme(),
                      ),
                    ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddNoteView());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
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
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,
                ),
                onChanged: (value) => searchQuery.value = value,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: noteController.isCalendarVisible.value
                        ? Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Theme(
  data: Theme.of(context).copyWith(
    colorScheme: Theme.of(context).colorScheme.copyWith(
      primary: Theme.of(context).colorScheme.primary, // today’s date circle color
      onPrimary:  Theme.of(context).textTheme.bodyLarge!.color    , // today’s date text color when selected
      onSurface: Theme.of(context).colorScheme.onSurface, // default text color
    ),
  ),
  child: CalendarDatePicker(
    initialDate: noteController.selectedDate.value ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    onDateChanged: noteController.selectDate,
  ),
),
                              ),
                              const SizedBox(height: 8),
                            ],
                          )
                        : const SizedBox.shrink(),
                  )),
              AppHeader(notes: notes),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final scale = Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    );
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: scale, child: child),
                    );
                  },
                  child: Container(
                    key: ValueKey(noteController.isGrid.value),
                    child: _buildNotesList(notes, context),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNotesList(List<Note> notes, BuildContext context) {
    final isSelectionMode = noteController.isSelectionMode.value;
    final isGrid = noteController.isGrid.value;

    return isGrid
        ? GridView.builder(
            itemCount: notes.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                note: note,
                onPinToggle: () => noteController.togglePin(note.id),
                onTap: () {
                  isSelectionMode
                      ? noteController.toggleNoteSelection(note.id)
                      : Get.to(() => NotePreviewScreen(note: note));
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
              final note = notes[index];
              return NoteCard(
                note: note,
                onPinToggle: () => noteController.togglePin(note.id),
                onTap: () {
                  isSelectionMode
                      ? noteController.toggleNoteSelection(note.id)
                      : Get.to(() => NotePreviewScreen(note: note));
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
  }
}
