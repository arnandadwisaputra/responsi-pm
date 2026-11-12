import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Belum ada catatan kuliah.', style: TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }
}