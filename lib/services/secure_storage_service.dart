import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> saveContent(String noteId, String content) async {
    await _secureStorage.write(key: 'note_content_$noteId', value: content);
  }

  Future<String?> getContent(String noteId) async {
    return await _secureStorage.read(key: 'note_content_$noteId');
  }

  Future<void> deleteContent(String noteId) async {
    await _secureStorage.delete(key: 'note_content_$noteId');
  }
}