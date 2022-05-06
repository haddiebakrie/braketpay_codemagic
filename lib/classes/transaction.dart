import 'package:intl/intl.dart';
import 'dart:io';


class Transaction {
  String? message;
  Payload? payload;
  int? responseCode;
  String? status;
  String? type;

  Transaction(
      {this.message, this.payload, this.responseCode, this.status, this.type});

  Transaction.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    payload =
        json['Payload'] != null ? new Payload.fromJson(json['Payload']) : null;
    responseCode = json['Response code'];
    status = json['Status'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    if (this.payload != null) {
      data['Payload'] = this.payload!.toJson();
    }
    data['Response code'] = this.responseCode;
    data['Status'] = this.status;
    data['Type'] = this.type;
    return data;
  }

  DateTime httpDate() {
      
      final DateTime formatted = HttpDate.parse(this.payload!.transactionDatetime ?? "");
      return formatted;
  }

  
}

class Payload {
  String? amount;
  String? info;
  String? narration;
  String? receiptId;
  String? receiverAccountNumber;
  String? receiverName;
  String? receivingBank;
  String? senderAccountNumber;
  String? senderName;
  String? transactionDatetime;
  String? transactionFee;
  String? transactionType;

  Payload(
      {this.amount,
      this.info,
      this.narration,
      this.receiptId,
      this.receiverAccountNumber,
      this.receiverName,
      this.receivingBank,
      this.senderAccountNumber,
      this.senderName,
      this.transactionDatetime,
      this.transactionFee,
      this.transactionType});

  Payload.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    info = json['info'];
    narration = json['narration'];
    receiptId = json['receipt_id'];
    receiverAccountNumber = json['receiver_account_number'];
    receiverName = json['receiver_name'];
    receivingBank = json['receiving_bank'];
    senderAccountNumber = json['sender_account_number'];
    senderName = json['sender_name'];
    transactionDatetime = json['transaction_datetime'];
    transactionFee = json['transaction_fee'];
    transactionType = json['transaction_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['info'] = this.info;
    data['narration'] = this.narration;
    data['receipt_id'] = this.receiptId;
    data['receiver_account_number'] = this.receiverAccountNumber;
    data['receiver_name'] = this.receiverName;
    data['receiving_bank'] = this.receivingBank;
    data['sender_account_number'] = this.senderAccountNumber;
    data['sender_name'] = this.senderName;
    data['transaction_datetime'] = this.transactionDatetime;
    data['transaction_fee'] = this.transactionFee;
    data['transaction_type'] = this.transactionType;
    return data;
  }


  String dateMade() {
    final DateTime formatted = HttpDate.parse(transactionDatetime ?? "");
    String date = DateFormat('MMM, dd yyyy').format(formatted);
    return date;
    }

  String formatAmount() {
    var currency = new NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return "${currency.format(double.parse(amount!))}";
  }
}
