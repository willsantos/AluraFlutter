import 'package:bytebank/shared/config.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: Duration(seconds: 5),
);

//final String baseUrl = 'localhost:8080'; //Nao colocar o prefixo https

final String baseUrl = Config.baseUrl;
