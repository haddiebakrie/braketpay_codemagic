import 'dart:convert';
import 'dart:ui';

import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/api_callers/contracts.dart';



class ServiceDetail extends StatefulWidget {
  const ServiceDetail({Key? key, required this.contract, required this.pin, required this.user}) : super(key: key);


  final ProductContract contract;
  final String pin;
  final User user;


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

      bottomSheet: widget.contract.payload!.states!.approvalState ==
                'Rejected' || widget.contract.payload!.states!.closingState == 'Closed'
            ? SizedBox(
                height: 70,
                child:
                    const Center(child: Text('This contract has been closed')))
            : !widget.contract
                    .isContractCreator(widget.user.payload!.walletAddress ?? '')
                ? Visibility(
                    visible: widget.contract.payload!.privilledges != null
                        ? true
                        : false,
                    child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: widget.contract.payload!.states!.approvalState ==
                                'Not approved'
                            ? Row(children: [
                                Expanded(
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 255, 48, 48),
                                        ),
                                        child: TextButton(
                                            child: const Text(
                                              'Reject',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              rejectContract();
                                            }))),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 0, 168, 50),
                                        ),
                                        child: TextButton(
                                            child: const Text(
                                              'Accept',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              approveContract();
                                            }))),
                              ])
                            : !widget.contract.isProvider(
                                    widget.user.payload!.walletAddress ?? '')
                                ? Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 48, 48),
                                            ),
                                            child: TextButton(
                                                child: const Text(
                                                  'Terminate',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  rejectContract();
                                                }))),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 0, 168, 50),
                                            ),
                                            child: TextButton(
                                                child: Text(
                                          'Confirm Phase ${int.parse("${widget.contract.payload!.terms!.stagesAchieved}")+1}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  confirmContract();
                                                }))),
                                  ])
                                : Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 48, 48),
                                            ),
                                            child: TextButton(
                                                child: const Text(
                                                  'Terminate',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  rejectContract();
                                                }))),
                                  ])))
                : Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: !widget.contract
                            .isProvider(widget.user.payload!.walletAddress ?? '')
                        ? 
                        widget.contract.payload!.states!.approvalState ==
                                'Not approved'
                            ? 
                            SizedBox(
                              height: 70,
                              child:
                                  Center(child: Text('This contract has not been approved by the ${widget.contract.isProvider(widget.user.payload!.fullname??'') ? "Provider" : "Client"}')))
                            :
                        Row(children: [
                            Expanded(
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 255, 48, 48),
                                    ),
                                    child: TextButton(
                                        child: const Text(
                                          'Terminate',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          rejectContract();
                                        }))),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 0, 168, 50),
                                    ),
                                    child: TextButton(
                                        child: Text(
                                          'Confirm Phase ${int.parse("${widget.contract.payload!.terms!.stagesAchieved}")+1}',
                                          style: TextStyle(color: Colors.white)
                                        ),
                                        onPressed: () {
                                          confirmContract();
                                        }))),
                          ])
                        : Row(children: [
                            Expanded(
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 255, 48, 48),
                                    ),
                                    child: TextButton(
                                        child: const Text(
                                          'Terminate',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          rejectContract();
                                        }))),
                          ])),
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


  approveContract() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: const Text('Ok, approve'),
                    onPressed: () async {
                      print('Clicked');
                      // Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                                title: const Text("Approving contract"),
                                content: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                    Text('Please wait...'),
                                  ],
                                ));
                          });
                      // print(widget.contract.payload!.privilledges!.toJson());
                      try {
                        Map a = await contractAction(
                            widget.contract.payload!.privilledges!
                                    .approvalCode ??
                                '',
                            widget.pin,
                            widget.contract.payload!.contractID ?? '',
                            widget.user.payload!.publicKey ?? '',
                            'service',
                            'approve',
                            "approval_code");
                        // Navigator.of(context).pop();
                        if (a.containsKey('Status')) {
                          if (a['Status'] == 'successful') {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                      actions: [
                                        TextButton(
                                          child: const Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                      title: const Text("Approve successful"),
                                      content: const Text(
                                          'This contract has been approved'));
                                });
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                      actions: [
                                        TextButton(
                                          child: const Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                      title: const Text("Approve failed"),
                                      content: Text(a['Message']));
                                });
                          }
                        }
                      } catch (e) {
                        print('Error: $e');
                        // Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (error) {
                              return AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: const Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(error).pop();
                                        Navigator.of(error).pop();
                                        Navigator.of(error).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("No internet access!"),
                                  content: const Text(
                                      'Make sure you are connected to the internet and try again'));
                            });
                      }
                    })
                // )
              ],
              title: const Text("Are you sure?"),
              content: const Text(
                  'Make sure you check the contract detail carefully before approving the contract.'));
        });
  }

  rejectContract() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                
                TextButton(
                    child: const Text('Ok, reject'),
                    onPressed: () async {
                      // Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (loading) {
                            return AlertDialog(
                                title: const Text("Rejecting contract"),
                                content: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                    Text('Please wait...'),
                                  ],
                                ));
                          });
                      // print(widget.contract.payload!.privilledges!.toJson());
                      try {
                        Map a = await contractAction(
                            widget.contract.payload!.privilledges!
                                    .approvalCode ??
                                '',
                            widget.pin,
                            widget.contract.payload!.contractID ?? '',
                            widget.user.payload!.publicKey ?? '',
                            'product',
                            'reject',
                            "approval_code");
                        // Navigator.of(context).pop();
                        if (a.containsKey('Status')) {
                          if (a['Status'] == 'successful') {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                      actions: [
                                        TextButton(
                                          child: const Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                      title: const Text("Reject successful"),
                                      content: const Text(
                                          'This contract has been rejected'));
                                });
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                      actions: [
                                        TextButton(
                                          child: const Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                      title: const Text("Reject failed"),
                                      content: Text(a['Message']));
                                });
                          }
                        }
                      } catch (e) {
                        print('Error: $e');
                        // Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (error) {
                              return AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: const Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(error).pop();
                                        Navigator.of(error).pop();
                                        Navigator.of(error).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("No internet access!"),
                                  content: const Text(
                                      'Make sure you are connected to the internet and try again'));
                            });
                      }
                    }),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              title: const Text("Are you sure?"),
              content: const Text('This action cannot be reversed.'));
        });
  }

  confirmContract() {
    String code = '';
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                    child: const Text('Ok, confirm'),
                                    onPressed: () async {
                                      // Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (loading) {
                                            return AlertDialog(
                                                title: const Text(
                                                    "Confirming contract"),
                                                content: Row(
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(15.0),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    Text('Please wait...'),
                                                  ],
                                                ));
                                          });
                                      // print(widget
                                      //     .contract.payload!.privilledges!
                                      //     .toJson());
                                      try {
                                        Map a = await contractAction(
                                            widget.contract.payload!.privilledges!.confirmationCode ?? '',
                                            widget.pin,
                                            widget.contract.payload!
                                                    .contractID ??
                                                '',
                                            widget.user.payload!.publicKey ??
                                                '',
                                            'service',
                                            'confirm',
                                            "confirmation_code");
                                        // Navigator.of(context).pop();
                                        if (a.containsKey('Status')) {
                                          if (a['Status'] == 'successful') {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                              'Okay'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Confirm successful"),
                                                      content: Text(
                                                          a['Message']));
                                                });
                                          } else {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                              'Okay'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Confirm failed"),
                                                      content:
                                                          Text(a['Message']));
                                                });
                                          }
                                        }
                                      } catch (e) {
                                        print('Error: $e');
                                        // Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (error) {
                                              return AlertDialog(
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('Okay'),
                                                      onPressed: () {
                                                        Navigator.of(error)
                                                            .pop();
                                                        Navigator.of(error)
                                                            .pop();
                                                        Navigator.of(error)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                  title: const Text(
                                                      "No internet access!"),
                                                  content: const Text(
                                                      'Make sure you are connected to the internet and try again'));
                                            });
                                      }
                                    })
                                // )
                              ],
                              title: const Text("Are you sure?"),
                              content: const Text(
                                  'Make sure this phase has been completed.'));
                        });

  }
  buyerRejectContract() {
    String code = '';
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (confirm) {
          return AlertDialog(
              title: const Text("Enter Termination code"),
              content: TextFormField(
                onChanged: (text) {
                  code = text;
                },
              ),
              actions: [
                TextButton(
                  child: const Text('Terminate Contract'),
                  onPressed: () {
                    Navigator.of(confirm).pop();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                
                                TextButton(
                                    child: const Text('Ok, Terminate'),
                                    onPressed: () async {
                                      // Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (loading) {
                                            return AlertDialog(
                                                title: const Text(
                                                    "Rejecting contract"),
                                                content: Row(
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(15.0),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    Text('Please wait...'),
                                                  ],
                                                ));
                                          });
                                      // print(widget
                                      //     .contract.payload!.privilledges!
                                      //     .toJson());
                                      try {
                                        Map a = await contractAction(
                                            code,
                                            widget.pin,
                                            widget.contract.payload!
                                                    .contractID ??
                                                '',
                                            widget.user.payload!.publicKey ??
                                                '',
                                            'service',
                                            'terminate',
                                            "termination_code");
                                        // Navigator.of(context).pop();
                                        if (a.containsKey('Status')) {
                                          if (a['Status'] == 'successful') {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                              'Okay'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Terminate successful"),
                                                      content: const Text(
                                                          'This contract has been Terminated'));
                                                });
                                          } else {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                              'Okay'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Terminate failed"),
                                                      content:
                                                          Text(a['Message'] ?? a['essage']));
                                                });
                                          }
                                        }
                                      } catch (e) {
                                        print('Error: $e');
                                        // Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (error) {
                                              return AlertDialog(
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('Okay'),
                                                      onPressed: () {
                                                        Navigator.of(error)
                                                            .pop();
                                                        Navigator.of(error)
                                                            .pop();
                                                        Navigator.of(error)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                  title: const Text(
                                                      "No internet access!"),
                                                  content: const Text(
                                                      'Make sure you are connected to the internet and try again'));
                                            });
                                      }
                                    }),
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              title: const Text("Are you sure?"),
                              content: const Text(
                                  'This action cannot be reveresed.'));
                        });
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(confirm).pop();
                  },
                )
              ]);
        });
  }


}