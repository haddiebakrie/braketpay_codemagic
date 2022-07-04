
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'dart:convert';


Future<Map> createLoanContract (
  String merchantID,
  String accountNumber,
  String password,
  Map range,
  String contractTitle,
  String description,
  String interest,
  String period,
  String picture,
  bool visibility,
  String type,
  String transactionPin,  
  String loanCategory
  ) async {
  Map param = {
      "merchant_id": merchantID,
      "transaction_pin" : transactionPin,
      "account_number": accountNumber,
      "loan_category": loanCategory,
      "account_password": password,
      "loan_amount_range": range,
      "interest_rate":interest,
      "loan_title": contractTitle,
      "loan_period": period,
      "loan_description": description,
      "loan_picture": picture,
      "loan_visibility": visibility,
      "loan_type": type
    };

    try {
      print('99090909090');
    final response = await Dio().post(
      'http://172.16.23.9:5001/register_loan_contract/v1',
      data: param,
      options: Options(
        headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      )
      );
      print(param);

      print(response.data);

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

Future<Map> activateLoanContract (
  String loanID,
  String walletAddress,
  String pin,
  String bvn,
  String amount,
  Map useOfFunds,
  String nokName,
  String nokNIN,
  String nokPhone,
  String phone,
  bool maritalStatus,
  String levelOfEducation,
  String bankStatement,
  String state,
  String lga,
  String street,
  String paybackStatement,
  int noOfDependent,
  String employment,
  ) async {
  Map param = {
      "loan_id": loanID,
      "borrower_wallet_address": walletAddress,
      "borrower_transaction_pin": pin,
      "borrower_bvn_nin":bvn,
      "loan_amount": amount,
      "use_of_funds":useOfFunds,
      "next_of_kin_name": nokName,
      "next_of_kin_nin": nokNIN,
      "next_of_kin_phone_number": nokPhone,
      "borrower_active_phone_number": phone,
      "marital_status": maritalStatus,
      "level_of_education": levelOfEducation,
      "upload_bank_statement": bankStatement,
      "current_address_state": state,
      "current_address_city": '',
      "current_address_lga": lga,
      "current_address_street": street,
      "paying_back_statement": paybackStatement,
      "number_of_dependent": noOfDependent,
      "employment_status": employment
    };

    try {
      print(param);
      // "ca417768436ff0183085b3d7c382773f"
    final response = await post(
      Uri.parse('http://172.16.23.9:5001/activate_registered_loan/v1'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      body: jsonEncode(param)
      );
      // print('99090909090');

      print(response.body);

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {
      return {'Message': 'No Internet access, Please try again'};
    }
    } catch (e) {
      print(e);
      return {'Message': 'No Internet access, Please try again'};
    } 
}


Future<Map> confirmLoanContract (
  String loanID,
  String walletAddress,
  String pin,
  String merchantID,
  String instruction
  ) async {
  Map param = {
    "wallet_address": walletAddress,
    "transaction_pin":pin,
    "merchant_id" : merchantID,
    "contract_id": loanID,
    "instruction": instruction,  
    };

    try {
      print('99090909090');
    final response = await Dio().post(
      'https://api.braketpay.com/confirm_loan_contract/v1',
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

      return response.data;

    } else {
      return {'Message': 'No Internet access, Please try again'};
    }
    } catch (e) {
      print(e);
      return {'Message': 'No Internet access, Please try again'};
    } 
}


Future<Map> loanAction (
  String pin,
  String contractID,
  String merchantID,
  String walletAddress,
  String instruction,
  ) async {
  Map param = {
      "transaction_pin": pin,
      "contract_id": contractID,
      "wallet_address": walletAddress,
      "merchant_id": merchantID,
      "instruction": instruction
    };

      print(param);
      try {
    final response = await Dio().put(
      'https://api.braketpay.com/confirm_loan_contract/v1',
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