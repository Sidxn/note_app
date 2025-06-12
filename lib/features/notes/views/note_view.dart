import 'dart:async';
import 'package:app_note/features/notes/widgets/customization_bar.dart';

import 'package:app_note/features/notes/widgets/note_content_field.dart';
import 'package:app_note/features/notes/widgets/note_title_field.dart.dart';
import 'package:app_note/shared/theme/colorScheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';
import '../models/text_model.dart';

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
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

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
      appBar: _buildAppBar(context, isSmallScreen),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomizationBar(
                fontSize: fontSize,
                isBold: isBold,
                isItalic: isItalic,
                textAlign: textAlign,
                onFontSizeChanged: (value) => setState(() => fontSize = value),
                onBoldToggled: () => setState(() => isBold = !isBold),
                onItalicToggled: () => setState(() => isItalic = !isItalic),
                onAlignChanged: (align) => setState(() => textAlign = align),
                onUndo: _handleUndo,
                onRedo: _handleRedo,
                noteController: noteController,
                pushUndo: _pushEditorStateToUndo,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NoteTitleField(controller: titleController),
                    const SizedBox(height: 12),
                    Expanded(
                      child: NoteContentField(
                        controller: contentController,
                        fontSize: fontSize,
                        isBold: isBold,
                        isItalic: isItalic,
                        textAlign: textAlign,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isSmallScreen) {
    final isEditing = widget.noteToEdit != null;
    final textColor = Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textDark;

    return AppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      title: Text(
        isEditing ? 'Edit Note' : 'New Note',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Urbanist',
          fontSize: isSmallScreen ? 18 : 20,
        ),
      ),
      actions: [
        if (!isEditing)
          IconButton(
            icon: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: isPinned ? AppColors.primaryBlue : AppColors.textGray,
            ),
            onPressed: () => setState(() => isPinned = !isPinned),
          ),
        if (isEditing)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: _deleteNote,
          ),
        IconButton(
          icon: Icon(Icons.check, color: AppColors.primaryBlue),
          onPressed: _saveNote,
        ),
      ],
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
      noteController.updateNote(
        note.id,
        note.title,
        note.content,
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
    final note = widget.noteToEdit;
    if (note != null) {
      noteController.deleteNoteById(note.id);
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
