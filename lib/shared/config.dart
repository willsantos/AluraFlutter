import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String baseUrl = dotenv.env['API_URL'];
  static String messagesBaseUrl = dotenv.env['MESSAGES_URL'];
  static String messagesUri = dotenv.env['MESSAGES_URI'];
}
