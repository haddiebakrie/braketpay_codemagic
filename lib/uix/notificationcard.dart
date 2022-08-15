import 'dart:io';

import 'package:braketpay/screen/loandetail.dart';
import 'package:braketpay/screen/productdetail.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

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
    print(notifications['notification_event']);
    return Container(
    padding: const EdgeInsets.all(5.0),
      decoration: ContainerDecoration(),
    margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(10),
            title: notifications['notification_type'] == 'transfer' ? 
            Wrap(
              children: [
                RichText(
                  text: TextSpan(
                  children: [
                    TextSpan(text: 'You received a Payment of ', style: TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).textTheme.bodyLarge?.color),),
                    TextSpan(text: formatAmount(notifications["amount"].toString()), style: const TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                          ),
                    TextSpan(text: ' from ', style: TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).textTheme.bodyLarge?.color),
                                          ),
                    TextSpan(text: notifications["sender_name"], style: TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).textTheme.bodyLarge?.color),
                                          ),
                    TextSpan(text: ' • ' + toAdvanceDate(DateFormat.MMMd().add_y().add_jms().parse(notifications['date_received'].replaceAll('-', ' '))), style: const TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                          ),
                  ]

                  )
                ),
              ],
            ): 
            notifications['notification_event'] == 'contract_creaion' ? 
            Wrap(
              children: [
                RichText(
                  text: TextSpan(
                  children: [
                    TextSpan(text: 'You received a Payment of ', style: TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).textTheme.bodyLarge?.color),),
                    TextSpan(text: formatAmount(notifications["amount"].toString()), style: const TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                          ),
                    TextSpan(text: ' from ', style: TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).textTheme.bodyLarge?.color),
                                          ),
                    TextSpan(text: notifications["sender_name"], style: TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).textTheme.bodyLarge?.color),
                                          ),
                    TextSpan(text: ' • ' + toAdvanceDate(DateFormat.MMMd().add_y().add_jms().parse(notifications['date_received'].replaceAll('-', ' '))), style: const TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                          ),
                  ]

                  )
                ),
              ],
            ) :
            Wrap(
              children: [
                RichText(
                  text: TextSpan(
                  children: [
                    TextSpan(text: toTitleCase(notifications['message'].replaceAll('u20a6', '\u20a6')), style: TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).textTheme.bodyLarge?.color),),
                    
                    TextSpan(text: ' • ' + (notifications['date_received'].contains('.') ? toAdvanceDate(DateTime.parse(notifications['date_received'])) : toAdvanceDate(DateFormat.MMMd().add_y().add_jms().parse(notifications['date_received'].replaceAll('-', ' ')))), style: const TextStyle(
                                          height: 1.5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                          ),
                  ]

                  )
                ),
              ],
            ),
            // Text(toTitleCase(notifications['message'].replaceAll('u20a6', '\u20a6')), style: TextStyle(
            //                               height: 1.5,
            //                               fontSize: 15,
            //                               fontWeight: FontWeight.w600,
            //                               color: Theme.of(context).textTheme.bodyLarge?.color)),
            // subtitle:Text(toTitleCase(notifications['notification_type'])),
            minVerticalPadding: 0,
            leading: AbsorbPointer(
            child: notifications['notification_type'] == 'transfer' ? 
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                      icon: const Icon(IconlyBold.notification),
                      color: Colors.white,
                      iconSize: 20,
                      onPressed: () {}),
            )
            : Container(
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
                    Get.to(() => ProductDetail(contract: element, pin: pin, user: brakey.user.value!));
                  }
                  });
              } else if (notifications['notification_type'] == 'service') {
                  brakey.contracts.value!.forEach((element) {
                  if (element.payload!.contractID == notifications['contract_id']) {
                    Get.to(() => ServiceDetail(contract: element, pin: pin, user: brakey.user.value!));
                  }
                  });
              }  else if (notifications['notification_type'] == 'transfer') {
                  brakey.transactions.value!.forEach((element) {
                  if (element.payload!.receiptId == notifications['receipt_id']) {
                    Get.to(() => TransactionDetail(transaction: element, user: brakey.user.value!));
                  } 
                  });} else if (notifications['notification_type'] == 'loan') {
                    brakey.contracts.value!.forEach((element) {
                  if (element.payload!.contractID == notifications['contract_id']) {
                    Get.to(() => LoanDetail(contract: element, user: brakey.user.value!, pin:pin));
                  } 
                  });}},
          ),
          Visibility(
            visible: notifications['notification_event'] == 'credit',  
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                RoundButton(
                  color1: adaptiveColor,
                  color2: adaptiveColor,
                  text: 'share',
                  icon: Icons.share,
                ),
                SizedBox(width: 10,),
                RoundButton(
                  color1: Colors.teal,
                  color2: Colors.teal,
                  text: 'view'
                )

                ]

              ),
            )
          
          
          ),
        Visibility(
            visible: notifications['notification_event'] == 'contract_creation',  
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                RoundButton(
                  color1: Colors.redAccent,
                  color2: Colors.redAccent,
                  text: 'reject',
                ),
                SizedBox(width: 10,),
                RoundButton(
                  color1: Colors.teal,
                  color2: Colors.teal,
                  text: 'accept'
                )

                ]

              ),
            )
          
          
          ),
          Visibility(
            visible: notifications['notification_event'] == 'rejected' || notifications['notification_event'] == 'terminated' || notifications['notification_event'] == 'confirmed' || notifications['notification_event'] == 'accepted',  
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                RoundButton(
                  color1: Colors.teal,
                  color2: Colors.teal,
                  text: 'view',
                ),
                

                ]

              ),
            )
          
          
          )
        
        ],
      ),
    );
  }
}
