import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';

class WalletCard extends StatefulWidget {
  const WalletCard({Key? key, required this.balance, required this.title})
      : super(key: key);

  final String balance;
  final String title;

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
                Container(
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(colors: [
                        Colors.deepOrange,
                        Colors.deepOrangeAccent,
                      ])),
                  child: TextButton(
                      clipBehavior: Clip.hardEdge,
                      onPressed: () {},
                      child: const Text(
                        'send',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                ),
                const RoundButton(text: 'fund'),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
