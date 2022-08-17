import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/buydata.dart';
import 'package:braketpay/screen/cabletv.dart';
import 'package:braketpay/screen/electricity.dart';
import 'package:braketpay/screen/recharge.dart';
import 'package:braketpay/screen/savings.dart';
import 'package:braketpay/screen/sendcash.dart';
import 'package:braketpay/screen/smart_transfer.dart';
import 'package:braketpay/screen/transfer.dart';
import 'package:braketpay/uix/actionbutton.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../uix/themedcontainer.dart';

class Utilities extends StatefulWidget {
  Utilities({Key? key, required this.user, required this.pin})
      : super(key: key);

  @override
  State<Utilities> createState() => _UtilitiesState();
  final User user;
  final String pin;
}

class _UtilitiesState extends State<Utilities> {
  Brakey brakey = Get.put(Brakey());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Pay Bill'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: ContainerBackgroundDecoration(),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      margin:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: ContainerDecoration(),
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(height: 10),
                            Text('Bill payments', style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                ActionButton(
                                  title: 'Airtime',
                                  icon: Icon(CupertinoIcons.device_phone_portrait,
                                      size: 30,
                                      color: Color.alphaBlend(
                                          Color.fromARGB(255, 82, 28, 221),
                                          Colors.blueAccent)),
                                  onTap: () {
                                    Get.to(() => Recharge(user: widget.user, pin: widget.pin));
                                  },
                                ),
                                ActionButton(
                                  title: 'Internet',
                                  icon: const Icon(CupertinoIcons.wifi,
                                      size: 30, color: Color.fromARGB(255, 247, 95, 0)),
                                  onTap: () {
                                    Get.to(() => BuyData(user: widget.user, pin: widget.pin));

                                  },
                                ),
                                ActionButton(
                                  title: 'Electricity',
                                  icon: const Icon(CupertinoIcons.lightbulb_fill,
                                      size: 30,
                                      color: Color.fromARGB(255, 70, 16, 231)),
                                  onTap: () {
                                    Get.to(() => Electricity(user: widget.user, pin: widget.pin));
                                  },
                                ),
                                ActionButton(
                                  title: 'Cable TV',
                                  icon: const Icon(CupertinoIcons.device_desktop,
                                      size: 30,
                                      color: Color.fromARGB(255, 67, 8, 244)),
                                  onTap: () {
                                    Get.to(() => CableTV(user: widget.user, pin: widget.pin));
                                  },
                                ),
                              ],
                            ),

                            SizedBox(height: 30),
                          ]))
                ],
              ),
            ),
                    Container(
              child: Column(
                children: [
                  Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      margin:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: ContainerDecoration(),
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(height: 10),
                            Text('Send Cash', style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                ActionButton(
                                  title: 'Braket user',
                                  icon: Icon(CupertinoIcons.square_arrow_up_fill,
                                      size: 30,
                                      color: Colors.teal),
                                  onTap: () {
                                    Get.to(() => SmartTransfer());
                                    // Get.to(() => SendMoney(user: widget.user, pin: widget.pin));
                                  },
                                ),
                                ActionButton(
                                  title: 'Other banks',
                                  icon: const Icon(CupertinoIcons.square_arrow_up_on_square_fill,
                                      size: 30, color: Color.fromARGB(255, 47, 0, 150)),
                                  onTap: () {
                                    Get.to(() => SendMoney(user: widget.user, pin: widget.pin));
                                    // servicePrompt();
                                  },
                                ),
                                ActionButton(
                                  title: 'QR Pay',
                                  icon: const Icon(CupertinoIcons.qrcode,
                                      size: 30,
                                      color: Color.fromARGB(255, 61, 9, 110)),
                                  onTap: () {
                                    // loanPrompt();
                                    Get.to(() => SendMoney(user: widget.user, pin: widget.pin));
                                  },
                                ),
                                ActionButton(
                                  title: 'Scan2Pay',
                                  icon: const Icon(CupertinoIcons.qrcode_viewfinder,
                                      size: 30, ),
                                  onTap: () {
                                    Get.to(() => SendMoney(user: widget.user, pin: widget.pin));

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => Utilities(
                                    //             user: widget.user, pin: widget.pin)));
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 30),

                          ]))
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
