import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:braketpay/brakey.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class WalletCard extends StatefulWidget {
  WalletCard({Key? key, required this.balance, required this.title, this.onTapSend, this.onTapFund, this.rightButtonLabel='fund'})
      : super(key: key);
  final String balance;
  final String title;
  Function? onTapSend;
  Function? onTapFund;
  String rightButtonLabel;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  Brakey brakey = Get.put(Brakey());
  bool showBalance = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.2), borderRadius: BorderRadius.circular(20)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            Stack(
              children: [
              Positioned(
              right: 1,  
              child: 
              Obx( () => IconButton(icon: Icon(brakey.showBalance(widget.title)  ? IconlyBold.hide : IconlyBold.show,
              color: Colors.white,
              ), onPressed: () {
                setState(() {
                  
                });
                  brakey.smartToggleBalance(widget.title);
                },),
              )),
                Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Obx( () => Text(brakey.showBalance(widget.title) ? '***' : formatAmount(widget.balance), style: TextStyle(color: Colors.white, fontSize: brakey.showBalance(widget.title) ? 18 : 22, fontFamily: 'Roboto'))),
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    
                    RoundButton(text: 'send', onTap: widget.onTapSend),
                    RoundButton(text: widget.rightButtonLabel, onTap: widget.onTapFund),
                  ],
                ),
          )
        ]),
              ],
            ),
      ),
    );
  }
}
