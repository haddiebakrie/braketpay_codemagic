import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

import '../uix/listitemseparated.dart';
import '../utils.dart';

class MerchantProductDetail extends StatefulWidget {
  const MerchantProductDetail({ Key? key, required this.product}) : super(key: key);

  
  final Map product;
  
  @override
  State<MerchantProductDetail> createState() => _MerchantProductDetailState();
}

class _MerchantProductDetailState extends State<MerchantProductDetail> {
  @override
  Widget build(BuildContext context) {
            List<dynamic> ld = jsonDecode(utf8.decode(hex.decode(widget.product['Payload']['product_picture'])));
            List<int> image = ld.map((s) => s as int).toList(); 
    print(
      // decode(hex.decode(widget.product['Payload']['product_picture']))
    (image.length)
    );
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
          Image.memory(
            Uint8List.fromList(image)
          ),
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
                        text: widget.product['Payload']['contract_title'],
                        title: 'Contract Title'),
                    ListItemSeparated(
                        text: '${widget.product['Payload']['contract_type'].toUpperCase()} CONTRACT',
                        title: 'Contract Type'),
                    ListItemSeparated(
                        text: widget.product['Payload']['product_name'],
                        title: 'Product Name'),
                    ListItemSeparated(
                        text: widget.product['Payload']['product_details'],
                        title: 'Product Detail'),
                    ListItemSeparated(
                        text: 'NGN ${(widget.product['Payload']['product_amount'].toString())}',
                        title: 'Product Amount'),
                    ListItemSeparated(
                        text: widget.product['Payload']['minimum_delivery_date'],
                        title: 'Delivers In', isLast: true,),
                  ],
                )),
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
            !widget.product['Payload'].containsKey('about_service_delivery_stages') ? 
            Uint8List.fromList(hex.decode(widget.product['Payload']['product_qrcode']??'')) : 
            Uint8List.fromList(hex.decode(widget.product['Payload']['service_qrcode']??'')),
          ),
                  ])),
                   
        ],
        
        )),
      )
    );
  }
}