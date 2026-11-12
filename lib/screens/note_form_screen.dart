import 'package:flutter/material.dart';
import '../utils/validators.dart';

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({Key? key}) : super(key: key);

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final sanitizedTitle = Validators.sanitize(_titleController.text);
      final sanitizedContent = Validators.sanitize(_contentController.text);

      Navigator.pop(context, {
        'title': sanitizedTitle,
        'content': sanitizedContent,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan Kuliah')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Catatan'),
                validator: Validators.validateTitle,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Isi Catatan'),
                maxLines: 5,
                validator: Validators.validateContent,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan Catatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}