import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/note.dart';
import 'models/student.dart';
import 'providers/app_provider.dart';
import 'repositories/note_repository.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

/// Root aplikasi dengan ThemeData terpusat
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviderWrapper(
      child: MaterialApp(
        title: 'Profil Mahasiswa & Catatan Kuliah',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            elevation: 2,
            centerTitle: false,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

/// StatefulWidget pengelola state global yang menyediakan AppProvider ke subtree
class AppProviderWrapper extends StatefulWidget {
  final Widget child;

  const AppProviderWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _repository = NoteRepository();

  Student _student = Student(
    name: 'Arnanda Dwi Saputra',
    nim: '25.11.6577',
    programStudi: 'S1 Informatika',
    email: 'a.dwi.saputra081@students.amikom.ac.id',
  );

  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadInitialNotes();
  }

  Future<void> _loadInitialNotes() async {
    final loadedNotes = await _repository.getNotes();
    setState(() {
      _notes = loadedNotes;
    });
  }

  void _updateStudent(Student updatedStudent) {
    setState(() {
      _student = updatedStudent;
    });
  }

  Future<void> _addNote(Note note, String content) async {
    await _repository.saveNote(note, content);
    await _loadInitialNotes();
  }

  Future<void> _deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
    await _loadInitialNotes();
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}