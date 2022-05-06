import 'dart:ui';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail(
      {Key? key, required this.transaction, required this.user})
      : super(key: key);

  final Transaction transaction;
  final User user;

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    return Scaffold(
            backgroundColor: Colors.deepOrange,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text('Receipt')),
        bottomSheet: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  width: double.infinity,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 23, 50, 255),
                    ),
                    child: TextButton(
                        child: Text(
                          'Share',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {

                        })),
                  
                ),

            
        body: SingleChildScrollView(child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.zero),
            color: Colors.white,
          ),
          child: Column(
            children: [
          SizedBox(height:20),
              Icon(Icons.check_circle, size: 40, color: Colors.green),
              Text('SUCCESSFUL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height:10),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text('Transaction Date'), trailing: Text(widget.transaction.payload!.dateMade())),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text('Amount'), trailing: Text("${widget.transaction.payload!.formatAmount()}", style: TextStyle(fontFamily: ''))),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical:0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text("Sender's Name"), trailing: Text("${widget.transaction.payload!.senderName}")),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
            Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text("Sender's Account"), trailing: Text("${widget.transaction.payload!.senderAccountNumber}")),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text("Receiver's Name"), trailing: Text("${widget.transaction.payload!.receiverName}")),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text("Receiver's Account"), trailing: Text("${widget.transaction.payload!.receiverAccountNumber}")),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text("Receiver's Bank"), trailing: Text("${widget.transaction.payload!.receivingBank}")),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text("Receipt ID"), trailing: Text("${widget.transaction.payload!.receiptId}")),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text("Narration"), trailing: Text("${widget.transaction.payload!.narration}")),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [
              ListTile(title: Text("Payment Method"), trailing: Text("${widget.transaction.payload!.transactionType}".toUpperCase().replaceAll('>', '-'))),
              Container(color: Colors.grey, height: 1, width: double.infinity)
              ] 
            ) 
          ),
          SizedBox(height: 10),
          Text('Paid with Braket'),
          SizedBox(height: 80)
            ]
          )
        ))
        );}
                      
}
