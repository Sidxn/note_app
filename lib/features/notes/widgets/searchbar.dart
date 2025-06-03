import 'package:app_note/features/notes/views/search_view.dart';

import 'package:flutter/material.dart';


class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
  showSearch(
    context: context,
    delegate: NotesSearchDelegate(),
  );
},

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 10),
            Text("Search notes..."),
          ],
        ),
      ),
    );
  }
}
