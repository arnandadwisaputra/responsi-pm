import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  final Student student;
  final Function(Student) onUpdate;

  const ProfileScreen({Key? key, required this.student, required this.onUpdate}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _nimController;
  late TextEditingController _prodiController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _nimController = TextEditingController(text: widget.student.nim);
    _prodiController = TextEditingController(text: widget.student.programStudi);
    _emailController = TextEditingController(text: widget.student.email);
  }

  void _saveProfile() {
    Student updated = Student(
      name: _nameController.text,
      nim: _nimController.text,
      programStudi: _prodiController.text,
      email: _emailController.text,
    );
    widget.onUpdate(updated);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ProfileCard(student: widget.student),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: _nimController, decoration: const InputDecoration(labelText: 'NIM')),
            TextField(controller: _prodiController, decoration: const InputDecoration(labelText: 'Program Studi')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}