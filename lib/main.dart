import 'package:app_note/features/notes/controllers/note_controller.dart';
import 'package:app_note/features/notes/models/note.dart';
import 'package:app_note/shared/theme/theme.dart';
import 'package:app_note/features/notes/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(NoteAdapter()); // Replace with your adapter class

  // Open your boxes BEFORE injecting controller
  await Hive.openBox<Note>('note');

  // Inject NoteController AFTER box is opened
  Get.put(NoteController());

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    title: 'Keep Note',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, 
   
      themeMode: ThemeMode.system, // Or ThemeMode.light / dark
      home:  NotesHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
