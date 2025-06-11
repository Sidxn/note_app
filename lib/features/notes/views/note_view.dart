import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../controllers/note_controller.dart';
import '../models/note.dart';
import '../models/text_model.dart';
import 'package:app_note/shared/theme/colorScheme.dart';

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

  Timer? _debounceTimer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), _pushEditorStateToUndo);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    titleController.dispose();
    contentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textDark),
        title: Text(
          widget.noteToEdit == null ? 'New Note' : 'Edit Note',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontFamily: 'Urbanist',
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        actions: [
          if (widget.noteToEdit == null)
            IconButton(
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: isPinned ? AppColors.primaryBlue : Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textGray,
              ),
              onPressed: () => setState(() => isPinned = !isPinned),
            ),
          if (widget.noteToEdit != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _deleteNote,
            ),
          IconButton(
            icon: Icon(Icons.check, color: AppColors.primaryBlue),
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
                      style: TextStyle(
                        fontSize: isSmallScreen ? 22 : 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontFamily: 'Urbanist',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textGray,
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 22 : 26,
                        ),
                        border: InputBorder.none,
                        focusColor: AppColors.scaffoldDark,
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
                        decoration: InputDecoration(
                          hintText: 'Start typing...',
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textGray,
                            fontSize: fontSize,
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

  // Only the relevant updates are shown for brevity and clarity.

Widget _buildCustomizationBar() {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    height: 50,
    decoration: BoxDecoration(
      color: isDark ? AppColors.darkSurface : AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBarIcon(Icons.undo, enabled: noteController.undoStack.length > 1, onPressed: _handleUndo),
        _buildBarIcon(Icons.redo, enabled: noteController.redoStack.isNotEmpty, onPressed: _handleRedo),
        _buildBarIcon(Icons.format_bold, selected: isBold, onPressed: () {
          setState(() => isBold = !isBold);
          _pushEditorStateToUndo();
        }),
        _buildBarIcon(Icons.format_italic, selected: isItalic, onPressed: () {
          setState(() => isItalic = !isItalic);
          _pushEditorStateToUndo();
        }),
        DropdownButtonHideUnderline(
          child: DropdownButton<double>(
            value: fontSize,
            icon: const Icon(Icons.arrow_drop_down, size: 0),
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              color: AppColors.textDark,
            ),
            dropdownColor: isDark ? AppColors.surfaceDark : AppColors.white,
            isDense: true,
            items: [14, 16, 18, 20, 22]
                .map((size) => DropdownMenuItem(
                      value: size.toDouble(),
                      child: Text(
                        size.toString(),
                        style: TextStyle(color: AppColors.textDark),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => fontSize = value);
                _pushEditorStateToUndo();
              }
            },
          ),
        ),
        _buildBarIcon(Icons.format_align_left, selected: textAlign == TextAlign.start, onPressed: () {
          setState(() => textAlign = TextAlign.start);
          _pushEditorStateToUndo();
        }),
        _buildBarIcon(Icons.format_align_center, selected: textAlign == TextAlign.center, onPressed: () {
          setState(() => textAlign = TextAlign.center);
          _pushEditorStateToUndo();
        }),
        _buildBarIcon(Icons.format_align_right, selected: textAlign == TextAlign.end, onPressed: () {
          setState(() => textAlign = TextAlign.end);
          _pushEditorStateToUndo();
        }),
      ],
    ),
  );
}


Widget _buildBarIcon(IconData icon,
    {bool selected = false, bool enabled = true, required VoidCallback onPressed}) {
  return IconButton(
    icon: Icon(
      icon,
      size: 22,
      color: enabled
          ? (selected ? AppColors.primaryBlue : AppColors.textDark)
          : AppColors.textGray.withOpacity(0.3),
    ),
    onPressed: enabled ? onPressed : null,
  );
}


  void _handleUndo() {
    final previous = noteController.undo();
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
  }

  void _handleRedo() {
    final next = noteController.redo();
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
  }

  void _saveNote() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Get.snackbar('Empty Note', 'Please enter a title or content.');
      return;
    }

    final note = Note(
      id: widget.noteToEdit?.id ?? const Uuid().v4(),
      title: title,
      content: content,
      createdAt: widget.noteToEdit?.createdAt ?? DateTime.now(),
      isPinned: isPinned,
      fontSize: fontSize,
      isBold: isBold,
      isItalic: isItalic,
      textAlignIndex: _getTextAlignIndex(textAlign),
    );

    if (widget.noteToEdit == null) {
      noteController.addNote(note);
    } else {
      noteController.updateNote(note.id, note.title, note.content,
        isPinned: note.isPinned,
        fontSize: note.fontSize,
        isBold: note.isBold,
        isItalic: note.isItalic,
        textAlignIndex: note.textAlignIndex,
      );
    }

    Get.back();
  }

  void _deleteNote() {
    if (widget.noteToEdit != null) {
      noteController.deleteNoteById(widget.noteToEdit!.id);
      Get.back(result: 'deleted');
    }
  }

  int _getTextAlignIndex(TextAlign align) => switch (align) {
    TextAlign.start => 0,
    TextAlign.center => 1,
    TextAlign.end => 2,
    _ => 0,
  };

  TextAlign _getTextAlignFromIndex(int index) => switch (index) {
    0 => TextAlign.start,
    1 => TextAlign.center,
    2 => TextAlign.end,
    _ => TextAlign.start,
  };

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
