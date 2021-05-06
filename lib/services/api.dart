import 'package:bytebank/shared/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

final Client client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: Duration(seconds: 5),
);

//final String baseUrl = '7596a612f891.ngrok.io';
//final String baseUrl = '9b4a09099409.ngrok.io';
final String baseUrl = '192.168.0.63';

//final String baseUrl = Config.baseUrl;
