import 'dart:convert';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

import '../api.dart';

class TransactionRoutes {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(Uri.https(baseUrl, 'transactions'));

    final List<dynamic> decodedJson = jsonDecode(response.body);

    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());
    final Response response =
        await client.post(Uri.https(baseUrl, 'transactions'),
            headers: {
              'Content-type': 'application/json',
              'password': password,
            },
            body: transactionJson);

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_statusCodeResponses[response.statusCode]);
  }

  static final Map<int, String> _statusCodeResponses = {
    400: 'There was an error submitting transaction',
    401: 'Auth Failed',
    404: 'Server not found',
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
