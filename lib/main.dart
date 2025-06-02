import 'package:app_note/features/notes/controllers/note_controller.dart';
import 'package:app_note/shared/theme/theme.dart';
import 'package:app_note/features/notes/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main() {
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
      home:  HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
