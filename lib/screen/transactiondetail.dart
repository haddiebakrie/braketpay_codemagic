import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import '../uix/themedcontainer.dart';

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
  ScreenshotController screenShotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text('Transaction Detail')),
        bottomSheet: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  width: double.infinity,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 23, 50, 255),
                    ),
                    child: TextButton(
                        child: const Text(
                          'Share',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await screenShotController.capture().then((value) 
                          async {
                            if (value != null) {
                              final directory = await getApplicationDocumentsDirectory();
                              final imagePath = await File('${directory.path}/${widget.transaction.payload!.receiptId}.png').create();
                              await imagePath.writeAsBytes(value);

                              /// Share Plugin
                              await Share.shareFiles([imagePath.path]);
                          }
                          }
                          );
                        })),
                  
                ),

            
        body: Screenshot(
          controller: screenShotController,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: ContainerBackgroundDecoration(),
            child: ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      // color: Colors.red,
                      width: double.infinity,
                      height: 600,
                      padding: const EdgeInsets.all(90),
                      child: Opacity(
                        opacity: 0.01,
                        child: Image.asset('assets/braket_logo.png', width: 120 , height: 120))),
                    Column(
                      children: [
                      //   Row(
                      //     children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(20.0),
                      //   child: Text("${widget.transaction.payload!.formatAmount()}", style: TextStyle(fontSize: 40),),
                      // ),
                      //     ],
                      //   ),
                      Image.asset('assets/braket-full-01.png', width:90),
                    Container(
                      // margin: const EdgeInsets.all(5),
                      width: double.infinity,
                      child: Text("Receipt ID: ${widget.transaction.payload!.receiptId}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold),)),
                    SizedBox(height:20),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Transaction Date", style: TextStyle(fontWeight: FontWeight.w600,)), 
                              Flexible(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(widget.transaction.payload!.dateMade(), style: const TextStyle(fontFamily: '',), textAlign: TextAlign.end,),
                            Text(widget.transaction.payload!.timeMade(), style: TextStyle(color: Colors.grey), textAlign: TextAlign.end,)
                                ],
                              )),
                      
                            ]),
                        ),
                        Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                    //   child: Column(
                    //     children: [
                    //     ListTile(minVerticalPadding: 0, minLeadingWidth: 0, contentPadding: EdgeInsets.zero, title: const Text('Amount'), trailing: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       crossAxisAlignment: CrossAxisAlignment.end,
                    //       children: [
                    //         Text(widget.transaction.payload!.formatAmount(), style: const TextStyle(fontFamily: '')),
                    //         Text('charges: ${formatAmount(widget.transaction.payload!.transactionFee.toString())}', style: TextStyle(color: Colors.grey))
                    //       ],
                    //     )),
                    //     Container(color: Colors.grey, height: 1, width: double.infinity)
                    //     ] 
                    //   ) 
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Amount", style: TextStyle(fontWeight: FontWeight.w600,)), 
                              Flexible(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(widget.transaction.payload!.formatAmount(), style: const TextStyle(fontFamily: '',), textAlign: TextAlign.end,),
                            Text('charges: ${formatAmount(widget.transaction.payload!.transactionFee.toString())}', style: TextStyle(color: Colors.grey), textAlign: TextAlign.end,)
                                ],
                              )),
                      
                            ]),
                        ),
                        Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Sender's Account", style: TextStyle(fontWeight: FontWeight.w600,)), 
                              Flexible(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(widget.transaction.payload!.senderAccountNumber == '00-00-00-00-00' ? widget.transaction.payload!.transactionType!.split('>').last.toUpperCase() : widget.transaction.payload!.senderAccountNumber??'', style: const TextStyle(fontFamily: '',), textAlign: TextAlign.end,),
                            widget.transaction.payload!.senderAccountNumber != widget.user.payload!.accountNumber ?
                            Text(widget.transaction.payload!.receivingBank??"${widget.transaction.payload!.transactionType}".split('>')[0], style: TextStyle(color: Colors.grey),)
                            : Text('BraketPay', style: TextStyle(color: Colors.grey),)
                                ],
                              )),
                      
                            ]),
                        ),
                        Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Sender's Name", style: TextStyle(fontWeight: FontWeight.w600,)), 
                              Flexible(child: Text("${widget.transaction.payload!.senderName}", textAlign: TextAlign.end,)),
                      
                            ]),
                        ),
                        Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Receiver's Name", style: TextStyle(fontWeight: FontWeight.w600,)), 
                              Flexible(child: Text("${widget.transaction.payload!.receiverName}", textAlign: TextAlign.end,)),
                      
                            ]),
                        ),
                        Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Receiver's Account", style: TextStyle(fontWeight: FontWeight.w600,)), 
                              Flexible(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(widget.transaction.payload!.receiverAccountNumber == '00-00-00-00-00' ? widget.transaction.payload!.transactionType!.split('>').last.toUpperCase() : widget.transaction.payload!.receiverAccountNumber??'', style: const TextStyle(fontFamily: '',), textAlign: TextAlign.end,),
                            widget.transaction.payload!.receiverAccountNumber != widget.user.payload!.accountNumber ?
                            Text(widget.transaction.payload!.receivingBank??"${widget.transaction.payload!.transactionType}".split('>')[0], style: TextStyle(color: Colors.grey),)
                            : Text('BraketPay', style: TextStyle(color: Colors.grey),)
                                ],
                              )),
                      
                            ]),
                        ),
                        Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),
                    
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        // ListTile(minVerticalPadding: 0, minLeadingWidth: 0, contentPadding: EdgeInsets.zero, title: Text("Narration"), trailing: Text("${widget.transaction.payload!.narration}")),
                        // Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Narration", style: TextStyle(fontWeight: FontWeight.w600,)), 
                              Flexible(child: Text("${widget.transaction.payload!.narration}".split('>')[0].toUpperCase(), textAlign: TextAlign.end,)),
                      
                            ]),
                        ),
                        Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.w600,)), 
                              Flexible(child: Text("${widget.transaction.payload!.transactionType}".split('>')[0].toUpperCase(), textAlign: TextAlign.end,)),
                      
                            ]),
                        ),
                        Container(color: Colors.grey, height: 1, width: double.infinity)
                        ] 
                      ) 
                    ),
                    
                    const SizedBox(height: 10),
                    Text('Paid with Braket', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 80)
                      ]
                    ),
                  ],
                ),
              ],
            )
          ),
        )
        );}
                      
}
