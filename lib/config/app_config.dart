import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}