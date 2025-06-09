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
  final NoteController noteController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  double fontSize = 16;
  bool isBold = false;
  bool isItalic = false;
  TextAlign textAlign = TextAlign.start;
  bool isPinned = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.noteToEdit != null) {
      titleController.text = widget.noteToEdit!.title;
      contentController.text = widget.noteToEdit!.content;
      isPinned = widget.noteToEdit!.isPinned ?? false;
    }

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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.noteToEdit == null ? 'New Note' : 'Edit Note',style: TextStyle(
          color: AppColors.primaryBlue 
        ),),
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
     
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildToggleButton(Icons.format_bold, isBold, () => setState(() => isBold = !isBold)),
          _buildToggleButton(Icons.format_italic, isItalic, () => setState(() => isItalic = !isItalic)),
          _buildToggleButton(Icons.format_align_left, textAlign == TextAlign.start, () => setState(() => textAlign = TextAlign.start)),
          _buildToggleButton(Icons.format_align_center, textAlign == TextAlign.center, () => setState(() => textAlign = TextAlign.center)),
          _buildToggleButton(Icons.format_align_right, textAlign == TextAlign.end, () => setState(() => textAlign = TextAlign.end)),
          DropdownButton<double>(
            value: fontSize,
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
            onChanged: (value) => setState(() => fontSize = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(IconData icon, bool selected, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        icon,
        color: selected ? AppColors.primaryBlue : AppColors.textGray,
      ),
      onPressed: onPressed,
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
      );
      noteController.addNote(note);
    } else {
      noteController.updateNote(
        widget.noteToEdit!.id,
        title,
        content,
        isPinned: isPinned,
      );
    }

    Get.back();
  }

  void _deleteNote() {
    if (widget.noteToEdit != null) {
      noteController.deleteNoteById(widget.noteToEdit!.id);
      Get.back();
    }
  }
}
