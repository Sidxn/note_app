import 'package:app_note/features/notes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NoteSummaryCard extends StatelessWidget {
  final NoteController noteController = Get.find<NoteController>();

  NoteSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalNotes = noteController.notes.length;
      final lastNote = totalNotes > 0 ? noteController.notes.last : null;

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Notes Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoTile("Total Notes", totalNotes.toString()),
                  if (lastNote != null)
                    _buildInfoTile(
                      "Last Note",
                      "${lastNote.createdAt.day}/${lastNote.createdAt.month}/${lastNote.createdAt.year}",
                    ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
