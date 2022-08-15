
import 'dart:convert';

import 'package:braketpay/api_callers/addr.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
  String otp2,
  Map imageLink,
  String fireToken,
  String level,
  ) async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  Map newMap = {"deviceID": map['id']??'', 'fingerprint':map['fingerprint']??'' };

    Map param;
  if (level=='without_bvn') {
    param = {
      "fullname": fullname,
      "phone_number": '${int.parse(phoneNumber)}',
      "date_of_birth": dateOfBirth,
      "email_address": email,
      "password": password,
      'username': username,
      "firebase_id": fireToken,
      "email_otp": otp, 
      "transaction_pin":pin,
      "phone_otp": otp2, 
      "bvn_nin_otp": phoneConfirm,
      "signup_level": level,
      "profile_picture_links":imageLink,
      "profile_picture": utf8.encode(null.toString()),
          "device_data": newMap,
    //    = user_data["phone_otp"]
		//  = user_data["email_otp"]
		//  = user_data["bvn_nin_otp"]
    };
  } else {
      param = {
          "fullname": fullname,
          "phone_number": '${int.parse(phoneNumber)}',
          "date_of_birth": dateOfBirth,
          "email_address": email,
          "password": password,
          'username': username,
          "email_otp": otp, 
          "transaction_pin":pin,
          "phone_otp": otp2, 
          "profile_picture_links":imageLink,
          "bvn_nin_otp": phoneConfirm,
          "firebase_id": fireToken,
          "signup_level": level,
          "profile_picture": utf8.encode(null.toString()),
          "device_data": newMap

        };

  }

      print(param);
      try {
    final response = await post(
      Uri.parse('${BRAKETAPI}create_account/v1'),
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
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
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
  String phone,
  ) async {
 String param = Uri(queryParameters: {
      "email_or_phone_number": email,
       'request_type': verifyType,
       'phone_number': phone,
       'bvn_nin': bvn
    }).query;

      print(param);
    try {
    final response = await get(
      Uri.parse('${BRAKETAPI}email_or_phone_confirmation/v1?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      // print('99090909090');

      print(response.body);
      
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['Response Code'] == 422 || jsonDecode(response.body)['Response Code'] == 406 || (jsonDecode(response.body).containsKey('response') && jsonDecode(response.body)['response']['Status'] == 'successfull')) {
        print(response.body);
        return jsonDecode(response.body);

      }
        return jsonDecode(response.body);

    } else {
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
    }

    } catch (e) {
      print(e);
      return {'Message': 'No internet access'};
    }

}

Future<Map> verifyBVN (
  String phone,
  String email,
  String phoneOTP,
  String emailOTP,
  String bvnOTP,
  String type,
  ) async {
 String param = Uri(queryParameters: {
      "phone_otp": phoneOTP,
      "email_otp": emailOTP,
      "bvn_nin_otp": bvnOTP,
      "email_address": email,
      "phone_number": phone,
       "signup_level": type,
    }).query;

      print(param);
    try {
    final response = await get(
      Uri.parse('${BRAKETAPI}bvn_verification_fetch?$param'),
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
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
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
      Uri.parse('${BRAKETAPI}set_transaction_pin_and_bvn/v1'),
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
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
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
      Uri.parse('${BRAKETAPI}pin_password_change_otp?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );

      print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);

    } else {
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
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
      Uri.parse('${BRAKETAPI}change_pin_or_password/v1'),
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
      return {'Message': 'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
    }
    } catch (e) {
      print(e);
      return {'Message': 'No internet access'};
    }
}
