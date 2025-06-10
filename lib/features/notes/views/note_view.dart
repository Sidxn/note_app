import 'dart:async'; // ADD THIS LINE
import 'package:app_note/features/notes/models/text_model.dart';
import 'package:app_note/shared/theme/colorScheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';

class AddNoteView extends StatefulWidget {
  final Note? noteToEdit;

  const AddNoteView({super.key, this.noteToEdit});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> with SingleTickerProviderStateMixin {
  final NoteController noteController = Get.find<NoteController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  double fontSize = 16;
  bool isBold = false;
  bool isItalic = false;
  TextAlign textAlign = TextAlign.start;
  bool isPinned = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Timer? _debounceTimer; // ADD THIS FIELD

  @override
  void initState() {
    super.initState();

    noteController.clearUndoRedo();

    if (widget.noteToEdit != null) {
      final note = widget.noteToEdit!;
      titleController.text = note.title;
      contentController.text = note.content;
      isPinned = note.isPinned;
      fontSize = note.fontSize;
      isBold = note.isBold;
      isItalic = note.isItalic;
      textAlign = _getTextAlignFromIndex(note.textAlignIndex);
    }

    _pushEditorStateToUndo();

    contentController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _pushEditorStateToUndo();
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // ADD THIS LINE
    contentController.dispose();
    titleController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.noteToEdit == null ? 'New Note' : 'Edit Note',
          style: const TextStyle(color: AppColors.primaryBlue),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        actions: [
          IconButton(
            icon: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: isPinned ? AppColors.primaryBlue : AppColors.textGray,
            ),
            onPressed: () {
              setState(() {
                isPinned = !isPinned;
              });
            },
          ),
          if (widget.noteToEdit != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _deleteNote,
            ),
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.primaryBlue),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildCustomizationBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontFamily: 'Urbanist',
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: AppColors.textGray,
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TextField(
                        controller: contentController,
                        maxLines: null,
                        expands: true,
                        textAlign: textAlign,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                          color: AppColors.textDark,
                          fontFamily: 'Urbanist',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Start typing...',
                          hintStyle: TextStyle(
                            color: AppColors.textGray,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }


  Widget _buildCustomizationBar() {
    double screenWidth = MediaQuery.of(context).size.width;

    double iconSize = screenWidth < 360
        ? 18
        : screenWidth < 400
            ? 20
            : 22;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildToolbarButton(
              icon: Icons.undo,
              enabled: noteController.undoStack.length > 1,
              onTap: () {
                TextEditorState? previous = noteController.undo();
                if (previous != null) {
                  setState(() {
                    contentController.text = previous.content;
                    contentController.selection = TextSelection.collapsed(offset: previous.content.length);
                    fontSize = previous.fontSize;
                    isBold = previous.isBold;
                    isItalic = previous.isItalic;
                    textAlign = previous.textAlign;
                  });
                }
              },
              iconSize: iconSize,
            ),
            _buildToolbarButton(
              icon: Icons.redo,
              enabled: noteController.redoStack.isNotEmpty,
              onTap: () {
                TextEditorState? next = noteController.redo();
                if (next != null) {
                  setState(() {
                    contentController.text = next.content;
                    contentController.selection = TextSelection.collapsed(offset: next.content.length);
                    fontSize = next.fontSize;
                    isBold = next.isBold;
                    isItalic = next.isItalic;
                    textAlign = next.textAlign;
                  });
                }
              },
              iconSize: iconSize,
            ),
            _buildToggleButton(Icons.format_bold, isBold, () {
              setState(() {
                isBold = !isBold;
                _pushEditorStateToUndo();
              });
            }, iconSize),
            _buildToggleButton(Icons.format_italic, isItalic, () {
              setState(() {
                isItalic = !isItalic;
                _pushEditorStateToUndo();
              });
            }, iconSize),
            _buildToggleButton(Icons.format_align_left, textAlign == TextAlign.start, () {
              setState(() {
                textAlign = TextAlign.start;
                _pushEditorStateToUndo();
              });
            }, iconSize),
            _buildToggleButton(Icons.format_align_center, textAlign == TextAlign.center, () {
              setState(() {
                textAlign = TextAlign.center;
                _pushEditorStateToUndo();
              });
            }, iconSize),
            _buildToggleButton(Icons.format_align_right, textAlign == TextAlign.end, () {
              setState(() {
                textAlign = TextAlign.end;
                _pushEditorStateToUndo();
              });
            }, iconSize),
            SizedBox(
              width: 50,
              child: DropdownButton<double>(
                value: fontSize,
                isDense: true,
                isExpanded: false,
                underline: const SizedBox(),
                dropdownColor: AppColors.white,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
                items: [14, 16, 18, 20, 22]
                    .map((size) => DropdownMenuItem(value: size.toDouble(), child: Text(size.toString())))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    fontSize = value!;
                    _pushEditorStateToUndo();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required double iconSize,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        color: enabled ? AppColors.primaryBlue : AppColors.textGray,
        size: iconSize,
      ),
      onPressed: enabled ? onTap : null,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildToggleButton(IconData icon, bool selected, VoidCallback onPressed, double iconSize) {
    return IconButton(
      icon: Icon(
        icon,
        color: selected ? AppColors.primaryBlue : AppColors.textGray,
        size: iconSize,
      ),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  void _saveNote() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Get.snackbar('Empty Note', 'Please enter a title or content.');
      return;
    }

    if (widget.noteToEdit == null) {
      final note = Note(
        id: const Uuid().v4(),
        title: title,
        content: content,
        createdAt: DateTime.now(),
        isPinned: isPinned,
        fontSize: fontSize,
        isBold: isBold,
        isItalic: isItalic,
        textAlignIndex: _getTextAlignIndex(textAlign),
      );
      noteController.addNote(note);
    } else {
  noteController.updateNote(
  widget.noteToEdit!.id,
  title,
  content,
  isPinned: isPinned,
  fontSize: fontSize,
  isBold: isBold,
  isItalic: isItalic,
  textAlignIndex: _getTextAlignIndex(textAlign),
);

    }

    Navigator.pop(context);
  }

  void _deleteNote() {
    if (widget.noteToEdit != null) {
      noteController.deleteNoteById(widget.noteToEdit!.id);
      Navigator.pop(context);
    }
  }

  int _getTextAlignIndex(TextAlign align) {
    switch (align) {
      case TextAlign.start:
        return 0;
      case TextAlign.center:
        return 1;
      case TextAlign.end:
        return 2;
      default:
        return 0;
    }
  }

  TextAlign _getTextAlignFromIndex(int index) {
    switch (index) {
      case 0:
        return TextAlign.start;
      case 1:
        return TextAlign.center;
      case 2:
        return TextAlign.end;
      default:
        return TextAlign.start;
    }
  }

  void _pushEditorStateToUndo() {
    noteController.pushToUndoStack(
      TextEditorState(
        content: contentController.text,
        fontSize: fontSize,
        isBold: isBold,
        isItalic: isItalic,
        textAlign: textAlign,
      ),
    );
  }
} 