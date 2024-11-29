import 'package:app_note/views/note_view.dart';
import 'package:get/get.dart';
import '../views/home_view.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => HomeView()),
    GetPage(name: '/add-note', page: () => AddNoteView()),
  ];
}
