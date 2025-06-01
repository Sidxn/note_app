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

class _AddNoteViewState extends State<AddNoteView> {
  final NoteController noteController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  double fontSize = 16;
  bool isBold = false;
  bool isItalic = false;
  TextAlign textAlign = TextAlign.start;

  @override
  void initState() {
    super.initState();
    if (widget.noteToEdit != null) {
      titleController.text = widget.noteToEdit!.title;
      contentController.text = widget.noteToEdit!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[900] : Colors.grey[100];
    final inputColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteToEdit == null ? 'New Note' : 'Edit Note'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCustomizationBar(),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      filled: true,
                      fillColor: inputColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      ),
                      decoration: InputDecoration(
                        hintText: 'Start typing...',
                        filled: true,
                        fillColor: inputColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              icon: const Icon(Icons.save),
              label: Text(widget.noteToEdit == null ? 'Save Note' : 'Update Note'),
              onPressed: _saveNote,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationBar() {
    return Row(
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
          items: [14, 16, 18, 20, 22]
              .map((size) => DropdownMenuItem(value: size.toDouble(), child: Text(size.toString())))
              .toList(),
          onChanged: (value) => setState(() => fontSize = value!),
        ),
      ],
    );
  }

  Widget _buildToggleButton(IconData icon, bool selected, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: selected ? Theme.of(context).colorScheme.primary : Colors.grey),
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
      );
      noteController.addNote(note);
    } else {
      noteController.updateNote(widget.noteToEdit!.id, title, content);
    }

    Get.back();
  }
}
