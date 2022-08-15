import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:braketpay/api_callers/loan.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/uix/askpin.dart';
import 'package:braketpay/uix/listitemseparated.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/api_callers/contracts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../uix/themedcontainer.dart';
import 'manager.dart';



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
                                widget.contract.payload!.states!.approvalState?.toLowerCase() == 'approved' ? 1 : 3;
  // print(widget.contract.payload!.states!.approvalState);
  contractStateIndex = widget.contract.payload!.states!.approvalState == 'Not approved' ? 0 : contractStateIndex;
  Map stages = widget.contract.payload!.privilledges!.loanStages??{};
  Map status = widget.contract.payload!.privilledges!.borrowerRepayment??{};
  List dates = widget.contract.payload!.terms!.duePaymentDates??[];
    final PageController _controller = PageController();
  print(dates);
  dates.forEach((e) {
    if (e.contains('due date unavailable')) {
      dates = [];
    }
  });
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Loan Detail')
      ),

      bottomSheet: 
      
      dates.isNotEmpty && !widget.contract
                    .isContractCreator(widget.user.payload!.walletAddress ?? '') ? 
        Container(
          padding: EdgeInsets.all(10),
          child: Container(
          height: 50,
          width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20)
              ),
            child: TextButton(
                child: const Text(
                  'Repay',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  repayLoan(widget.contract, brakey);
                }),
          ),
        )
      :
      
      widget.contract.payload!.states!.approvalState ==
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
     
      body: SingleChildScrollView(
        child: Column(
          children: [
            
              Padding(
                padding: const EdgeInsets.only(left:10.0, bottom: 20.0, right: 10),
                child: BlurryContainer(
                    blur: 10,
                      // width: double.infinity,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.2), borderRadius: BorderRadius.circular(20)),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Center(
                                child: Stack(
                                  children: [
                                  
                                    Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Text(
                                    "Repayment made",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white,fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(nairaSign()+(double.parse(widget.contract.payload?.privilledges?.totalRepayment??'0').toStringAsFixed(2)), style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto')),
                            FittedBox(child: Row(
                              children: [
                                // Icon(Icons.down)
                                Text('Balance left ' + nairaSign()+double.parse(widget.contract.payload?.terms?.paymentLeft??'0').toStringAsFixed(2), style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontWeight: FontWeight.w600)),
                              ],
                            )),
                            
                          ]),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
              ),
  
            Container(
              decoration: ContainerBackgroundDecoration(),
                child: Container(
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
                Row(
                  children: [
                    Text("${widget.contract.dateCreated()}", style: const TextStyle(fontSize: 10, color: Colors.blueGrey) ),
                Text(" ● ID: ${widget.contract.payload!.contractID}", style: const TextStyle(fontSize: 10, color: Colors.blueGrey) ),
                  ],
                ),
                
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
                        Text(contractStateIndex == 2 ? 'Rejected' : contractStateIndex == 0 ? 'Pending' : 'Confirmed', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex >= 3 || contractStateIndex == 1  ? Colors.green.shade400 : contractStateIndex == 2 ? Colors.red : Colors.orange,)),
                        const SizedBox(),
                        Text(contractStateIndex == 4 ? '     Terminated' : '    Approved', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 4 ? Colors.red : Colors.grey)),
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
                          Text(formatAmount(widget.contract.payload?.terms?.loanAmount.toString()??''))
                        ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Amount Paid'),
                          Text(formatAmount(widget.contract.payload?.privilledges?.totalRepayment??'0'))
                        ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Amount Left'),
                          Text(formatAmount(widget.contract.payload?.terms?.paymentLeft.toString()??'0'))
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
                    Visibility(
                      visible: widget.contract.payload!.terms!.nextDueDate != null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Next payment Due date'),
                            Text(widget.contract.payload!.terms!.nextDueDate == null ? '' :widget.contract.nextLoanDueDate().toString())
                          ]
                        ),
                      ),
                    ),
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
                            SizedBox(height: 10,),
                            ListView.builder(
                              
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: stages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(stages[stages.keys.elementAt(index)]['use_of_funds']),
                                      Container(margin: EdgeInsets.symmetric(vertical: 4), height: 1, color: Colors.grey.withOpacity(0.2),)
                                    ],
                                  ),
                                );
                               
                              },
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: status.isNotEmpty && status.length > 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // color: ThemedBackgroundColor,
                              // margin: EdgeInsets.all(10),
                              child: Row(children: [
                                // Icon(Icons.timelapse_rounded, color: Theme.of(context).primaryColor),
                                Text('Payment History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                              ],),
                            ),
                            Container(margin: EdgeInsets.symmetric(horizontal: 0), child: 
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: status.length,
                              itemBuilder: (BuildContext context, int index) {
                                List keys = status.keys.toList(); 
                                if (index == 0) {
                                  return SizedBox();
                                }
                                String date =  jsonDecode(status[keys.elementAt(index)])['date_paid'];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minLeadingWidth: 0,
                                  
                                  // trailing: widget.contract.payload!.terms!.stagesAchieved! > index ? Text('Done') : Text('Pending'),
                                  trailing: Text(formatAmount(jsonDecode(status[keys.elementAt(index)])['amount']?.toString()??'0')),
                                  title: Text(formatDate(DateTime.parse(date)).toString(),
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                                  
                                  // style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),),
                                );
                              },
                            )),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: dates.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
      
                          children: [
                            Container(
                              // color: ThemedBackgroundColor,
                              padding: EdgeInsets.only(top:10),
                              child: Row(children: [
                                // Icon(Icons.timelapse_rounded, color: Theme.of(context).primaryColor),
                                Text('Repayment Dates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                              ],),
                            ),
                            SizedBox(height: 10,),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dates.length,
                              itemBuilder: (BuildContext context, int index) {
                                
                                DateTime day = HttpDate.parse(dates[index]?.toString()??'');
                                return  Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                                          child: Column(
                                            children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical:15.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Term ${index+1}', style: TextStyle(fontWeight: FontWeight.w600,)), 
                                                  Flexible(child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(DateFormat('MMM, dd yyyy').format(day).toString(), style: const TextStyle(fontFamily: '',), textAlign: TextAlign.end,),
                                                Visibility(
                                                  visible: !widget.contract.isProvider(widget.user.payload!.walletAddress ?? ''),
                                                  child: Text(!widget.contract.isProvider(widget.user.payload!.walletAddress ?? '') ? nairaSign() + double.parse(widget.contract.payload?.terms?.monthlyPayment??'0').toStringAsFixed(2): '', style: TextStyle(color: Colors.grey), textAlign: TextAlign.end,))
                                                    ],
                                                  )),
                                          
                                                ]),
                                            ),
                                            // Container(color: Colors.grey, height: 1, width: double.infinity)
                                            ] 
                                          ) 
                                        );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                     
                    ]
                  ),
                )
                  
      
              ),
          ],
        ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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

void repayLoan(ProductContract loan, Brakey brakey) {
    final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  double amount = double.parse(double.parse(loan.payload?.terms?.monthlyPayment??'0').toStringAsFixed(2));
  List dates = loan.payload!.terms!.duePaymentDates??[];
  Get.bottomSheet(
        StatefulBuilder(
          builder: (context, changeState) {
            return BottomSheet(
              backgroundColor: Colors.transparent,
              onClosing: () {}, builder: (context) {
              return Container(
                padding: const EdgeInsets.all(20),
                  decoration: ContainerBackgroundDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10)),
      ),
      //   const Text(
      //   'Change transaction PIN',
      //   style: TextStyle(
      //       fontSize: 20, fontWeight: FontWeight.w300),
      // ),
      const SizedBox(height:15),
      Text('Choose payment amount', style: TextStyle(fontWeight: FontWeight.w600),),
      const SizedBox(height:30),
      ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dates.length,
                itemBuilder: (BuildContext context, int index) {
                  
                  DateTime day = HttpDate.parse(dates[index]?.toString()??'');
                  return  Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                            child: Column(
                              children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Term ${index+1}', style: TextStyle(fontWeight: FontWeight.w600,)), 
                                    Flexible(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(DateFormat('MMM, dd yyyy').format(day).toString(), style: const TextStyle(fontFamily: '',), textAlign: TextAlign.end,),
                                        Text(nairaSign() + double.parse(loan.payload?.terms?.monthlyPayment??'0').roundToDouble().toString(), style: TextStyle(color: Colors.grey), textAlign: TextAlign.end,)
                                      ],
                                    )),
                            
                                  ]),
                              ),
                              // Container(color: Colors.grey, height: 1, width: double.infinity)
                              ] 
                            ) 
                          );
                },
              ),
              SizedBox(height: 10),
               TextFormField(
                              cursorColor: Colors.grey,
                              maxLines: null,
                              keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                              helperText: "Current balance: ${formatAmount(brakey.user.value?.payload?.accountBalance.toString()??'0')}",
                                helperStyle: TextStyle(color: amount.toDouble() <=  brakey.user.value!.payload!.accountBalance! ? Colors.green : Colors.redAccent, fontWeight: FontWeight.w600 ),
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                hintText: 'Enter the amount manually\n',
                                hintStyle: TextStyle(
                                            fontWeight: FontWeight.w600),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              onChanged: (text) {
                                changeState(() {
                                  amount = text.trim() == '' ? 0 : double.parse(text.trim());
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty || double.parse(value) > brakey.user.value!.payload!.accountBalance!) {
                                  return 'Please enter an amount below ${formatAmount(brakey.user.value!.payload!.accountBalance.toString())}';
                                }
                              },
                            ),

      Container(
              padding: EdgeInsets.all(10),
              child: Container(
              height: 50,
              width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20)
                  ),
                child:  RoundedLoadingButton(
                    borderRadius: 10,
                    color: Colors.transparent,
                    elevation: 0,
                    controller: _loginButtonController,
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                        
                        StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                        final _pinEditController = TextEditingController();
                          Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
                          if (pin == null || !pin.containsKey('pin')) {
                            _loginButtonController.reset();
                            return;
                          }
                        // print('$username, $pin, $password');
                        Map a = await loanRepayment(
                          
                            loan.payload?.contractID??'',
                            brakey.user.value!.payload!.publicKey ?? '',
                            pin['pin'],
                            amount.toString(),
                            );
                        if (a['Status'] == 'successful') {
                          _loginButtonController.success();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                    actions: [
                                      TextButton(
                                        // 2204112769
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          Get.offUntil(MaterialPageRoute(
                                            builder: (_) => 
                                            Manager(user: brakey.user.value!, pin: brakey.pin.value)), (route) => false);
                                            // brakey.changeManagerIndex(3);
                                          brakey.refreshUserDetail();
                                          // brakey.managerIndex = Rxn(3);
                                        },
                                      )
                                    ],
                                    title: const Text("Successful!"),
                                    content: Text(
                                        'You have successfully paid ${amount} to ${loan.payload?.parties?.lenderName??''}.'));
                              });
                        } else {
                          _loginButtonController.reset();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          // Navigator.of(context).pop();
                                          // Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                    title: const Text("Can't make Payment!"),
                                    content: Text(a['Message']));
                              });

                              // {Message: {data: {destination.amount: {message: destination.amount must be greater than or equal to 100}}, error: bad_request, message: invalid request data, status: false}, Response code: 400, Status: failed}
                        }
                    },
                    child: Text('Pay ${formatAmount(amount.toString())}',
                        style: const TextStyle(fontFamily: 'Roboto'))),
              
              ),
            )
                    ],
                  )

              );
            });
          }
        )

      );
}