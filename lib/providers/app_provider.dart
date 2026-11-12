import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/note.dart';

class AppProvider extends InheritedWidget {
  final Student student;
  final List<Note> notes;
  final Function(Student) updateStudent;
  final Function(Note, String) addNote; // Note + content untuk secure storage
  final Function(String) deleteNote;

  const AppProvider({
    Key? key,
    required this.student,
    required this.notes,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required Widget child,
  }) : super(key: key, child: child);

  static AppProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>();
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student || notes != oldWidget.notes;
  }
}