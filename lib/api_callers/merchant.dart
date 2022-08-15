import 'package:braketpay/api_callers/addr.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as gt;
import 'package:http/http.dart';
import 'dart:convert';

import '../brakey.dart';

Future<Map<String, dynamic>> getMerchant(
  String walletAddress,
  String pin,
  String password,
  ) async {
  String param = Uri(queryParameters: {
    "wallet_address":walletAddress,
    "transaction_pin":pin,
    "password": password
      
    }).query;
    try {
    final response = await get(
      Uri.parse('${BRAKETAPI}fetch_merchant_account?$param'),
       headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(param);
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      Map<String, dynamic> payloads = jsonDecode(response.body);
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return {'Message': "This Service is currently undergoing maintenance in other to serve you better, please check back later"};
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
  bool isBusinessRegistered,
  String businessLogoLink,
  String cacRegNumber,
  String cacImageLink,
  String cacMematImageLink,
  ) async {
      try {
  Map param = {
       "business_name": bizName,
        "business_email": email,
        "account_number":accountNumber,
        "website": website,
        "business_location": bizLoc,
        "transaction_pin": pin,
        "account_password": password,
        "is_business_registered": isBusinessRegistered,
        "business_logo_link": businessLogoLink,
        "business_phone": 9049500328,
        "merchant_short_business_description": ".",
        "cac_reg_number": cacRegNumber,
        "cac_certificate_link": cacImageLink,
        "cac_memat_link": cacMematImageLink ,
    };

      print(param);
    final response = await post(
      Uri.parse('${BRAKETAPI}create_merchant_account/v1'),
      body: jsonEncode(param),
         headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        }
      );
      // print('99090909090');

      // print(response.data);

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);

    } else {
      print(response.body);
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
  String password
  ) async {
    Brakey brakey = gt.Get.put(Brakey());
  
  String param = Uri(queryParameters: {
    "product_id": productID,
    "service_id": productID,
    "loan_id": productID,
    "merchant_id": id,
    "contract_type": contractType,
      "wallet_address":walletAddress,
      "transaction_pin":pin,
      "password": password,
      "volume": volume,
      // "welcome chat"
      
    }).query;

      print(param);
      print(brakey.user.value?.payload?.walletAddress??'no');
      
// 
    try {
      final response = await Dio().get(
        '${BRAKETAPI}fetch_registered_contract?$param',
        options: Options(
          headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        )
        
        );
      print(response.realUri);

      print('${response.data}%%%%%%%%%%%%%%%%%%%%%%');

    if (response.statusCode == 200) {
      response.data.forEach((key, value) {
        // print(key);
        // value.forEach((key, value) => print(key));
      });
      return response.data;

    } else {
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
    }
    } catch (e) {
      print(e);
      print('HIHOH');
      return {'Message': 'No internet access'};
    }
}
//  LON791973567,
//  LON3203862416,


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
      "welcome_chat": "",
      "categories": '',
      "product_contract_title": contractTitle,
      "product_details": productDetail,
      "product_amount": productAmount,
      "shipping_cost": shipFee,
      "shipping_location": logisticFrom,
      "shipping_destination": logisticTo,
      "delivery_datetime": deliveryDate,
    };

      print('99090909090');
    final response = await Dio().post(
      '${BRAKETAPI}create_product_smart_contract/v1',
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
  Map imageLinks,
  String amount,
  Map locations,
  String deliveryLoc,
  String transactionPin,  
  String category,  
  ) async {
  Map param = {
    "merchant_id": merchantId,
    "transaction_pin": transactionPin,
    "account_number":accountNumber,
    "product_name": productName,
    "delivery_data": locations,
    "product_amount": amount,
    "product_details": productDetail,
    'categories':{'category_1':category},
    "product_links": imageLinks,
    "welcome_chat":"",
    "contract_title": contractTitle,
    "shipping_location": deliveryLoc,
    "minimum_delivery_date": days
    };
    print(param);
    try{
    final response = await post(Uri.parse(
      '${BRAKETAPI}register_product_contract/v1'),
      body: jsonEncode(param),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    
      // print(response.realUri);

      // print(response.data);

    if (response.statusCode == 200) {
      print(response.body);

      return jsonDecode(response.body);

    } else {
      print(response.body);
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
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
  Map imageLinks,
  String transactionPin,  
  String category  
  ) async {
  Map<String, dynamic> param = {
    "merchant_id": merchantId,
    "transaction_pin": transactionPin,
    "account_number":accountNumber,
    "downpayment": downpayment,
    'categories':{"category_1":category},
    "delivery_stages": stages,
    "service_picture_links": imageLinks,
    "contract_title": contractTitle,
    "delivery_duration": days
    };
  var params = FormData.fromMap(param);
    print(param);
    try{
    final response = await post(
      Uri.parse('${BRAKETAPI}registered_service_contract/v1'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      body: jsonEncode(param)
      );
      print(response.body);

      print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      return jsonDecode(response.body);

    } else {
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
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
  String deliveryDays,
  int quantity,
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
      "delivery_days": deliveryDays,
      "delivery_location":location,
      "shipping_cost": shipFee,
      "product_quantity": quantity
    };

      print(param);
      try {
    final response = await put(Uri.parse(
      '${BRAKETAPI}activate_seller_contract/v1'),
      body: jsonEncode(param),
        headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      // print('99090909090');

      print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      if (!jsonDecode(response.body).containsKey('Payload')) {
          return jsonDecode(response.body);

      }

      return jsonDecode(response.body);

    } else {
      // print(response.data);
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
      '${BRAKETAPI}activate_client_contract/v1',
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
      print(response.data);
      if (!response.data.containsKey('Payload')) {
          return response.data;

      }

      return response.data;

    } else {
      print(response.data);
      return {'Message':'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
    }
    } catch (e) {
      print(e);
      return {'Message':'No internet access'};
    }
}