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
  String? walletAddress;

  Payload(
      {this.accountBalance,
      this.accountNumber,
      this.checkNotifications,
      this.dateOfBirth,
      this.datetimeLastChangesMade,
      this.email,
      this.fullname,
      this.password,
      this.phoneNumber,
      this.publicKey,
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
    data['phone_number'] = this.phoneNumber;
    data['public_key'] = this.publicKey;
    data['wallet_address'] = this.walletAddress;
    return data;
  }
}
