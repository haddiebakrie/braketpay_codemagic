import 'dart:convert';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/service_contract.dart';
import 'package:dio/dio.dart';
import "package:http/http.dart" as http;

Future<Map> fetchNotifications(
  String walletAddress,
  String password,
  String transactionPin,  
  ) async {
  String param = Uri(queryParameters: {
      "wallet_address": walletAddress,
      "password" : password,
      "transaction_pin": transactionPin,
      "observation": "fetch notifications",
      "datetime": "Wed, 13 Apr 2001 01:21:07 GMT"
    }).query;

    final response = await http.get(
      Uri.parse('https://api.braketpay.com/braket_reciever_notification/v1?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      print(param);
      print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Map payloads = jsonDecode(response.body);
    List newPayloads = [];
    return payloads;
      
    

    // newPayloads.sort(((a, b) =>
    //                   b.httpDate().compareTo(a.httpDate())
    //                 ));
    // return (newPayloads);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
  }