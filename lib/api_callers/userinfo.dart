import 'dart:convert';
import 'dart:io';
import 'package:braketpay/classes/message.dart';
import 'package:braketpay/classes/user.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:location/location.dart';

import '../brakey.dart';
import 'addr.dart';

Brakey brakey = Get.put(Brakey());

Future<Map<String, dynamic>> getUserInfo(
  String userName,
  ) async {
  String param = Uri(queryParameters: {
      "caller_email" :"classichaddy@gmail.com",
      "caller_password": "love4haddy?",
      "id_type": "username",
      "second_party_id": userName
    }).query;

    try {
    final response = await http.get(
      Uri.parse('${BRAKETAPI}fetch_second_party_credentials?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      // print('4${response.body}'); 7650055023
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    // print(response.body);
    Map<String, dynamic> payloads = jsonDecode(response.body.replaceAll('incorect caller password', 'Incorrect password, Please try again'));
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return {'Message':'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
  }

    } catch (e) {
      // print(e);
    return {'Message':'No Internet access'};
    }

}


Future<Map<String, dynamic>> login(
  String userName,
  String password,
  ) async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  Map newMap = {"deviceID": map['id']??'', 'fingerprint':map['fingerprint']??'' };
  
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    // _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      // return {'Message':'Please enable Location access to continue'};
    }
  }  
  Map mapLocation = {
        "longitude": null,
        "latitude": null,
        "accuracy": null,
        "altitude": null,
        "speed": null,
        "time": null,
      };
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    // _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      mapLocation = {
        "longitude": null,
        "latitude": null,
        "accuracy": null,
        "altitude": null,
        "speed": null,
        "time": null,
      };
    } } else {
    _locationData = await location.getLocation();
      mapLocation = {
        "longitude": _locationData.longitude,
        "latitude": _locationData.latitude,
        "accuracy": _locationData.accuracy,
        "altitude": _locationData.altitude,
        "speed": _locationData.speed,
        "time": _locationData.time
      };
  }

  
  Map param = {
      "email_or_username": userName,
      "password": password,
      "device_data": newMap,
      "device_location": mapLocation
    };

    try {
    final response = await http.post(
      Uri.parse('${BRAKETAPI}login'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        body: jsonEncode(param)
      );
    // print(param);
      // print('4${response.body}'); 7650055023
    // print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    // print(response.body + 'sadlf;');
    // Map<String, dynamic> payloads = jsonDecode(response.body.replaceAll('incorect caller password', 'Incorrect password, Please try again'));
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return {'Message':'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
  }

    } catch (e) {
      // print(e);
    return {'Message':'No Internet access'};
    }

}

Future<Map<String, dynamic>> getUserWith(
  String id,
  String type, 
  ) async {
  String param = Uri(queryParameters: {
      "caller_email" :"classichaddy@gmail.com",
      "caller_password": "love4haddy?",
      "id_type": type,
      "second_party_id": id
    }).query;
    try {
    final response = await http.get(
      Uri.parse('${BRAKETAPI}fetch_second_party_credentials?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    // print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      Map<String, dynamic> payloads = jsonDecode(response.body);
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      // print('Hell');
    return {'Message':'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
  }

    } catch (e) {
      // print(e);
    return {'Message':'No Internet access'};
    }
}


Future<Map> verifyUserAccount(
  String userName,
  String password,
  String transactionPin,  
  ) async {
  String param = Uri(queryParameters: {
      "caller_email" :userName,
      "caller_password": password,
      "id_type": "account number",
      "second_party_id": "2204112769"
    }).query;
    try {
    final response = await http.get(
      Uri.parse('${BRAKETAPI}fetch_second_party_credentials?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (response.body is Map) {
      Map<String, dynamic> payloads = jsonDecode(response.body);
      return payloads;
    } else {
      return {"Info": response.body};
    }


  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw response.statusCode;
  }

    } catch (e)
 {
  //  print(e);
   throw 'No Internet Access';
 }}

Future<User> fetchUserAccount(
  String accountNumber,
  String password,
  String transactionPin,
  String loginToken
) async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  Map newMap = {"deviceID": map['id']??'', 'fingerprint':map['fingerprint']??'' };
  Map param = {
        "account_number" : accountNumber,
        "password" : password,
        "transaction_pin": transactionPin,
        "observation": "fetch account",
        "date_time": "Wed, 13 Apr 2022 01:21:07 GMT",
        "device_data":newMap,
        "login_token": await brakey.getUserToken(accountNumber)
    };
    // try 
    // print(param.toString()+"as ksdl f");
    final response = await http.post(
      Uri.parse('${BRAKETAPI}braket_electronic_notification/v1'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        body: jsonEncode(param),
      );
    // print(param);
    if (response.statusCode == 200) {
        print('success - (fetch account)');
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (jsonDecode(response.body) is Map) {
      Map a = jsonDecode(response.body);
      // print(a);
      if (jsonDecode(response.body).containsKey('Payload')) {
        Map<String, dynamic> payloads = jsonDecode(response.body);
        // print(payloads);
        return User.fromJson(payloads);
        }  else if (jsonDecode(response.body).containsKey('Message') && jsonDecode(response.body)['Message'] == 'new device detected') {
          brakey.logoutUser();
          // print('HIL');
          throw 'Logout Current User';
        }
      else {
          // Brakey().logoutUser();
          throw a['Message'];
        }
    } else {
      // print(response.body);
      // print("$password, $transactionPin");
      throw 'Incorrect Password!';
    }

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('failed - (fetch account)');

    throw 'Please check your internet connection';
  }
    // } catch (e) {
    //   print(e);
    //   throw 'No internet Connection';

    // }
    
}

Future<User> loginUser(  
  String userName,
  String password,
  String transactionPin,  
  ) async {
    Brakey brakey = Get.put(Brakey());
  Map<String, dynamic> validUsername =  await login(userName, password);
  // print(validUsername);
  if (validUsername.containsKey('Payload')) {
    String accountNumber =  validUsername['Payload']['account_number'];
    String loginToken =  validUsername['Payload']['login_token'];
    brakey.saveUserToken(accountNumber, loginToken);
    // print('aaaaaaa');
    return fetchUserAccount(accountNumber, password, '', loginToken);
  } else if (validUsername.containsKey('Message')) {
    if (validUsername['Message'] == "new device detected") {
      validUsername['email'] = validUsername['user_email'];
    }
    throw validUsername;

  }else {
    throw 'Please check your internet connection';
  };
}

getLoginOtp(
  String email,
  String password,
  // String deviceName,
  // String deviceProcessor,
  // String deviceArchi,
  // String location,
  // String operatingSystem,
)  async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  // map.forEach((e, v) => print('$e ==> $v'));
  // return;
  Map newMap = {"deviceID": map['id']??'', 'fingerprint':map['fingerprint']??'' };
  
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return {'Message':'Please enable Location access to continue'};
    }
  }
  _locationData = await location.getLocation();
  Map mapLocation = {
    "longitude": _locationData.longitude,
    "latitude": _locationData.latitude,
    "accuracy": _locationData.accuracy,
    "altitude": _locationData.altitude,
    "speed": _locationData.speed,
    "time": _locationData.time
  };

  Map param = {
      "email_or_username" : email,
      "password": password,
      "device_name": map['device']??'',
      "operating_system": jsonEncode(Platform.operatingSystem),
      "device_processor": jsonEncode(Platform.numberOfProcessors),
      "device_architecture": map['supportedAbis'].toString(),
      "device_location": mapLocation,
      "device_data": newMap
      };
      // print('$param glalalalal');
    try {
    final response = await http.post(
      Uri.parse('${BRAKETAPI}send_otp_for_new_device_login'),
      body: jsonEncode(param),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    // print('${response.body} ggggg');
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      Map a = jsonDecode(response.body);
      a['user_email'] = email;
      // print('sadfasdf');
        return a;

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      return {'Message':'This Service is currently undergoing maintenance in other to serve you better, please check back later'};
  }
    } catch (e) {
      print(e);
      return {'Message':'Please check your internet connection!'};
    }
}


fetchUserRecord(
  String email,
  String password,
  String otp,
) async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  // map.forEach((e, v) => print('$e ==> $v'));
  // return;
  Map newMap = {"deviceID": map['id']??'', 'fingerprint':map['fingerprint']??'' };
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    // _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return {'Message':'Please enable Location access to continue'};
    }
  }
  _locationData = await location.getLocation();
  Map mapLocation = {
    "longitude": _locationData.longitude,
    "latitude": _locationData.latitude,
    "altitude": _locationData.altitude,
    "accuracy": _locationData.accuracy,
    "speed": _locationData.speed,
    "time": _locationData.time
  };
  Map param = {
        "email_address" : email,
        "password" : password,
        "verification_code": otp,
        "device_name": map['device']??'',
        "operating_system": jsonEncode(Platform.operatingSystem),
        "device_processor": jsonEncode(Platform.numberOfProcessors),
        "device_architecture": map['supportedAbis'].toString(),
        "device_location": mapLocation,
        "device_data": newMap,
        "device_info": newMap
    };
    // try {
      // print(param);
    final response = await http.post(
      Uri.parse('${BRAKETAPI}verify_new_device_login?'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      body: jsonEncode(param),
      );
      // print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (jsonDecode(response.body) is Map) {
      Map a = jsonDecode(response.body);
      if (a.containsKey('Payload')) {
      // User user = await fetchUserAccount(a['Payload']['account_number'], password, '', '');
        // Map<String, dynamic> payloads = jsonDecode(response.body);
        return true;
        } 
      else {
          throw a['Message']??'';
        }
    } else {
      // print(response.body);
      // print("$password, $transactionPin");
      throw 'Incorrect Password!';
    }

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw 'Please check your internet connection';
  }
    // } catch (e) {
    //   print(e);
    //   throw 'No internet Connection';

    // }
    
}


Future<List<Message>> fetchChats(
  String walletAddress,
  String password,
  String transactionPin,  
  String volume,  
  String customerWalletAddress,  
  ) async {
    
  String param = Uri(queryParameters: {
      "wallet_address" : walletAddress,
      "password" : password,
      "transaction_pin": transactionPin,
      "chart_type": "",
      "volume": "all",
      "customer_wallet_address": "",
      "contract_id":"",
      // ""
    }).query;

    final response = await http.get(
      Uri.parse('${BRAKETAPI}fetch_chat?$param'),
        headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      // body: jsonEncode(param)
      );
      // 750
      print(param);
      print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (!jsonDecode(response.body).containsKey('Payload')) {
      throw [];
    }
    dynamic payloads = jsonDecode(response.body)['Payload'].values;
    List<Message> newPayloads = [];
    for (dynamic item in payloads) {
      Map<String, dynamic> newItem = jsonDecode(item.split('\n').join('\\n'));
      // print(payloads);
      // if (item.containsKey('Payload')) {
      //     item['Payload'].keys.forEach((v) {print(v);});
      // print(newItem.runtimeType);
      // print(newItem);
        if (newItem is Map) {
          // print(item.toString() + "asdfkasdlfj");
          // newItem.forEach((value, key) => print(value));
          newPayloads.add(Message.fromJson(newItem));
        
      }

      
    }

    // newPayloads.sort(((a, b) =>
    //                   b.httpDate().compareTo(a.httpDate())
    //                 ));
    // brakey.setContracts(newPayloads);
    print(newPayloads);
    return (newPayloads);
  } else {
    print('${response.body} uuuuuuuuuuuuu');
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}
