import 'dart:collection';
import 'dart:convert';
import 'package:braketpay/api_callers/addr.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';

Future<Map> fetchMarketContracts(
  String publicKey,  
  String password,
  ) async {
  String param = Uri(queryParameters: {
      "public_key" : publicKey,
      "password" : password,
      
    }).query;
    Brakey brakey = Get.put(Brakey());
    print(param);
    final response = await http.get(
      Uri.parse('${BRAKETAPI}fetch_all_registered_contract?$param'),
        headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },

      );
      // 750
      // print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    // print(response.body);
    Map payloads = jsonDecode(response.body) as Map;
    List<ProductContract> newPayloads = [];
    // print();
    if (payloads.containsKey('Payload')) {
        payloads['Payload']!.forEach((key, value) {
          // print(payloads['Payload'][item]);
          // for (dynamic i in item.values) {
            value.forEach((item)  {
                print('$key, ');
                // newPayloads.add(ProductContract.fromJson(jsonDecode(jsonEncode(item))));

            });
          // }
          // print(payloads);
          // item['Payload']['Terms'].keys.forEach((v) {print(v);});
          
          // print(item.toString() + "asdfkasdlfj");
      }
        );

      
    }

    newPayloads.sort(((a, b) =>
                      b.httpDate().compareTo(a.httpDate())
                    ));
    // brakey.setContracts(newPayloads);
    return (payloads['Payload']);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}


Future<List> fetchMarketProductContracts(
  String publicKey,  
  String password,
  ) async {
  String param = Uri(queryParameters: {
      "public_key" : publicKey,
      "password" : password,
    }).query;
    Brakey brakey = Get.put(Brakey());
    print(param);
    final response = await http.get(
      Uri.parse('${BRAKETAPI}fetch_all_registered_contract?$param'),
        headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },

      );
      // 750
      // print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    // print(response.body);
    Map payloads = jsonDecode(response.body) as Map;
    List newPayloads = [];
    // print();
    if (payloads.containsKey('Payload')) {
        payloads['Payload']!.forEach((key, value) {
          print(key);
          if (key == 'PRODUCT') {
            value.forEach((item)  {
                print(item);
                newPayloads.add(jsonDecode(jsonEncode(item['Payload'])));
            });
          }
          // print(payloads['Payload'][item]);
          // for (dynamic i in item.values) {

          // }
          // print(payloads);
          // item['Payload']['Terms'].keys.forEach((v) {print(v);});
          
          // print(item.toString() + "asdfkasdlfj");
      }
        );

      
    }

    // newPayloads.sort(((a, b) =>
    //                   b.httpDate().compareTo(a.httpDate())
    //                 ));
    // brakey.setContracts(newPayloads);
    return (newPayloads);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}


messageSeller(
  String contractID,
  String senderWalletAddress,
  String customerWalletAddress,
  String senderPassword,
  String chatType,
  String message,
  String messageSender,
  ) async {
  Map param = {
      "contract_id": contractID,
      "sender_wallet_address": senderWalletAddress,
      "receiver_wallet_address": customerWalletAddress,
      "chart_type": chatType,
      "sender_password": senderPassword,
      "message": {"text":message, "file_link":null},
      "message_sender": messageSender,
    };
    Brakey brakey = Get.put(Brakey());
    print(param);
    final response = await http.put(
      Uri.parse('${BRAKETAPI}chat/v1'),
        headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        body: jsonEncode(param)
      );
      // 750
      print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
    Map payloads = jsonDecode(response.body) as Map;
    List newPayloads = [];
    // print();
    if (payloads.containsKey('Payload')) {
        print(payloads);
          
          // print(payloads['Payload'][item]);
          // for (dynamic i in item.values) {

          // }
          // print(payloads);
          // item['Payload']['Terms'].keys.forEach((v) {print(v);});
          
          // print(item.toString() + "asdfkasdlfj");
        

      
    }

    // newPayloads.sort(((a, b) =>
    //                   b.httpDate().compareTo(a.httpDate())
    //                 ));
    // brakey.setContracts(newPayloads);
    return (newPayloads);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}