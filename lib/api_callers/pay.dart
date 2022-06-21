
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

Future<Map> buyAirtime(
  String phone,
  String network,
  String accountNumber,
  String amount,
  String pin
  ) async {
    int new_amount = double.parse(amount).toInt();
  print(new_amount); 
  String param = Uri(queryParameters: {
      "api_token": "960efcf4-1ea7-4acc-b358-66a095bec90c",
      "api_token_id": "000019657",
      "account_number":accountNumber,
      "phone_number": phone,
      "airtime_amount": new_amount.toString(),
      "network_name": network,
      "transaction_pin": pin
    }).query;

      print('99090909090');

    try {
      final response = await Dio().get(
        'https://api.braketpay.com/buy_airtime/v1?$param',
        options: Options(
          headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        )
        );
        // print('99090909090');

        print(response.realUri);

      print(response.data);
      if (response.statusCode == 200) {
        if (response.data.containsKey('response')) {
          if (response.data['response']['code'] == 'failure') {
              print('done');
              return {'Message':response.data['response']['message']};

          }
            return response.data;

        }


        print('here');
        return response.data;

      } else {

        return {'Message': 'No internet access'};
      }

    } catch (e) {
      print(e);
        return {'Message': 'No internet access'};
    }

    // finally {
    //   throw ('No internet access');
    // }

    
}

Future<Map> buyData(
  String phone,
  String network,
  String accountNumber,
  String amount,
  String pin,
  String plan
  ) async {
    int new_amount = double.parse(amount).toInt();
  print(new_amount); 
  String param = Uri(queryParameters: {
      "api_token": "960efcf4-1ea7-4acc-b358-66a095bec90c",
      "api_token_id": "000019657",
      "account_number":accountNumber,
      "phone_number": phone,
      "airtime_amount": new_amount.toString(),
      "network_name": network,
      "transaction_pin": pin,
      "data_plan": plan
    }).query;

      print('99090909090');

    print(param);
    try {
      final response = await Dio().get(
        'https://api.braketpay.com/buy_internet_data/v1?$param',
        options: Options(
          headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        )
        );
        print(response.data);


      if (response.statusCode == 200) {
        if (response.data.containsKey('response')) {
          if (response.data['response']['code'] == 'failure') {
              print('done');
              return response.data['response']['message'];

          } else {
            return  response.data;

          }

        } else {
            return response.data;

          }

      } else {

        return {'Message': "No internet access"};
      }

    } catch (e) {
      print(e);
        return {'Message': "No internet access"};
    }

    // finally {
    //   throw ('No internet access');
    // }

    
}

Future<bool> verifyMeterNumber(
  String phone,
  String accountNumber,
  String amount,
  String pin,
  String type,
  String plan
  ) async {
    int new_amount = double.parse(amount).toInt();
  print(new_amount); 
  String param = Uri(queryParameters: {
      "api_token": "960efcf4-1ea7-4acc-b358-66a095bec90c",
      "api_token_id": "000019657",
      "account_number":accountNumber,
      "transaction_pin": pin,
      "cable_tv_type": type,
      "tv_plan": plan,
      "smart_card_number": phone
    }).query;

      print('99090909090');

    print(param);
    try {
      final response = await Dio().get(
        'https://api.braketpay.com/cable_tv_subscription/v1?$param',
        options: Options(
          headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        )
        );
        // print('99090909090');


      if (response.statusCode == 200) {
        if (response.data.containsKey('response')) {
          if (response.data['response']['code'] == 'failure') {
              print('done');
              throw ('${response.data['response']['message']}');

          }
            throw ('${response.data}');

        }


        print('here');
        return true;

      } else {

        throw ('Please try again');
      }

    } catch (e) {
      print(e);
      print('[[');
      throw ('No internet access');
    }

    // finally {
    //   throw ('No internet access');
    // }

    
}


Future<Map> cashTransfer (
  String amount,
  String password,
  String pin,
  String accountNumber,
  String receiverAccountNumber,
  String receivingBank,
  String receivingName,
  String bankCode,
  String narration,
  String destinationRoute,
  ) async {
  Map param = {
      "sender_account_number" : accountNumber,
      "sending_amount" : amount,
      "sender_password": password,
      "sender_tranaction_pin" : pin,
      "receiver_account_number" : receiverAccountNumber,
      "receiving_bank" : receivingBank,
      "receiver_name" : receivingName,
      "bank_code" : bankCode,
      "destination_route" : destinationRoute,
      "api_token" : "960efcf4-1ea7-4acc-b358-66a095bec90c",
      "api_token_id" : "000019657",
      'narration': narration,
    };

      print(param);
      try {
    final response = await Dio().put(
      'https://api.braketpay.com/make_direct_transfer/v1',
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
      return {'Message':'No internet access'};
    }
    } catch (e) {
      print(e);
      return {'Message':'No internet access'};
    }
}

Future<Map<String, dynamic>> getMeterOwner(
  String accountNumber,
  String pin, 
  String region, 
  String cardNumber, 
  ) async {
  String param = Uri(queryParameters: {
    "account_number": accountNumber,
    "transaction_pin": pin,
    "service_region": region,
    "meter_number": cardNumber,
    "paid_type": "prepaid"
      
    }).query;
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/verify_meter_owner/v1?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      Map<String, dynamic> payloads = jsonDecode(response.body);
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return {'Message': "Can't verify meter number, Check your Internet connection (Tap to retry)."};
  }

    } catch (e) {
      print(e);
    return {'Message': "Can't verify meter number, Check your Internet connection (Tap to retry)."};
    }
}



Future<Map<String, dynamic>> getCableTVOwner(
  String accountNumber,
  String pin, 
  String type, 
  String cardNumber, 
  ) async {
  String param = Uri(queryParameters: {
    "account_number": accountNumber,
    "transaction_pin": pin,
    "cable_tv_type": type,
    "card_number": cardNumber
      
    }).query;
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/verify_cabletv_owner/v1?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      Map<String, dynamic> payloads = jsonDecode(response.body);
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return {'Message': "Can't verify card number, Check your Internet connection (Tap to retry)."};
  }

    } catch (e) {
      print(e);
    return {'Message': "Can't verify card number, Check your Internet connection (Tap to retry)."};
    }
}



Future<Map<String, dynamic>> getBanks(
  String email,
  String password, 
  String bank, 
  String bankCode, 
  String accountNumber, 
  ) async {
  String param = Uri(queryParameters: {
    "email_address": email,
    "password": password,
    "fetch_type": bank,
    "bank_code": bankCode,
    "bank_acc_number": accountNumber,
      
    }).query;
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/bank_list?$param'),
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
      Map<String, dynamic> payloads = jsonDecode(response.body);
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return {'Message': "Check your Internet connection (Tap to retry)."};
  }

    } catch (e) {
      print(e);
    return {'Message': "Check your Internet connection (Tap to retry)."};
    }
}

//  {Message: something went wrong but it is
// not your fault, please give us a moment to fix, then check back later,
// Response code: aa881, Status: failed}