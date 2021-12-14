import 'dart:convert';

import 'package:http/http.dart';

import '../api.dart';

class I18NWebClient {
  Future<Map<String, dynamic>> findAll() async {
    final Response response =
        await client.get(Uri.https(messagesBaseUrl, messagesUri));

    final Map<String, dynamic> decodedJson = jsonDecode(response.body);

    return decodedJson;
  }
}
