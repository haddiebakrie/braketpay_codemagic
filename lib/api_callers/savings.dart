import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> getSavings(
  String accountNumber,
  String pin,
  String password,
  String volume,
  String id,
) async {
  String param = Uri(queryParameters: {
    "account_number": accountNumber,
    "transaction_pin": pin,
    "savings_id": id,
    "password": password,
    "volume": volume
  }).query;
  print(param);
  try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/fetch_savings/p?$param'),
    headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
    );
    print(response.body);
    if (response.statusCode == 200) {
      if (volume == 'all_savings_amount') {
        return jsonDecode(response.body);
      }
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Map<String, List> newPayload = {'Savings': []};
      if (jsonDecode(response.body) is Map) {
        return jsonDecode(response.body.replaceAll('\\\\', '').replaceAll('\\"{', '{').replaceAll('}\\"', '}'));
      }
      List payloads = jsonDecode(response.body.replaceAll('\\\\', '').replaceAll('\\"{', '{').replaceAll('}\\"', '}'));
      if (payloads.isEmpty) {   
        return {'Message': 'Empty'};
      }
      payloads.forEach((e) => newPayload['Savings']!.add(e['Payload']));
      // print(newPayload);
      print(response.statusCode);
      print(payloads);
      return newPayload;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return {'Message': "Check your Internet connection."};
    }
  } catch (e) {
      print('asdf');
    print(e);
    return {'Message': "Check your Internet connection."};
  }
}

Future<Map> createSavings(
  String savingsType,
  String savingsName,
  String firstCommit,
  String targetAmount,
  String frequency,
  String frequencyAmount,
  String accountNumber,
  String pin,
) async {
  try {
    print(targetAmount);
    Map param = {
      "api_token": "960efcf4-1ea7-4acc-b358-66a095bec90c",
      "api_token_id": "000019657",
      "savings_type": savingsType,
      "first_commitment_amount": double.parse(firstCommit),
      "target_amount": double.parse(targetAmount),
      "frequency_date": frequency,
      "frequency_amount": double.parse(frequencyAmount),
      "account_number": accountNumber,
      "name_of_savings": savingsName,
      "transaction_pin": pin
    };

    print(param);
    final response = await Dio()
        .post('https://api.braketpay.com/create_savings/v1', data: param,
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
      return {'Message': 'No internet access'};
    }
  } catch (e) {
    print(e);
    return {'Message': 'No internet access'};
  }
}


Future<Map> savingsCommit(
  String savingsID,
  String amount,
  String pin,
) async {
  try {
    Map param = {
      "api_token" : "960efcf4-1ea7-4acc-b358-66a095bec90c",
      "api_token_id" : "000019657",
      "savings_id": savingsID,
      "commit_amount": amount,
      "transaction_pin":pin
    };

    print(param);
    final response = await Dio()
        .put('https://api.braketpay.com/new_commit_savings/v1', data: param, 
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
      return {'Message': 'No internet access'};
    }
  } catch (e) {
    print(e);
    return {'Message': 'No internet access'};
  }
}
