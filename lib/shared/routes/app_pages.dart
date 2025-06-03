import 'package:app_note/features/notes/views/note_view.dart';
import 'package:get/get.dart';
import '../../features/notes/views/home_view.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => HomeView()),
    GetPage(name: '/add-note', page: () => const AddNoteView()),
  ];
}
