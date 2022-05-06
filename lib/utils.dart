import 'dart:io';

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