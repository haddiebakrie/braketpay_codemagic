import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:braketpay/api_callers/loan.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/uix/askpin.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/api_callers/contracts.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../uix/themedcontainer.dart';



class LoanDetail extends StatefulWidget {
  const LoanDetail({Key? key, required this.contract, required this.pin, required this.user}) : super(key: key);


  final ProductContract contract;
  final String pin;
  final User user;


  @override
  State<LoanDetail> createState() => _LoanDetailState();
}

class _LoanDetailState extends State<LoanDetail> {
  Brakey brakey = Get.put(Brakey());
  Map  contractStateMap = {
    'open' : {'color' : Colors.orange, 'comment' : 'This contract is still active'},
    'closed' :{'color' : Colors.green, 'comment' : 'This contract has been terminated'},
    'terminated' :{'color' : Colors.red, 'comment' : 'This contract has been terminated'},
    'rejected' :{'color' : Colors.red, 'comment' : 'This contract has been terminated'},
    'declined' :{'color' : Colors.red, 'comment' : 'This contract has been terminated'},
  };


  @override
  Widget build(BuildContext context) {
  int contractStateIndex = widget.contract.payload!.states!.approvalState?.toLowerCase() == 'rejected' ? 2 :
                                widget.contract.payload!.states!.approvalState?.toLowerCase() == 'approved' ? 1 : 0;
  
  Map stages = widget.contract.payload!.privilledges!.loanStages == null ? {} : jsonDecode(jsonDecode(widget.contract.payload!.privilledges!.loanStages!));
  Map status = widget.contract.payload!.privilledges!.borrowerRepayment == null ? {} : jsonDecode(jsonDecode(widget.contract.payload!.privilledges!.borrowerRepayment!));
  print(widget.contract.payload!.toJson());
    final PageController _controller = PageController();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        // title: Text(widget.contract.isProvider(widget.user.payload!.walletAddress??'').toString() ?? '', style: TextStyle(fontSize:6))
      ),

      bottomSheet: widget.contract.payload!.states!.approvalState ==
                'Rejected' || widget.contract.payload!.states!.closingState == 'Closed'
            ? SizedBox(
                height: 70,
                child:
                    const Center(child: Text('This contract has been closed')))
            : !widget.contract
                    .isContractCreator(widget.user.payload!.walletAddress ?? '')
                ? SizedBox(
                height: 70,)
                : Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: widget.contract
                            .isProvider(widget.user.payload!.walletAddress ?? '')
                        ? 
                        widget.contract.payload!.states!.confirmationState ==
                                'Not confirmed'
                            ? 
                            SizedBox(
                              height: 70,
                              child:
                                  Row(children: [
                            Expanded(
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 255, 48, 48),
                                    ),
                                    child: TextButton(
                                        child: const Text(
                                          'Reject',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          terminateLoan();
                                        }))),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 0, 168, 50),
                                    ),
                                    child: TextButton(
                                        child: Text(
                                          'Accept Loan',
                                          style: TextStyle(color: Colors.white)
                                        ),
                                        onPressed: () {
                                          confirmLoan();
                                        }))),
                          ]))
                            :
                        SizedBox(
                height: 70,)
                        :  SizedBox(
                height: 70,)),
     
      body: Container(
        decoration: ContainerBackgroundDecoration(),
          child: ListView(
                children: [
                  Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.only(bottom: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                              width: 60,
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                    ),
                  Text(widget.contract.payload!.terms!.contractTitle ?? '', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold )),
                  Text("Created on: ${widget.contract.dateCreated()}", style: const TextStyle(fontSize: 14, color: Colors.blueGrey) ),
                  Text("ID: ${widget.contract.payload!.contractID}", style: const TextStyle(fontSize: 14, color: Colors.blueGrey) ),
                  
                  SizedBox(height:20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Contract State', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),

                        ],
                      ),
                      IconStepper(
                        enableNextPreviousButtons: false,
                        enableStepTapping: false,
                        steppingEnabled: false,
                        lineColor: Colors.grey,
                        stepColor: Colors.transparent,
                        activeStepBorderColor: Colors.transparent,
                        activeStepColor: Colors.transparent,
                        stepRadius: 25,
                        activeStep: contractStateIndex == 0 || contractStateIndex == 1 ?
                        0 : contractStateIndex == 2 || contractStateIndex == 3 ? 1 : 3,
                        icons: [
                        Icon(CupertinoIcons.person_crop_circle_badge_checkmark, color: contractStateIndex == 1 || contractStateIndex >= 3 ? Colors.green.shade400 : contractStateIndex == 2 ? Colors.red : Colors.grey,),
                        Icon(Icons.category_sharp, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 4 ? Colors.red : Colors.grey),
                        Icon(Icons.handshake, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 6 ? Colors.red : Colors.grey),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(),
                          // SizedBox(),
                          Text(contractStateIndex == 2 ? 'Rejected' : 'Accepted', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex >= 3 || contractStateIndex == 1  ? Colors.green.shade400 : contractStateIndex == 2 ? Colors.red : Colors.grey,)),
                          const SizedBox(),
                          Text(contractStateIndex == 4 ? '     Terminated' : '    Paid', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 4 ? Colors.red : Colors.grey)),
                          const SizedBox(),
                          Text('Completed', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 6 ? Colors.red : Colors.grey)),
                          const SizedBox(),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height:20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Parties', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                      SizedBox(height:10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        const Text('Borrower'),
                        Text(
                          '${widget.contract.payload!.parties!.borrowerName}',
                        ),

                        ],
                      ),
                      ListTile(
                        minLeadingWidth: 0,
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        title: const Text('Lender'),
                        trailing:  Text(
                          '${widget.contract.payload!.parties!.lenderName}',
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height:20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Terms', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                      const SizedBox(height:10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Loan Amount'),
                            Text(formatAmount(widget.contract.payload?.terms?.loanAmount??''))
                          ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Amount Paid'),
                            Text(formatAmount(widget.contract.payload?.terms?.balance??''))
                          ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Amount Left'),
                            Text(formatAmount(widget.contract.payload?.terms?.paymentLeft??''))
                          ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Period'),
                            Text(widget.contract.payload!.terms!.loanPeriod!.toString())
                          ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Interest rate'),
                            Text(widget.contract.payload!.terms!.interestRate!.toString() +'%')
                          ]
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w500)),
                      //       // Text(formatAmount(widget.contract.totalAmount()), style: const TextStyle(fontWeight: FontWeight.w500))
                      //     ]
                      //   ),
                      // )
                    ]  
                      ),
                      SizedBox(height:20),
                        Visibility(
                          visible: !widget.contract.isProvider(brakey.user.value!.payload!.walletAddress??''),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Stages', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                              ListView.builder(
                                
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: stages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    minVerticalPadding: 5,
                                    isThreeLine: false,
                                    minLeadingWidth: 0,
                                    contentPadding: EdgeInsets.zero,
                                    // trailing: widget.contract.payload!.terms!.stagesAchieved! > index ? Text('Done') : Text('Pending'),
                                    title: Text(stages[stages.keys.elementAt(index)]['use_of_funds']),
                                    // subtitle: Text(formatAmount(stages[stages.keys.elementAt(index)]['cost_of_stage'].toString()
                                    // )),
                                    
                                    // style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Container(
                        //       color: ThemedBackgroundColor,
                        //       margin: EdgeInsets.all(10),
                        //       child: Row(children: [
                        //         Icon(Icons.timelapse_rounded, color: Theme.of(context).primaryColor),
                        //         Padding(padding: EdgeInsets.all(8),child: Text('Repayment status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                        //       ],),
                        //     ),
                        //     Container(margin: EdgeInsets.symmetric(horizontal: 40), child: 
                        //     ListView.builder(
                        //       physics: NeverScrollableScrollPhysics(),
                        //       shrinkWrap: true,
                        //       itemCount: status.length,
                        //       itemBuilder: (BuildContext context, int index) {
                        //         return ListTile(
                        //           contentPadding: EdgeInsets.zero,
                        //           // trailing: widget.contract.payload!.terms!.stagesAchieved! > index ? Text('Done') : Text('Pending'),
                        //           title: Text(formatAmount(status['amount']?.toString()??'')),
                        //           trailing: Text(status['date_paid']??'No Date'
                        //           ),
                                  
                        //           // style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),),
                        //         );
                        //       },
                        //     )),
                        //   ],
                        // ),
                       
                      ]
                    ),
                  ),
                ],
              )
            

    ));
  }


  approveContract() async {
    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
  final _pinEditController = TextEditingController();
    Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
    if (pin == null || !pin.containsKey('pin')) {
      return;
    };
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
                            pin['pin'],
                            widget.contract.payload!.contractID ?? '',
                            widget.user.payload!.publicKey ?? '',
                            'service',
                            'approve',
                            "approval_code");
                        // Navigator.of(context).pop();
                        if (a.containsKey('Status')) {
                          if (a['Status'] == 'successful' || a['Status'] == 'successfull' || a['Status'] == 'pass') {
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
                                            brakey.refreshUserDetail();
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
                                      content: Text(toTitleCase(a['Message'])));
                                });
                          }
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
                                      content: Text(toTitleCase(a['Message'])));
                                });
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

  rejectContract() async {
    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
  final _pinEditController = TextEditingController();
    Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
    if (pin == null || !pin.containsKey('pin')) {
      return;
    };
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
                            pin['pin'],
                            widget.contract.payload!.contractID ?? '',
                            widget.user.payload!.publicKey ?? '',
                            'service',
                            'reject',
                            "approval_code");
                        // Navigator.of(context).pop();
                        if (a.containsKey('Status')) {
                          if (a['Status'] == 'successful' || a['Status'] == 'successfull' || a['Status'] == 'pass') {
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
                                            brakey.refreshUserDetail();

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
                                      content: Text(toTitleCase(a['Message'])));
                                });
                          }
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
                                      content: Text(toTitleCase(a['Message'])));
                                });
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
                
              ],
              title: const Text("Are you sure?"),
              content: const Text('This action cannot be reversed.'));
        });
  }

  confirmLoan() async {
    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
  final _pinEditController = TextEditingController();
    Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
    if (pin == null || !pin.containsKey('pin')) {
      return;
    };
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
                                                    "Confirming Loan"),
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
                                        Map a = await loanAction(
                                            pin['pin'],
                                            widget.contract.payload!
                                                    .contractID ??
                                                '',
                                                widget.contract.payload!.parties!.lenderBizID??'',
                                                widget.user.payload!.walletAddress??'',
                                            'confirm',
                                            );
                                        // Navigator.of(context).pop();
                                        if (a.containsKey('Status')) {
                                          if (a['Status'] == 'successful' || a['Status'] == 'successfull' || a['Status'] == 'pass') {
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
                                            brakey.refreshUserDetail();

                                                                
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Confirm successful"),
                                                      content: Text(
                                                          toTitleCase(a['Message'])));
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
                                                          Text(toTitleCase(a['Message'])));
                                                });
                                          }
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
                                      title: const Text("Confirm failed"),
                                      content: Text(toTitleCase(a['Message'])));
                                });
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
                              content: Text(
                                  'The Loan amount ${widget.contract.payload!.terms!.loanAmount} Naira would be deducted from your account and sent to Braket Vault.'));
                        });

  }
terminateLoan() async {
    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
  final _pinEditController = TextEditingController();
    Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
    if (pin == null || !pin.containsKey('pin')) {
      return;
    };
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
                                    child: const Text('Ok, reject'),
                                    onPressed: () async {
                                      // Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (loading) {
                                            return AlertDialog(
                                                title: const Text(
                                                    "Rejecting Loan"),
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
                                        Map a = await loanAction(
                                            pin['pin'],
                                            widget.contract.payload!
                                                    .contractID ??
                                                '',
                                                widget.contract.payload!.parties!.lenderBizID??'',
                                                widget.user.payload!.walletAddress??'',
                                            'reject',
                                            );
                                        // Navigator.of(context).pop();
                                        if (a.containsKey('Status')) {
                                          if (a['Status'] == 'successful' || a['Status'] == 'successfull' || a['Status'] == 'pass') {
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
                                            brakey.refreshUserDetail();

                                                                
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Reject successful"),
                                                      content: Text(
                                                          toTitleCase(a['Message'])));
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
                                                          "Reject failed"),
                                                      content:
                                                          Text(toTitleCase(a['Message'])));
                                                });
                                          }
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
                                      content: Text(toTitleCase(a['Message'])));
                                });
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
                              content: Text(
                                  'This Loan contract would be Rejected.'));
                        });

  }
providerTerminateContract() async {
  StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
  final _pinEditController = TextEditingController();
    Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
    if (pin == null || !pin.containsKey('pin')) {
      return;
    };
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
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
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
                                                    "Terminate contract"),
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
                                            pin['pin'],
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
                                          if (a['Status'] == 'successful' || a['Status'] == 'successfull' || a['Status'] == 'pass') {
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
                                                                brakey.refreshUserDetail();
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
                                                          Text(toTitleCase(a['Message'] ?? a['essage'])));
                                                });
                                          }
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
                                      content: Text(toTitleCase(a['Message'])));
                                });
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