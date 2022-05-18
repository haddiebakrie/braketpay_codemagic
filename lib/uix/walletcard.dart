import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';

class WalletCard extends StatefulWidget {
  WalletCard({Key? key, required this.balance, required this.title, this.onTapSend, this.onTapFund})
      : super(key: key);

  final String balance;
  final String title;
  Function? onTapSend;
  Function? onTapFund;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
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
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(formatAmount(widget.balance), style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                RoundButton(text: 'send', onTap: widget.onTapSend),
                RoundButton(text: 'fund', onTap: widget.onTapFund),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
