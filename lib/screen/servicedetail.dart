import 'dart:convert';
import 'dart:ui';

import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';



class ServiceDetail extends StatefulWidget {
  const ServiceDetail({Key? key, required this.contract}) : super(key: key);


  final ProductContract contract;


  @override
  State<ServiceDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ServiceDetail> {
  @override
  Widget build(BuildContext context) {
  Map stages = jsonDecode(widget.contract.payload!.terms!.aboutStages!);
    final PageController _controller = PageController();
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.contract.payload!.terms!.contractTitle ?? '')
      ),

      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom:Radius.zero),
          color: Colors.white,
          ),
          child: PageView(
            controller: _controller,
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    height: double.infinity,
                    width: 2,
                    color: Colors.grey
                  ),
                  ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(20),
                                  child: Row(children: [
                                    Icon(Icons.calendar_month_rounded, color: Colors.deepOrange,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    )
                                  ],),
                                ),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40), child: Text('Created ${widget.contract.dateCreated()}', style: TextStyle(fontSize: 18),))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(20),
                                  child: Row(children: [
                                    Icon(Icons.people_alt_rounded, color: Colors.deepOrange),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Parties', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    )
                                  ],),
                                ),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5), child: Text('Created by: ${widget.contract.payload!.parties!.contractCreator}', style: TextStyle(fontSize: 18),)),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5), child: Text('Client: ${widget.contract.payload!.parties!.clientName}', style: TextStyle(fontSize: 18),)),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5), child: Text('Provider: ${widget.contract.payload!.parties!.providersName}', style: TextStyle(fontSize: 18),)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(20),
                                  child: Row(children: [
                                    Icon(Icons.timelapse_rounded, color: Colors.deepOrange),
                                    Padding(padding: EdgeInsets.all(8),child: Text('Stages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                                  ],),
                                ),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40), child: 
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: stages.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    print(widget.contract.payload!.terms!.stagesAchieved!);
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      trailing: widget.contract.payload!.terms!.stagesAchieved! > index ? Text('Done') : Text('Pending'),
                                      title: Text(stages[stages.keys.elementAt(index)]['about_stage']),
                                      subtitle: Text(formatAmount(stages[stages.keys.elementAt(index)]['cost_of_stage'].toString()),
                                      
                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),),
                                    );
                                  },
                                )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(20),
                                  child: Row(children: [
                                    Icon(Icons.fact_check, color: Colors.deepOrange),
                                    Padding(padding: EdgeInsets.all(8),child: Text('Total stages completed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                                  ],),
                                ),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5), child: Text('${widget.contract.payload!.terms!.stagesAchieved} of ${widget.contract.payload!.terms!.numberOfServiceStages} Stages completed',  style: TextStyle(fontSize: 18),)),
                                
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(20),
                                  child: Row(children: [
                                    Icon(Icons.payment, color: Colors.deepOrange),
                                    Padding(padding: EdgeInsets.all(8), child: Text('Total amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                                  ],),
                                ),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5), child: Text(formatAmount('${double.parse(widget.contract.payload!.terms!.totalServiceAmount!)}'), style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(20),
                                  child: Row(children: [
                                    Icon(Icons.payments, color: Colors.deepOrange),
                                    Padding(padding: EdgeInsets.all(8), child: Text('Amount paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                                  ],),
                                ),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5), child: Text(formatAmount('${double.parse(widget.contract.payload!.terms!.totalServiceAmount ?? '') - double.parse(widget.contract.payload!.terms!.remainderPayment ?? '')}'), style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(20),
                                  child: Row(children: [
                                    Icon(Icons.receipt, color: Colors.deepOrange),
                                    Padding(padding: EdgeInsets.all(8), child: Text('Down payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                                  ],),
                                ),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5), child: Text(widget.contract.payload!.states!.approvalState??'', style: TextStyle(fontSize: 18),)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(20),
                                  child: Row(children: [
                                    Icon(Icons.flag_circle, color: Colors.deepOrange),
                                    Padding(padding: EdgeInsets.all(8), child: Text('Contract State', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                                  ],),
                                ),
                                Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5), child: Text(widget.contract.payload!.states!.approvalState??'', style: TextStyle(fontSize: 18),)),
                              ],
                            ),
                            
                          ]
                        ),
                      ),
                    ],
                  )
                ]
              )
            ]

          ),

    ));
  }
}