import 'dart:convert';

import 'package:braketpay/classes/transaction.dart';
import "package:http/http.dart" as http;

Future<List> fetchTransactions(
  String accountNumber,
  String password,
  String transactionPin,  
  ) async {
  String param = Uri(queryParameters: {
      "account_number" : accountNumber,
      "password" : password,
      "transaction_pin": transactionPin,
      "observation": "fetch transfer history",
      "datetime": ""
    }).query;

    final response = await http.get(
      Uri.parse('https://api.braketpay.com/braket_electronic_notification/v1?$param'),
      
      );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    List payloads = jsonDecode(response.body);
    List newPayloads = [];
    // print('item');
    for (dynamic item in payloads) {

      if (item is String) {
      }else {
      // print(item);
      if (item.containsKey('Payload')) {
          newPayloads.add(Transaction.fromJson(jsonDecode(jsonEncode(item))));
        // payloads.remove(item);
      };

      }


      
    }

  newPayloads.sort(((a, b) =>
                  b.httpDate().compareTo(a.httpDate())
                ));

    return newPayloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}