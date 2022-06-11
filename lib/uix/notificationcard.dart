import 'package:braketpay/screen/productdetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../brakey.dart';
import '../screen/servicedetail.dart';
import '../screen/transactiondetail.dart';
import '../utils.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard({
    Key? key,
    required this.pin,
    required this.notifications,
  }) : super(key: key);

  final Map notifications;
  final String pin;
  Brakey brakey = Get.put(Brakey());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]),
        child: ListTile(
          title:Text(toTitleCase(notifications['message'])),
          subtitle:Text(notifications['notification_type']),
          leading: AbsorbPointer(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20)),
            child: IconButton(
                    icon: const Icon(IconlyBold.notification),
                    color: Colors.white,
                    iconSize: 20,
                    onPressed: () {}),
              ),
            ),
          onTap: () {
            if (notifications['notification_type'] == 'product') {
              brakey.contracts.value!.forEach((element) {
                if (element.payload!.contractID == notifications['contract_id']) {
                  Get.to(ProductDetail(contract: element, pin: pin, user: brakey.user.value!));
                }
                });
            } else if (notifications['notification_type'] == 'service') {
                brakey.contracts.value!.forEach((element) {
                if (element.payload!.contractID == notifications['contract_id']) {
                  Get.to(ServiceDetail(contract: element, pin: pin, user: brakey.user.value!));
                }
                });
            }  else if (notifications['notification_type'] == 'transfer') {
              print(notifications);
                brakey.transactions.value!.forEach((element) {
                if (element.payload!.receiptId == notifications['receipt_id']) {
                  Get.to(TransactionDetail(transaction: element, user: brakey.user.value!));
                }
                });}
          },
        ),
      ),
    );
  }
}
