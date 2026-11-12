import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';

/// Layar utama aplikasi yang mengintegrasikan profil singkat, daftar catatan, dan data API
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingApi = false;
  String? _apiErrorMessage;
  List<dynamic> _apiPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchPublicApiData();
  }

  /// Mengambil data referensi dari API publik menggunakan package http dengan logging aman
  Future<void> _fetchPublicApiData() async {
    setState(() {
      _isLoadingApi = true;
      _apiErrorMessage = null;
    });

    try {
      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/posts?_limit=3'),
            headers: {'X-Api-Key': AppConfig.apiKey},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        // Logging aman: hanya mencetak status code tanpa token atau data sensitif
        debugPrint('HTTP GET berhasil. Status code: ${response.statusCode}');
        setState(() {
          _apiPosts = jsonDecode(response.body);
          _isLoadingApi = false;
        });
      } else {
        debugPrint('HTTP GET gagal. Status code: ${response.statusCode}');
        setState(() {
          _apiErrorMessage = 'Gagal memuat data API (Kode: ${response.statusCode})';
          _isLoadingApi = false;
        });
      }
    } on SocketException {
      debugPrint('HTTP Error: Tidak ada koneksi internet.');
      setState(() {
        _apiErrorMessage = 'Tidak ada koneksi internet.';
        _isLoadingApi = false;
      });
    } catch (e) {
      debugPrint('HTTP Error: Terjadi gangguan saat memuat data.');
      setState(() {
        _apiErrorMessage = 'Terjadi kesalahan atau waktu koneksi habis (Timeout).';
        _isLoadingApi = false;
      });
    }
  }

  /// Menampilkan dialog konfirmasi sebelum menghapus catatan
  void _confirmDelete(BuildContext context, AppProvider provider, Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus catatan "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteNote(note.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context)!;
    final student = provider.student;
    final notes = provider.notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah Mahasiswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profil Mahasiswa',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    student: student,
                    onUpdate: provider.updateStudent,
                  ),
                ),
              );
              if (result == true && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil diperbarui')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Atas: Profil Singkat (Nama & NIM)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    student.name.isNotEmpty ? student.name[0].toUpperCase() : 'M',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'NIM: ${student.nim}',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bagian Tengah: Daftar Catatan Kuliah
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Daftar Catatan Kuliah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: notes.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return NoteCard(
                        note: note,
                        onDelete: () => _confirmDelete(context, provider, note),
                      );
                    },
                  ),
          ),

          const Divider(thickness: 1),

          // Bagian Bawah: Data Referensi dari HTTP GET API Publik (Loading, Error, ListView)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Info Akademik (API Publik)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: _fetchPublicApiData,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _isLoadingApi
                ? const Center(child: CircularProgressIndicator())
                : _apiErrorMessage != null
                    ? Center(
                        child: Text(
                          _apiErrorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _apiPosts.length,
                        itemBuilder: (context, index) {
                          final post = _apiPosts[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.article_outlined, size: 20),
                            title: Text(
                              post['title'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Catatan',
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteFormScreen()),
          );

          if (result != null && result is Map<String, String>) {
            final newNote = Note(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: result['title']!,
              date: DateTime.now().toString().substring(0, 10),
            );
            provider.addNote(newNote, result['content']!);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan tersimpan secara terenkripsi')),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}