
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
      "verification_code": otp 
    };

      print('99090909090');
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
  ) async {
 String param = Uri(queryParameters: {
      "email_or_phone_number": email,
       'request_type': "verify"
    }).query;

      print('99090909090');
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/email_or_phone_confirmation/v1?$param'),
      );
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