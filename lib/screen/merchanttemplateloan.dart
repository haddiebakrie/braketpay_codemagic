import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

import '../uix/listitemseparated.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class MerchantLoanDetail extends StatefulWidget {
  const MerchantLoanDetail({ Key? key, required this.loan}) : super(key: key);

  
  final Map loan;
  
  @override
  State<MerchantLoanDetail> createState() => _MerchantLoanDetailState();
}

class _MerchantLoanDetailState extends State<MerchantLoanDetail> {
  @override
  Widget build(BuildContext context) {
            List<dynamic> ld = jsonDecode(utf8.decode(hex.decode(widget.loan['loan_picture'])));
            List<int> image = ld.map((s) => s as int).toList(); 
    print(
      // decode(hex.decode(widget.loan['Payload']['loan_picture']))
    (image.length)
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
            Uint8List.fromList(image), height: 200,
          ),
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
                    ListItemSeparated(
                        text: widget.loan['loan_id'],
                        title: 'Loan ID'),
                    ListItemSeparated(
                        text: widget.loan['loan_title'],
                        title: 'Loan Title'),
                    ListItemSeparated(
                        text: 'LOAN CONTRACT',
                        title: 'Contract Type'),
                        ListTile(
                          subtitle: Text(widget.loan['loan_description'],),
                          title: Text('Loan Description'),
                        ),
                    // ListItemSeparated(
                    //     text: 
                    //     title: ),
                    ListItemSeparated(
                        text: toTitleCase(widget.loan['interest_rate'].toString()+'%'),
                        title: 'Interest Rate'),
                    ListItemSeparated(
                        text: toTitleCase(widget.loan['loan_type']),
                        title: 'Loan Type'),
                    ListItemSeparated(
                        text: toTitleCase(widget.loan['loan_period']),
                        title: 'Loan Peroid'),
                    ListItemSeparated(
                        text: formatAmount(widget.loan['loan_amount_range']['min'].toString()),
                        title: 'Minimum Loan Amount'),
                    ListItemSeparated(
                        text: formatAmount(widget.loan['loan_amount_range']['max'].toString()),
                        title: 'Maximum Loan Amount'),
                  ],
                )),
                SizedBox(height: 20),
                Container(
                decoration: ContainerDecoration(),
                    child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Loan QRCODE',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),),
                      Image.memory(
            Uint8List.fromList(hex.decode(widget.loan['loan_qr_code']??'')),
          ),
                  ])),
                   
        ],
        
        )),
      )
    );
  }
}