import 'dart:convert';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/service_contract.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;

Future<List> fetchContracts(
  String accountNumber,
  String password,
  String transactionPin,  
  ) async {
  String param = Uri(queryParameters: {
      "account_number" : accountNumber,
      "password" : password,
      "transaction_pin": transactionPin,
      "observation": "fetch contract",
      "datetime": "Wed, 13 Apr 2001 01:21:07 GMT"
    }).query;
    Brakey brakey = Get.put(Brakey());

    final response = await http.get(
      Uri.parse('https://api.braketpay.com/braket_electronic_notification/v1?$param'),
        headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },

      );
      print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    List payloads = jsonDecode(response.body);
    List<ProductContract> newPayloads = [];
    for (Map<String, dynamic> item in payloads) {
      print(payloads);
      if (item.containsKey('Payload')) {

          newPayloads.add(ProductContract.fromJson(jsonDecode(jsonEncode(item))));
        
      }else {
        // payloads.remove(item);
      };

      
    }

    newPayloads.sort(((a, b) =>
                      b.httpDate().compareTo(a.httpDate())
                    ));
    brakey.setContracts(newPayloads);
    return (newPayloads);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}

Future<Map> createProductContract (
  String contractCreator,
  String buyerAddress,
  String sellerAddress,
  String bvn,
  String contractTitle,
  String productDetail,
  String productAmount,
  String shipFee,
  String logisticFrom,
  String logisticTo,
  String deliveryDate,
  String transactionPin,  
  ) async {
  Map param = {
      "smart_contract_type": 'product',
      "contract_creator": contractCreator,
      "buyer_address": buyerAddress,
      "seller_address": sellerAddress,
      "transaction_pin": transactionPin,
      "bvn": bvn,
      "product_contract_title": contractTitle,
      "product_details": productDetail,
      "product_amount": productAmount,
      "shipping_cost": shipFee,
      "shipping_location": logisticFrom,
      "shipping_destination": logisticTo,
      "delivery_datetime": deliveryDate
    };

    try {
      print('99090909090');
    final response = await Dio().post(
      'https://api.braketpay.com/create_product_smart_contract/v1',
      data: param,
      options: Options(
        headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      )
      );
      // print('99090909090');

      // print(response.data);

    if (response.statusCode == 200) {
      print(response.data);

      return response.data;

    } else {
      return {'Message': 'No Internet access, Please try again'};
    }
    } catch (e) {
      print(e);
      return {'Message': 'No Internet access, Please try again'};
    } 
}

Future<Map> createServiceContract (
  String contractCreator,
  String clientAddress,
  String providerAddress,
  String bvn,
  String contractTitle,
  String stages,
  String deliveryLoc,
  String downpayment,
  String deliveryDate,
  String transactionPin,  
  ) async {
  Map param = {
      "smart_contract_type": "service",
      "contract_creator": contractCreator,
      "client_address": clientAddress,
      "service_provider_address": providerAddress,
      "transaction_pin": transactionPin,
      "bvn": bvn,
      "service_contract_title": contractTitle,
      "delivery_location": deliveryLoc,
      "delivery_stages": stages,
      "down_payment": 0,
      "delivery_datetime": deliveryDate
    };
    try {
      print(param);
    final response = await Dio().post(
      'http://172.16.81.38:5001/create_service_smart_contract/v1',
      data: param,
      options: Options(
         headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      )
      );
      // print('99090909090');

      // print(response.data);

    if (response.statusCode == 200) {
      print(response.data);

      return response.data;

    } else {
      return {'Message': 'No Internet access'};
    }
    } catch (e) {
      print(e);

      return {'Message': 'No Internet access'};
    }
 }


Future<Map> contractAction (
  String confirmationCode,
  String pin,
  String contractID,
  String publicKey,
  String contractType,
  String instruction,
  String type,
  ) async {
  Map param = {
      "api_token" : "960efcf4-1ea7-4acc-b358-66a095bec90c",
      "api_token_id" : "000019657",
      "public_key": publicKey,
      type: confirmationCode,
      "transaction_pin": pin,
      "contract_id": contractID,
      "contract_type": contractType,
      "instruction": instruction
    };

      print(param);
      try {
    final response = await Dio().put(
      'https://api.braketpay.com/contract_execution_instructions/v1',
      data: param,
      options: Options(
         headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      )
      );
      // print('99090909090');

      print(response.data);

    if (response.statusCode == 200) {
      return response.data;

    } else {
      return {'Message':'No internet access'};
    }
    } catch (e) {
      print(e);
      return {'Message':'No internet access'};
    }
}