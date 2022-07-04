import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../uix/themedcontainer.dart';
import '../utils.dart';

class SavingsPlanDetail extends StatelessWidget {
  SavingsPlanDetail({Key? key, required this.plan}) : super(key: key);
  Map savingsDetail = {
    'Lite': {
      'month': "3",
      "interest": "2.5",
      "firstCommit": "100",
      'minimum': "100",
      "range": "100"
    },
    'Crystal': {
      'month': "6",
      "range": "50000",
      "interest": "5",
      "firstCommit": "50000",
      "minimum": "50000"
    },
    'Stack': {
      'month': "9",
      "interest": "7.5",
      "range": "300000",
      "firstCommit": "100000",
      "minimum": "300000"
    },
    'Vault': {
      'month': "12",
      "interest": "10",
      "range": "1000000",
      "firstCommit": "300000",
      "minimum": "1000000"
    },
  };
  Map planColor = {
    'Lite': const Color.fromARGB(255, 0, 112, 173),
    'Crystal': const Color.fromARGB(255, 0, 162, 162),
    'Stack': const Color.fromRGBO(152, 97, 77, 1),
    'Vault': const Color.fromARGB(255, 74, 73, 84),
  };
  final String plan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: planColor[plan],
      appBar: AppBar(
        backgroundColor: planColor[plan],
        elevation: 0,
      ),
      body: Column(
        children: [
          Hero(
            tag: 'savings_detail_$plan',
            child: SizedBox(
                width: double.infinity,
                height: 250,
                child: Center(
                    child: Material(
                        color: Colors.transparent,
                        child: Text(plan,
                            style: const TextStyle(
                                fontSize: 40, color: Colors.white))))),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: ContainerBackgroundDecoration(),
              child: Column(
                children: [
                   Container(
                     margin: EdgeInsets.only(bottom: 10),
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: EdgeInsets.all(20),
                    decoration: ContainerDecoration(),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.lightbulb, color: Colors.white,)),
                        SizedBox(height: 10,),
                        Text('Save over ${formatAmount(savingsDetail[plan]["minimum"])} for ${savingsDetail[plan]["month"]} months and earn ${savingsDetail[plan]["interest"]}% of your savings',
                        style: TextStyle(fontSize:18, fontFamily: '', color: adaptiveColor), 
                  textAlign: TextAlign.center),
                      ],
                    ),),
                  
            //       Text(
            //       'Save up to ${formatAmount(savingsDetail[plan]["minimum"])} for ${savingsDetail[plan]["month"]} months and earn ${savingsDetail[plan]["interest"]}% of your savings\n\nMinimum first commitment - ${formatAmount(savingsDetail[plan]["firstCommit"])}\nMinimum Savings duration - ${savingsDetail[plan]["month"]} months\nMinimum savings target - ${formatAmount(savingsDetail[plan]["range"])}', 
            //       style: const TextStyle(fontSize:18, fontFamily: ''), 
            //       textAlign: TextAlign.left),
            SizedBox(height: 20,),
                    Container(
                      decoration: ContainerDecoration(),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Minimum Amount'),
                            subtitle: Text('${formatAmount(savingsDetail[plan]["minimum"])}', style: TextStyle(fontFamily: ''),),
                            leading: IconButton(icon: Icon(CupertinoIcons.smallcircle_circle, color: Colors.red), onPressed: (){},),
                            horizontalTitleGap: 0,
                          ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('First commitment'),
                        subtitle: Text('${formatAmount(savingsDetail[plan]["firstCommit"])}', style: TextStyle(fontFamily: ''),),
                        leading: IconButton(icon: Icon(CupertinoIcons.app_badge_fill, color: Colors.teal), onPressed: (){},),
                        horizontalTitleGap: 0,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Interest rate'),
                        subtitle: Text('% ${savingsDetail[plan]["interest"]} ROI', style: TextStyle(fontFamily: ''),),
                        leading: IconButton(icon: Icon(CupertinoIcons.percent, color: Colors.purple), onPressed: (){},),
                        horizontalTitleGap: 0,
                      )
                        ],
                      ),
                    ),
            SizedBox(height: 40,),
                
                ],
              ),
                
            ),
          )
        ],
      ),
    );
  }
}
