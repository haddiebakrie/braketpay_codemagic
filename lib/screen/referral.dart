import 'package:braketpay/brakey.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferralBonus extends StatefulWidget {
  ReferralBonus({Key? key}) : super(key: key);

  @override
  State<ReferralBonus> createState() => _ReferralBonusState();
}

class _ReferralBonusState extends State<ReferralBonus> {
  Brakey brakey = Get.put(Brakey());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Refer & Earn'),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Invite your friends to BraketPay', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30)),
        ),
        SizedBox(height: 20,),
        Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text('0', style: TextStyle(color: Colors.grey, fontSize: 70)),
          Text('referrals', style: TextStyle(color: Colors.white, fontSize: 20)),
        ]
        ),
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(brakey.user.value!.payload!.username!.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 30)),
                  SizedBox(width:10),
                  Icon(CupertinoIcons.doc_on_doc_fill,
                                        size: 20,
                                        color: Colors.white)
                  ],
                ),
              ),
        SizedBox(height: 20,),
        Text('Invite your friends to signup to Braket using your Referral code to earn Referral bonus', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 16)),
            ],
          ),
        ),
        Expanded(child: Container()),
          Hero(
            tag: 'referral_box',
            child: Image.asset(
                                          'assets/open_gift.png',
                                          height: 250,
                                        ),
          ),
      ],)
    );
  }
}