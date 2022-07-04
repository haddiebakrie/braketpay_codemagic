import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showInfo(String dialogTitle, String body) {
  Get.defaultDialog(
    title: dialogTitle,
    middleText: body,
    textCancel: 'Close',
    cancel: TextButton(onPressed: () => Get.close(1), child: Text('Cancel', style: TextStyle(color: NeutralButton),))
  );
}