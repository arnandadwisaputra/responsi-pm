import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository untuk mengelola penyimpanan metadata dan konten catatan
class NoteRepository {
  static const String _keyNotes = 'saved_notes';
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Mengambil daftar catatan lengkap dengan isi terenkripsinya
  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString(_keyNotes);
    if (notesJson == null) return [];

    List<dynamic> decoded = jsonDecode(notesJson);
    List<Note> notes = decoded.map((item) => Note.fromJson(item)).toList();

    // Ambil isi teks terenkripsi dari secure storage untuk setiap catatan
    for (var note in notes) {
      note.content = await _secureStorage.getContent(note.id);
    }
    return notes;
  }

  /// Menyimpan catatan baru (metadata ke SharedPreferences, isi ke Secure Storage)
  Future<void> saveNote(Note note, String content) async {
    final prefs = await SharedPreferences.getInstance();
    List<Note> notes = await getNotes();
    notes.add(note);

    // Simpan metadata ke SharedPreferences
    var encoded = notes.map((n) => n.toJson()).toList();
    await prefs.setString(_keyNotes, jsonEncode(encoded));

    // Simpan konten sensitif ke Flutter Secure Storage
    await _secureStorage.saveContent(note.id, content);
  }

  /// Menghapus catatan berdasarkan ID
  Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<Note> notes = await getNotes();
    notes.removeWhere((n) => n.id == id);

    var encoded = notes.map((n) => n.toJson()).toList();
    await prefs.setString(_keyNotes, jsonEncode(encoded));

    // Hapus konten dari secure storage
    await _secureStorage.deleteContent(id);
  }
}