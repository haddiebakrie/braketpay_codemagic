import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/uix/askpin.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/api_callers/contracts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:im_stepper/stepper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../uix/themedcontainer.dart';



class ServiceDetail extends StatefulWidget {
  const ServiceDetail({Key? key, required this.contract, required this.pin, required this.user}) : super(key: key);


  final ProductContract contract;
  final String pin;
  final User user;


  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
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
  
  contractStateIndex = widget.contract.payload!.states!.confirmationState?.toLowerCase() == 'confirmed' ? 3 :
  widget.contract.payload!.states!.closingState?.toLowerCase() == 'terminated' ? 4 : contractStateIndex; 
    
  Map stages = jsonDecode(widget.contract.payload!.terms!.aboutStages!);
    final PageController _controller = PageController();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
            title: Text("Service Detail"),
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
                                                  clientTerminateContract();
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
                                                  providerTerminateContract();
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
                                          clientTerminateContract();
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
                        height: 100,
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
                                    "Contract Balance",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white,fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(nairaSign()+(widget.contract.payload?.terms?.stageCompletionPayment ??'0'), style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto')),
                            
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
      
                            Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical:2),
                              color: contractStateMap[widget.contract.payload!.states!.closingState?.toLowerCase()]?['color'].shade50?? Colors.grey.shade50,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, size: 10, 
                              color: contractStateMap[widget.contract.payload!.states!.closingState?.toLowerCase()]?['color']??Colors.grey,
                                  
                                  ),
                                  const SizedBox(width: 2),
                                  Text(widget.contract.payload?.states?.closingState??'', style: TextStyle(
                              color: contractStateMap[widget.contract.payload!.states!.closingState?.toLowerCase()]?['color']??Colors.grey,
                                fontWeight: FontWeight.bold
                                  ),)
                                ],
                              ),
                            )
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
                          Icon(Icons.handyman, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 4 ? Colors.red : Colors.grey),
                          Icon(Icons.handshake, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 6 ? Colors.red : Colors.grey),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(),
                            // SizedBox(),
                            Text(contractStateIndex == 2 ? 'Rejected' : 'Accepted', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex >= 3 || contractStateIndex == 1  ? Colors.green.shade400 : contractStateIndex == 2 ? Colors.red : Colors.grey,)),
                            const SizedBox(),
                            Text(contractStateIndex == 4 ? '     Terminated' : '    In progress', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 4 ? Colors.red : Colors.grey)),
                            const SizedBox(),
                            Text('Completed', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 6 ? Colors.red : Colors.grey)),
                            const SizedBox(),
                          ],
                        )
                      ],
                    ),
                    
      
                    const SizedBox(height: 20,),
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
                              const Text('Number of stages'),
                              Text(widget.contract.payload?.terms?.numberOfServiceStages?.toString()??'')
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Stages completed'),
                              Text(widget.contract.payload?.terms?.stagesAchieved.toString()??'')
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Amount Paid'),
                              Text(formatAmount(widget.contract.payload?.terms?.stageCompletionPayment??''))
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Downpayment'),
                              Text(formatAmount(widget.contract.payload?.terms?.downpayment??''))
                            ]
                          ),
                        ),
                      ]  
                        ),
                        SizedBox(height: 20),                 
                      Column(
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
                                contentPadding: EdgeInsets.zero,
                                minVerticalPadding: 5,
                                isThreeLine: false,
                                minLeadingWidth: 0,
                                trailing: widget.contract.payload!.terms!.stagesAchieved! > index ? Text('Done') : Text('Pending'),
                                title: Text(stages[stages.keys.elementAt(index)]['about_stage']),
                                subtitle: Text(formatAmount(stages[stages.keys.elementAt(index)]['cost_of_stage'].toString()),
                                
                                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),),
                              );
                            },
                          ),
                          Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text(formatAmount(widget.contract.payload!.terms!.totalServiceAmount??''), style: const TextStyle(fontWeight: FontWeight.w500))
                            ]
                          ),
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
                        ListTile(
                          minLeadingWidth: 0,
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          title: const Text('Contract creator'),
                          trailing: Text(
                            '${widget.contract.payload!.parties!.contractCreator}',
                            style: const TextStyle(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          const Text('Client'),
                          Text(
                            '${widget.contract.payload!.parties!.clientName}',
                          ),
      
                          ],
                        ),
                        ListTile(
                          minLeadingWidth: 0,
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          title: const Text('Provider'),
                          trailing:  Text(
                            '${widget.contract.payload!.parties!.providersName}',
                          ),
                        ),
                      ],
                    ),
      
                    const SizedBox(height: 20),
      
                    Visibility(
                      visible: !widget.contract.isProvider(widget.user.payload!.walletAddress ?? ''),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Activation Codes', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: InkWell(
                                 onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.contract.payload!.privilledges?.confirmationCode));
                                    Get.showSnackbar(const GetSnackBar(
                                        duration: Duration(seconds: 1),
                                        animationDuration: Duration(milliseconds: 10),
                                        forwardAnimationCurve: Curves.ease,
                                        messageText: Text(
                                            'Confirmation code has been copied',
                                            style:
                                                TextStyle(color: Colors.white))));
                                },
                                  child: Container(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                      // margin: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.green.shade50
                                                      ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.green.shade600)
                                                      ),
                                                      padding: const EdgeInsets.all(10),
                                                      child: Text(
                                                        '${widget.contract.payload!.privilledges?.confirmationCode}',
                                                        style: TextStyle(fontSize: 25, color: Colors.green.shade600),
                                                      ),
                                                    ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Icon(IconlyBold.paper,
                                                      size: 20,
                                                      color: Colors.green.shade600),
                                                      Text('copy', style: TextStyle(color: Colors.green.shade600),)
                                              ],
                                            ),
                                          )
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Confirmation Code'
                                                
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                          Expanded(
                            child: InkWell(
                                 onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.contract.payload!.privilledges?.terminationCode));
                                    Get.showSnackbar(const GetSnackBar(
                                        duration: Duration(seconds: 1),
                                        animationDuration: Duration(milliseconds: 10),
                                        forwardAnimationCurve: Curves.ease,
                                        messageText: Text(
                                            'Termination code has been copied',
                                            style:
                                                TextStyle(color: Colors.white))));
                                },
                                  child: Container(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                      // margin: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.red.shade50
                                                      ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.red.shade600)
                                                      ),
                                                      padding: const EdgeInsets.all(10),
                                                      child: Text(
                                                        '${widget.contract.payload!.privilledges?.terminationCode}',
                                                        style: TextStyle(fontSize: 25, color: Colors.red.shade600),
                                                      ),
                                                    ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Icon(IconlyBold.paper,
                                                      size: 20,
                                                      color: Colors.red.shade600),
                                                      Text('copy', style: TextStyle(color: Colors.red.shade600),)
                                              ],
                                            ),
                                          )
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Termination Code'
                                                
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                          ),
                          
                          
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    ]
                  ),
                ),
      
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
                                      content: Text(toTitleCase(a['Message'])));
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
                                      content: Text(toTitleCase(a['Message'])));
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

  confirmContract() async {
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
                                                    "Confirming Phase"),
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
                                            pin['pin'],
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
                                    })
                                // )
                              ],
                              title: const Text("Are you sure?"),
                              content: const Text(
                                  'Do not confirm this phase if the phase has not been completed.'));
                        });

  }
  clientTerminateContract() async {
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
                                                    "Terminating contract"),
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
                                            widget.contract.payload!.privilledges!.terminationCode??'',
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
                                                      content: Text(toTitleCase(a['Message'])));
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
                                                      content: Text(toTitleCase(a['Message'])));
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