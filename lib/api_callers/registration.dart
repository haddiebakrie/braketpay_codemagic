
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
  String level,
  ) async {
    Map param;
  if (level=='without_bvn') {
    param = {
      "fullname": fullname,
      "phone_number": '234${int.parse(phoneNumber)}',
      "date_of_birth": dateOfBirth,
      "email_address": email,
      "password": password,
      'username': username,
      "verification_code": otp, 
      "verification_number": phoneConfirm,
      "signup_level": level
    };
  } else {
      param = {
          "fullname": fullname,
          "phone_number": '234${int.parse(phoneNumber)}',
          "date_of_birth": dateOfBirth,
          "email_address": email,
          "password": password,
          'username': username,
          "verification_code": otp, 
          "verification_number": phoneConfirm,
          "transaction_pin": pin,
          "signup_level": level
        };

  }

      print(param);
      try {
    final response = await post(
      Uri.parse('https://api.braketpay.com/create_account/v1'),
       headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      body: jsonEncode(param)
      );
      // print('99090909090');

      print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);

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
  String verifyType,
  String password,
  ) async {
 String param = Uri(queryParameters: {
      "email_or_phone_number": email,
       'request_type': verifyType,
       'password': password,
       'bvn_nin': bvn
    }).query;

      print(param);
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/email_or_phone_confirmation/v1?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      // print('99090909090');

      print(response.body);
      
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['Response Code'] == 422 || jsonDecode(response.body)['Response Code'] == 406) {
        print(response.body);
        return jsonDecode(response.body);

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
  String type,
  ) async {
 String param = Uri(queryParameters: {
      "verification_phone_number": phone,
      "verification_email_address": phone,
      "email_or_phone_number": phone,
       'verification_otp': otp,
       "request_type": type,
    }).query;

      print(param);
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/bvn_verification_fetch?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );

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
      // Map wallet_address = await getUserInfo(username);
      // print(wallet_address);
      // String w_addr = wallet_address['Payload']['wallet_address'];
  Map param = {
      "email_address": email,
      "wallet_address": addr,
      "phone_number": '234' + int.parse(phoneNumber).toString(),
      "password": password,
      "bvn_nin":bvn,
      "transaction_pin": pin
    };

      print(param);
    final response = await put(
      Uri.parse('https://api.braketpay.com/set_transaction_pin_and_bvn/v1'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      body: jsonEncode(param)
      );
      print(response.request?.url??'');

      print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);

    } else {
      return {'Message': 'No internet access'};
    }
    } catch (e) {
      print(e);
      return {'Message': 'No internet access'};
    }
}

Future<Map> forgotPINOtp (
  String changeType,
  String email,
  String publicKey,
  ) async {
      try {
      // Map wallet_address = await getUserInfo(username);
      // print(wallet_address);
      // String w_addr = wallet_address['Payload']['wallet_address'];
  String param = Uri(queryParameters: {
      "email_address": email,
      "change_type": changeType,
      'public_key': publicKey
    }).query;

      print(param);
    final response = await get(
      Uri.parse('http://172.16.23.9:5001/pin_password_change_otp?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );

      print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);

    } else {
      return {'Message': 'No internet access'};
    }
    } catch (e) {
      print(e);
      return {'Message': 'No internet access'};
    }
}


Future<Map> changePIN (
  String changeType,
  String email,
  String publicKey,
  String otp,
  String newPin,
  String dob,
  ) async {
      try {
      // Map wallet_address = await getUserInfo(username);
      // print(wallet_address);
      // String w_addr = wallet_address['Payload']['wallet_address'];
  Map param = {
      "email_address": email,
      "verification_code":otp,
      "date_of_birth": dob,
      "change_type": changeType,
      "new_password": newPin,
      "new_pin": newPin
    };

      print(param);
    final response = await put(
      Uri.parse('http://172.16.23.9:5001/change_pin_or_password/v1'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        body: jsonEncode(param)
      );

      print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);

    } else {
      return {'Message': 'No internet access'};
    }
    } catch (e) {
      print(e);
      return {'Message': 'No internet access'};
    }
}
