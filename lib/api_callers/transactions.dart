import 'dart:convert';

import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:get/get.dart';
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
    Brakey brakey = Get.put(Brakey());
    final response = await http.get(
      Uri.parse('https://api.braketpay.com/braket_electronic_notification/v1?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      // print(response.request.url);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    List payloads = jsonDecode(response.body);
    List<Transaction> newPayloads = [];
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
    brakey.setTransactions(newPayloads); 
    return newPayloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}