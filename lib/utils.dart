import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import "package:intl/src/intl/number_format.dart";

final wallets = [{
    "name": "Referral",
    "balance": 1000
  },
  {
    "name": "Braket Wallet",
    "balance": 1000
  },
  {
    "name": "Savings",
    "balance": 1000
  },];

final format_currency = new NumberFormat('#,##0.00');

String formatAmount(String amount) {
    var currency = NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return currency.format(double.parse(amount));
  }


Future<PermissionStatus> getCameraPermission() async {
    var status = await Permission.camera.status;
    print(status.isGranted);
    if (!status.isGranted) {
        final result = await Permission.camera.request();
        return result;
    } else {
      return status;
    }
}