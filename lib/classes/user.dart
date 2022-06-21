class User {
  String? message;
  Payload? payload;
  int? responseCode;
  String? status;

  User({this.message, this.payload, this.responseCode, this.status});

  User.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    payload =
        json['Payload'] != null ? new Payload.fromJson(json['Payload']) : null;
    responseCode = json['Response code'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    if (this.payload != null) {
      data['Payload'] = this.payload!.toJson();
    }
    data['Response code'] = this.responseCode;
    data['Status'] = this.status;
    return data;
  }
}

class Payload {
  double? accountBalance;
  String? accountNumber;
  String? checkNotifications;
  String? dateOfBirth;
  String? datetimeLastChangesMade;
  String? email;
  String? fullname;
  String? password;
  String? phoneNumber;
  String? publicKey;
  String? username;
  String? qrCode;
  String? walletAddress;
  String? bvn;
  String? pin;

  Payload(
      {this.accountBalance,
      this.accountNumber,
      this.checkNotifications,
      this.dateOfBirth,
      this.datetimeLastChangesMade,
      this.email,
      this.fullname,
      this.password,
      this.username,
      this.phoneNumber,
      this.publicKey,
      this.qrCode,
      this.bvn,
      this.pin,
      this.walletAddress});

  Payload.fromJson(Map<String, dynamic> json) {
    accountBalance = json['account_balance'];
    accountNumber = json['account_number'];
    checkNotifications = json['check_notifications'];
    dateOfBirth = json['date_of_birth'];
    datetimeLastChangesMade = json['datetime_last_changes_made'];
    email = json['email'];
    fullname = json['fullname'];
    password = json['password'];
    bvn = json['bvn'];
    pin = json['transaction_pin'];
    username = json['user_name'];
    qrCode = json['account_qr_code'];
    phoneNumber = json['phone_number'];
    publicKey = json['public_key'];
    walletAddress = json['wallet_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_balance'] = this.accountBalance;
    data['account_number'] = this.accountNumber;
    data['check_notifications'] = this.checkNotifications;
    data['date_of_birth'] = this.dateOfBirth;
    data['datetime_last_changes_made'] = this.datetimeLastChangesMade;
    data['email'] = this.email;
    data['fullname'] = this.fullname;
    data['password'] = this.password;
    data['bvn'] = this.bvn;
    data['transaction_pin'] = this.pin;
    data['user_name'] = this.username;
    data['account_qr_code'] = this.qrCode;
    data['phone_number'] = this.phoneNumber;
    data['public_key'] = this.publicKey;
    data['wallet_address'] = this.walletAddress;
    return data;
  }
}
