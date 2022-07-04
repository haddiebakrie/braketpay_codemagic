import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/buydata.dart';
import 'package:braketpay/screen/cabletv.dart';
import 'package:braketpay/screen/electricity.dart';
import 'package:braketpay/screen/recharge.dart';
import 'package:braketpay/screen/savings.dart';
import 'package:braketpay/screen/transfer.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';

import '../uix/themedcontainer.dart';

class Utilities extends StatefulWidget {
  Utilities({Key? key, required this.user, required this.pin}) : super(key: key);

  @override
  State<Utilities> createState() => _UtilitiesState();
  final User user;
  final String pin;
}

class _UtilitiesState extends State<Utilities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Utilities'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration:ContainerBackgroundDecoration(),
        child: Center(
          child: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            children: [
              UtilityButton(
                url: 'assets/origami.png',
                text: 'Send money',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SendMoney(user: widget.user, pin: widget.pin)));
                },
              ),
              UtilityButton(
                url: 'assets/tv.png',
                text: 'Cable TV',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CableTV(user: widget.user, pin:widget.pin)));
                },
              ),
              UtilityButton(
                url: 'assets/wireless.png',
                text: 'Data',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BuyData(user: widget.user, pin: widget.pin)));
                },
              ),
              UtilityButton(
                url: 'assets/flash.png',
                text: 'Electricity',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Electricity(user: widget.user, pin: widget.pin)));
                },
              ),
              UtilityButton(
                url: 'assets/phone.png',
                text: 'Recharge',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Recharge(user: widget.user, pin: widget.pin)));
                },
              ),
              UtilityButton(
                url: 'assets/saving-money (1).png', text: 'Savings',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Savings(user: widget.user, pin: widget.pin)));
                },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
