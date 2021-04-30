import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class Config {
  static String baseUrl = DotEnv.env['API_URL'];
}
