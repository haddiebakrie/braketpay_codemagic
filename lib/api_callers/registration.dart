
import 'dart:convert';

import 'package:braketpay/api_callers/userinfo.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';

Future<Map> createUserAccount (
  String fullname,
  String phoneNumber,
  String dateOfBirth,
  String email,
  String password,
  String phoneConfirm,
  String pin,
  String username,
  String otp,
  ) async {
  Map param = {
      "fullname": fullname,
      "phone_number": '234${int.parse(phoneNumber)}',
      "date_of_birth": dateOfBirth,
      "email_address": email,
      "password": password,
      'username': username,
      "verification_code": otp, 
      "verification_number": phoneConfirm,
      "pin": pin
    };

      print(param);
      try {
    final response = await Dio().post(
      'https://api.braketpay.com/create_account/v1',
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

Future<Map> sendOTP (
  String email,
  String bvn,
  ) async {
 String param = Uri(queryParameters: {
      "email_or_phone_number": email,
       'request_type': "verify",
       'bvn': bvn
    }).query;

      print('99090909090');
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/email_or_phone_confirmation/v1?$param'),
      ).timeout(
        const Duration(seconds: 10));;
      // print('99090909090');

      print(response.body);
      
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['Response Code'] == 422 || jsonDecode(response.body)['Response Code'] == 406) {
        print(response.body);
        return {'Message': '', "Status": 'successful'};
      }
        return jsonDecode(response.body);

    } else {
      return {'Message': 'No internet access'};
    }

    } catch (e) {
      print(e);
      return {'Message': 'No internet access'};
    }

}

Future<Map> verifyBVN (
  String phone,
  String otp,
  ) async {
 String param = Uri(queryParameters: {
      "verification_phone_number": phone,
       'verification_otp': otp,
    }).query;

      print('99090909090');
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/bvn_verification_fetch?$param'),
      ).timeout(
        const Duration(seconds: 10));

      print(response.body);
      
    if (response.statusCode == 200) {
      // if (jsonDecode(response.body)['Response Code'] == 422 || jsonDecode(response.body)['Response Code'] == 406) {
        print(response.body);
        return jsonDecode(response.body);
      // }
        // return jsonDecode(response.body);

    } else {
      return {'Message': 'No internet access'};
    }

    } catch (e) {
      print(e);
      return {'Message': 'No internet access'};
    }

}

Future<Map> setBVN (
  String phoneNumber,
  String email,
  String password,
  String username,
  String bvn,
  String pin,
  String addr,
  ) async {
      try {
      Map wallet_address = await getUserInfo(username);
      print(wallet_address);
      String w_addr = wallet_address['Payload']['wallet_address'];
  Map param = {
      "email_address": email,
      "wallet_address": w_addr,
      "phone_number": '234' + int.parse(phoneNumber).toString(),
      "password": password,
      "bvn":int.parse(bvn),
      "transaction_pin": pin
    };

      print(param);
    final response = await Dio().put(
      'https://api.braketpay.com/set_transaction_pin_and_bvn/v1',
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