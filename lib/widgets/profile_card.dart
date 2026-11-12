import 'package:flutter/material.dart';
import '../models/student.dart';

/// Widget modular untuk menampilkan kartu profil mahasiswa
class ProfileCard extends StatelessWidget {
  final Student student;

  const ProfileCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: Text(
                student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('NIM: ${student.nim}'),
                  Text('Prodi: ${student.programStudi}'),
                  Text('Email: ${student.email}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}