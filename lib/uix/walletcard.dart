import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:braketpay/brakey.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:iconly/iconly.dart';

class WalletCard extends StatefulWidget {
  WalletCard({Key? key, required this.balance, this.showAccountNumber=false, required this.title, this.showLeftButton=true, this.onTapSend, this.onTapFund, this.rightButtonLabel='fund', this.leftButtonLabel='send', this.rightButtonIcon, this.leftButtonIcon})
      : super(key: key);
  final String balance;
  final String title;
  Function? onTapSend;
  Function? onTapFund;
  String rightButtonLabel;
  String leftButtonLabel;
  IconData? rightButtonIcon;
  bool showLeftButton;
  IconData? leftButtonIcon;
  bool showAccountNumber;
  

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  Brakey brakey = Get.put(Brakey());
  bool showBalance = false;
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 6,
      // padding: EdgeInsets.zero,
      // border: Border.all(style: BorderStyle.none),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 190,
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
            Obx( () => Text(!brakey.showBalance(widget.title) ? '***' : formatAmount(widget.balance), style: TextStyle(color: Colors.white, fontSize: brakey.showBalance(widget.title) ? 18 : 22, fontFamily: 'Roboto', fontWeight: FontWeight.w600))),
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: !widget.showLeftButton ? MainAxisAlignment.center :  MainAxisAlignment.spaceAround,
                    children: [
                      
                      Visibility(
                        visible: widget.showLeftButton,
                        child: RoundButton(icon: widget.leftButtonIcon ,text: widget.leftButtonLabel, onTap: widget.onTapSend)),
                      RoundButton(icon: widget.rightButtonIcon, text: widget.rightButtonLabel, onTap: widget.onTapFund),
                    ],
                  ),
            ),
            // Visibility(
            //   visible: widget.showAccountNumber && brakey.user.value!.payload!.bvn !=
            //                             'Not added',
            //   child: InkWell(
            //     onTap: () {
            //       if (brakey.user.value!.payload!.bvn !=
            //           'Not added') {
            //         Clipboard.setData(ClipboardData(
            //             text: brakey.user.value!.payload!
            //                     .accountNumber ??
            //                 ''));
            //         Get.showSnackbar(const GetSnackBar(
            //             duration: Duration(seconds: 1),
            //             messageText: Text(
            //                 'Account number has been copied',
            //                 style:
            //                     TextStyle(color: Colors.white))));
            //       }
            //     },
            //     child: Center(
            //       child: Padding(
            //         padding: const EdgeInsets.all(5.0),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text('Account number: '+ (brakey.user.value?.payload?.accountNumber??''),
            //                 style: TextStyle(color: Colors.white,fontSize: 10, fontWeight: FontWeight.bold),
            //             ),
            //             SizedBox(width: 5,),
            //             Icon(CupertinoIcons.doc_on_doc_fill,
            //                                   size: 15,
            //                                   color: Colors.white)
            //           ],
            //         ),
            //       ),
            //     ),
            //   ))
          ]),
                ],
              ),
        ),
      ),
    );
  
  }
}
