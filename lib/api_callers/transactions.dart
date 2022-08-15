import 'dart:convert';

import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;

import 'addr.dart';

Future<List> fetchTransactions(
  String accountNumber,
  String password,
  String transactionPin,  
  ) async {
  Brakey brakey = Get.put(Brakey());
    final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  Map newMap = {"deviceID": map['id']??'', 'fingerprint':map['fingerprint']??'' };
  Map param = {
      "account_number" : accountNumber,
      "password" : password,
      "transaction_pin": transactionPin,
      "observation": "fetch transfer history",
      "date_time": "Wed, 13 Apr 2001 01:21:07 GMT",
      "login_token": await brakey.getUserToken(accountNumber),
      "device_data": newMap
    };
    final response = await http.post(
      Uri.parse('${BRAKETAPI}braket_electronic_notification/v1'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        body: jsonEncode(param)
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