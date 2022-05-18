import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future<Map<String, dynamic>> getMerchant(
  String walletAddress,
  String pin,
  ) async {
  String param = Uri(queryParameters: {
    "wallet_address":walletAddress,
    "transaction_pin":pin
      
    }).query;
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/fetch_merchant_account?$param'),
      );
      print(response.body);
      print(param);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      Map<String, dynamic> payloads = jsonDecode(response.body);
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return {'Message': "Check your Internet connection."};
  }

    } catch (e) {
      print(e);
    return {'Message': "Check your Internet connection."};
    }
}

Future<Map> createMerchant (
  String website,
  String email,
  String password,
  String bizName,
  String accountNumber,
  String pin,
  String bizLoc,
  ) async {
      try {
  Map param = {
       "business_name": bizName,
        "business_email": email,
        "account_number":accountNumber,
        "website": website,
        "business_location": bizLoc,
        "transaction_pin": pin,
        "account_password": password
    };

      print(param);
    final response = await Dio().post(
      'https://api.braketpay.com/create_merchant_account/v1',
      data: param
      );
      // print('99090909090');

      // print(response.data);

    if (response.statusCode == 200) {
      print(response.data);
      return response.data;

    } else {
      return {'Message': 'No internet access'};
    }
    } catch (e) {
      print(e);
      return {'Message': 'No internet access'};
    }
}


Future<Map> fetchMerchantContract (
  String productID,
  String contractType,
  String id,
  String walletAddress,
  String pin,
  String volume,
  ) async {
  String param = Uri(queryParameters: {
    "product_id": productID,
    "service_id": productID,
    "merchant_id": id,
    "contract_type": contractType,
      "wallet_address":walletAddress,
      "transaction_pin":pin,
      "volume": volume
      
    }).query;

      // print(param);
// 
    try {
      final response = await Dio().get(
        'https://api.braketpay.com/fetch_registered_contract?$param'
        );
      // print('99090909090');

      print('${response.data}%%%%%%%%%%%%%%%%%%%%%%');

    if (response.statusCode == 200) {
      // print(response.data);
      return response.data;

    } else {
      return {'Message': 'No internet access'};
    }
    } catch (e) {
      print(e);
      print('HIHOH');
      return {'Message': 'No internet access'};
    }
}


Future<bool> createProductContract (
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

      print('99090909090');
    final response = await Dio().post(
      'https://api.braketpay.com/create_product_smart_contract/v1',
      data: param
      );
      // print('99090909090');

      // print(response.data);

    if (response.statusCode == 200) {
      print(response.data);

      return true;

    } else {
      throw Exception('${response.data}');
    }
}

Future<Map> createMerchantProductContract (
  String merchantId,
  String accountNumber,
  String days,
  String productName,
  String contractTitle,
  String productDetail,
  String bytes,
  String amount,
  String deliveryLoc,
  String transactionPin,  
  ) async {
  Map param = {
    "merchant_id": merchantId,
    "transaction_pin": transactionPin,
    "account_number":accountNumber,
    "product_name": productName,
    "product_amount": amount,
    "product_details": productDetail,
    "product_picture": bytes,
    "contract_title": contractTitle,
    "shipping_location": deliveryLoc,
    "minimum_delivery_date": days
    };
    print(param);
    try{
    final response = await Dio().post(
      'https://api.braketpay.com/register_product_contract/v1',
      data: param
      );
      print(response.realUri);

      print(response.data);

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


Future<Map> createMerchantServiceContract (
  String merchantId,
  String accountNumber,
  String days,
  String stages,
  String downpayment,
  String contractTitle,
  String bytes,
  String transactionPin,  
  ) async {
  Map<String, dynamic> param = {
    "merchant_id": merchantId,
    "transaction_pin": transactionPin,
    "account_number":accountNumber,
    "downpayment": downpayment,
    "delivery_stages": stages,
    "service_picture": bytes,
    "contract_title": contractTitle,
    "delivery_duration": days
    };
  var params = FormData.fromMap(param);
    print(param);
    try{
    final response = await post(
      Uri.parse('https://api.braketpay.com/registered_service_contract/v1'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode(param)
      );
      print(response.body);

      print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      return jsonDecode(response.body);

    } else {
      return {'Message': 'No Internet access'};
    }
      
    } catch (e) {
      print(e);
      return {'Message': 'No Internet access'};
    }
}



Future<Map> activateMerchantContract (
  String bvn,
  String merchantID,
  String pin,
  String productID,
  String walletAddress,
  String location,
  String shipFee,
  ) async {
  Map param = {
      "bvn": bvn,
      "buyer_transaction_pin":pin,
      "merchant_id": merchantID,
      "product_id": productID,
      "buyer_wallet_address":walletAddress,
      "instruction": "qrscan",
      "delivery_location":location,
      "shipping_cost": shipFee
    };

      print(param);
      try {
    final response = await Dio().put(
      'https://api.braketpay.com/activate_seller_contract/v1',
      data: param
      );
      // print('99090909090');

      print(response.data);

    if (response.statusCode == 200) {
      print(response.data);
      if (!response.data.containsKey('Payload')) {
          return response.data;

      }

      return response.data;

    } else {
      print(response.data);
      return {'Message':'No internet access'};
    }
    } catch (e) {
      print(e);
      return {'Message':'No internet access'};
    }
}


Future<Map> activateServiceMerchantContract (
  String bvn,
  String merchantID,
  String pin,
  String serviceID,
  String walletAddress,
  String location,
  ) async {
  Map param = {
      "bvn": bvn,
      "client_transaction_pin":pin,
      "merchant_id": merchantID,
      "service_id": serviceID,
      "client_wallet_address":walletAddress,
      "instruction": "qrscan",
      "delivery_location":location,
    };

      print(param);
      try {
    final response = await Dio().put(
      'https://api.braketpay.com/activate_client_contract/v1',
      data: param
      );
      // print('99090909090');

      print(response.data);

    if (response.statusCode == 200) {
      print(response.data);
      if (!response.data.containsKey('Payload')) {
          return response.data;

      }

      return response.data;

    } else {
      print(response.data);
      return {'Message':'No internet access'};
    }
    } catch (e) {
      print(e);
      return {'Message':'No internet access'};
    }
}