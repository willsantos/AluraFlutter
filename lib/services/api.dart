import 'package:bytebank/shared/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

final Client client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
);

final String baseUrl = '2281733043d6.ngrok.io';

//final String baseUrl = Config.baseUrl;
