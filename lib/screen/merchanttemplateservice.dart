import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../uix/listitemseparated.dart';
import '../uix/themedcontainer.dart';
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
    widget.product.keys.forEach((element) {print(element);});
    List<dynamic> ld = jsonDecode(utf8.decode(hex.decode(widget.product['service_picture'])));
            List<int> image = ld.map((s) => s as int).toList(); 
    Map stages = jsonDecode(widget.product['about_service_delivery_stages']);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0
      ),
      body: Container(
        decoration: ContainerBackgroundDecoration(),
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Hero(
              tag: 'merchant_product_image',
              child: Image.memory(Uint8List.fromList(image), height: 200,)),
                  SizedBox(height: 20),

          Container(
                  decoration: ContainerDecoration(),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Contract Details',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                                            Padding(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: Column(
                          children: [
                          ListTile(title: Text('Service ID'), subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical:10),
                            child: Text(widget.product['service_id']??'', style: TextStyle(fontFamily: '')),
                          ),
                          trailing: Column(
                            children: [
                            Icon(CupertinoIcons.doc_on_doc_fill, size: 16, color: Theme.of(context).primaryColor),
                            Text('copy', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13))
                            ]
                          ),
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: widget.product['service_id']??''));
                                Get.showSnackbar(const GetSnackBar(
                                    duration: Duration(seconds: 1),
                                    animationDuration: Duration(milliseconds: 10),
                                    forwardAnimationCurve: Curves.ease,
                                    messageText: Text(
                                        'Service ID has been copied',
                                        style:
                                            TextStyle(color: Colors.white))));
                          },
                          ),
                          Container(
                              color:Colors.grey.withOpacity(.5),
                              height: 1,
                              width: double.infinity)
                        ])),
                      
                      ListSeparated(
                          text: widget.product['contract_title'],
                          title: 'Contract Title'),
                      ListSeparated(
                          text: '${widget.product['contract_type'].toUpperCase()} CONTRACT',
                          title: 'Contract Type'),
                      ListSeparated(
                          text: 'NGN ${(widget.product['downpayment'].toString())}',
                          title: 'Downpayment'),
                      ListSeparated(
                          text: widget.product['delivery_duration'],
                          title: 'Delivers In', isLast: true,),
                  SizedBox(height: 20),],)),
          Container(
            margin: EdgeInsets.only(top: 10),
                  decoration: ContainerDecoration(),

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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListItemSeparated(title: stages[stages.keys.toList()[index]]['about_stage'], text: formatAmount('${stages[stages.keys.toList()[index]]['cost_of_stage']}')),
                      );
                    },
                  ),
                ],
              ),        
              ),
                  SizedBox(height: 20),
                  Container(
                  decoration: ContainerDecoration(),
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
        ),
      )
    );
  }
}