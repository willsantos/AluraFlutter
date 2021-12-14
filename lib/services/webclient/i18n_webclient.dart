import 'dart:convert';

import 'package:http/http.dart';

import '../api.dart';

class I18NWebClient {
  final String translateScreen;
  final String translateLocale;

  I18NWebClient(this.translateScreen, this.translateLocale);

  Future<Map<String, dynamic>> findAll() async {
    final Response response = await client.get(Uri.https(messagesBaseUrl,
        messagesUri + translateScreen + '_' + translateLocale + '.json'));

    final Map<String, dynamic> decodedJson = jsonDecode(response.body);

    return decodedJson;
  }
}
