import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

import '../uix/listitemseparated.dart';
import '../utils.dart';

class MerchantServiceDetail extends StatefulWidget {
  const MerchantServiceDetail({ Key? key, required this.product}) : super(key: key);
  
  final Map product;
  
  @override
  State<MerchantServiceDetail> createState() => _MerchantServiceDetailState();
}

class _MerchantServiceDetailState extends State<MerchantServiceDetail> {
  
  
  
  @override
  Widget build(BuildContext context) {
    print(widget.product);
    List<dynamic> ld = jsonDecode(utf8.decode(hex.decode(widget.product['service_picture'])));
            List<int> image = ld.map((s) => s as int).toList(); 
    Map stages = jsonDecode(widget.product['about_service_delivery_stages']);
    return Scaffold(
      appBar: AppBar(
        elevation: 0
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.memory(Uint8List.fromList(image)),
                SizedBox(height: 20),

        Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      )
                    ]),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Contract Details',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    ListItemSeparated(
                        text: widget.product['contract_title'],
                        title: 'Contract Title'),
                    ListItemSeparated(
                        text: '${widget.product['contract_type'].toUpperCase()} CONTRACT',
                        title: 'Contract Type'),
                    ListItemSeparated(
                        text: 'NGN ${(widget.product['downpayment'].toString())}',
                        title: 'Downpayment'),
                    ListItemSeparated(
                        text: widget.product['delivery_duration'],
                        title: 'Delivers In', isLast: true,),
                SizedBox(height: 20),],)),
        Container(
          margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      )
                    ]),

            child: Column(
              children: [
                SizedBox(height: 10),
                    Text(
                      'Service stages',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: stages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListItemSeparated(title: stages[stages.keys.toList()[index]]['about_stage'], text: formatAmount('${stages[stages.keys.toList()[index]]['cost_of_stage']}'));
                  },
                ),
              ],
            ),        
            ),
                SizedBox(height: 20),
                Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      )
                    ]),
                    child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Contract QRCODE',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),),
                      Image.memory(
            Uint8List.fromList(hex.decode(widget.product['service_qrcode']??'')),
          ),
                  ])),
        ],
        
        )),
      )
    );
  }
}