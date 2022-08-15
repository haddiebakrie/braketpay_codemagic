import 'dart:async';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/walletcard.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:im_stepper/stepper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail(
      {Key? key, required this.contract, required this.pin, required this.user})
      : super(key: key);

  final ProductContract contract;
  final User user;
  final String pin;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
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
    print(widget.contract.payload!.terms!.toJson());
    final PageController _controller = PageController();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            elevation: 0,
            title: Text("Product Detail"),
            centerTitle: true,
            // actions: [
            //   IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded))
            // ],
            // title: Text(widget.contract.payload!.terms!.contractTitle ?? '')),
            // title: Text('${widget.contract.payload!.states!.closingState}')
            ),
        bottomSheet: widget.contract.payload!.states!.approvalState ==
                'Rejected' || widget.contract.payload!.states!.closingState == 'Closed' || widget.contract.payload!.states!.closingState == 'Terminated'
            ? const SizedBox(
                height: 70,
                child:
                    Center(child: Text('This contract has been closed')))
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
                                    widget.user.payload!.fullname ?? '')
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
                                                child: const Text(
                                                  'Confirm',
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
                                                  sellerTerminateContract();
                                                }))),
                                  ])))
                : Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: !widget.contract
                            .isProvider(widget.user.payload!.fullname ?? '')
                        ? 
                        widget.contract.payload!.states!.approvalState ==
                                'Not approved'
                            ? 
                            SizedBox(
                              height: 70,
                              child:
                                  Center(child: Text('This contract has not been approved by the ${widget.contract.isProvider(widget.user.payload!.fullname??'') ? "Buyer" : "Seller"}')))
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
                                          buyerRejectContract();
                                        }))),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 0, 168, 50),
                                    ),
                                    child: TextButton(
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(color: Colors.white),
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
                            Text(nairaSign()+(widget.contract.payload?.terms?.productAmount??'0'), style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto')),
                            
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
                
                    Text(widget.contract.payload!.terms!.contractTitle ?? '', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold )),
                    Text("Created on: ${widget.contract.dateCreated()}", style: const TextStyle(fontSize: 9, color: Colors.blueGrey) ),
                    Text("ID: ${widget.contract.payload!.contractID}", style: const TextStyle(fontSize: 9, color: Colors.blueGrey) ),
                    
                    SizedBox(height:20),
        
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         // width: double.infinity,
                    //         padding: EdgeInsets.all(15),
                    //         decoration: BoxDecoration(
                    //         color: Colors.tealAccent.shade100,
                    //         borderRadius: BorderRadius.circular(10)
                    //         ),
                    //         child: 
                    //       Row(
                    //         children: [
                    //           Icon(Icons.lock, size: 40, color: Colors.redAccent),
                    //           SizedBox(width:20),
                    //           Column(
                    //             mainAxisSize: MainAxisSize.max,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text('Money locked in Braket vault', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                    //             SizedBox(height: 5,),
                    //               FittedBox(child: 
                    //               contractStateIndex == 0 || contractStateIndex == 2 ||contractStateIndex == 4  ? Text(formatAmount('0'), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)) :
                    //               Text(nairaSign()+(widget.contract.payload?.terms?.productAmount??'0'), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)))
                    //             ],
                    //           ),
                    //         ],
                    //       )
                    //       ,),
                    //     ),
                    //   ]
                    // ),
                    
                    SizedBox(height: 10,),          
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
                          Icon(Icons.delivery_dining, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 4 ? Colors.red : Colors.grey),
                          Icon(Icons.handshake, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 6 ? Colors.red : Colors.grey),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(),
                            // SizedBox(),
                            Text(contractStateIndex == 2 ? 'Rejected' : 'Accepted', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex >= 3 || contractStateIndex == 1  ? Colors.green.shade400 : contractStateIndex == 2 ? Colors.red : Colors.grey,)),
                            const SizedBox(),
                            Text(contractStateIndex == 4 ? '     Terminated' : '    Delivered', style: TextStyle(fontWeight: FontWeight.bold, color: contractStateIndex == 3 ? Colors.green.shade400 : contractStateIndex == 4 ? Colors.red : Colors.grey)),
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
                        const Text('Product Detail', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                        const SizedBox(height:10),
                        MarkdownBody(data:
                          widget.contract.payload!.terms!
                                  .productDetails ??
                              '',
                        ),
                        const SizedBox(height:10),
                        
                      ],
                    ),
                    const SizedBox(height:20),
                   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fees', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                        const SizedBox(height:10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Product Price'),
                              Text(formatAmount(widget.contract.payload?.terms?.productAmount??''))
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Product Quantity'),
                              Text(widget.contract.payload?.terms?.productQuantity??'')
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping Fee'),
                              Text(formatAmount(widget.contract.payload?.terms?.logisticAmount??''))
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text(formatAmount(widget.contract.totalAmount()), style: const TextStyle(fontWeight: FontWeight.w500))
                            ]
                          ),
                        )
                      ]  
                        ),
                        SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Logistics', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                        const SizedBox(height:10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping from'),
                              Text(widget.contract.payload?.terms?.shippingLocation??'')
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping to'),
                              Text(widget.contract.payload?.terms?.shippingDestination??'')
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Delivery date', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text(widget.contract.deliveryDate(), style: const TextStyle(fontWeight: FontWeight.w500))
                            ]
                          ),
                        )
                      ]  
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
                            '${widget.contract.payload!.parties!.contractCreator}'.capitalize!,
                            style: const TextStyle(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          const Text('Buyer'),
                          Text(
                            '${widget.contract.payload!.parties!.buyersName}'.capitalize!,
                          ),
        
                          ],
                        ),
                        ListTile(
                          minLeadingWidth: 0,
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          title: const Text('Seller'),
                          trailing:  Text(
                            '${widget.contract.payload!.parties!.sellersName}'.capitalize!,
                          ),
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 20),
        
                    Visibility(
                      visible: widget.contract.isProvider(widget.user.payload!.fullname ?? ''),
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
                                   print('hi');
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
                    
                   const SizedBox(height: 40)
                  ]),
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
                          }
    
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
                      print(widget.contract.payload!.privilledges!.toJson());
                      try {
                        Map a = await contractAction(
                            widget.contract.payload!.privilledges!
                                    .approvalCode ??
                                '',
                            pin['pin'],
                            widget.contract.payload!.contractID ?? '',
                            widget.user.payload!.publicKey ?? '',
                            'product',
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
                                            brakey.refreshUserDetail();
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
                          }
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
                            'product',
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
                                      content: Text(toTitleCase(a['Message'])));
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
                        }else {
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
              content: const Text('This action cannot be reversed.'));
        });
  }

  confirmContract() async {
    String code = '';
     StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
  final _pinEditController = TextEditingController();
    Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
                          if (pin == null || !pin.containsKey('pin')) {
                            return;
                          }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (confirm) {
          return AlertDialog(
              title: const Text("Enter Confirmation code"),
              content: TextFormField(
                onChanged: (text) {
                  code = text;
                },
              ),
              actions: [
                TextButton(
                  child: const Text('Confirm Contract'),
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
                                            code,
                                            pin['pin'],
                                            widget.contract.payload!
                                                    .contractID ??
                                                '',
                                            widget.user.payload!.publicKey ??
                                                '',
                                            'product',
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
                                                      content: Text(toTitleCase(a['Message'])));
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
                                    })
                                // )
                              ],
                              title: const Text("Are you sure?"),
                              content: const Text(
                                  'Do not confirm this contract if the product has not been delivered.'));
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
  buyerRejectContract() async {
    String code = '';
     StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
  final _pinEditController = TextEditingController();
    Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
                          if (pin == null || !pin.containsKey('pin')) {

                            return;
                          }
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
                                            pin['pin'],
                                            widget.contract.payload!
                                                    .contractID ??
                                                '',
                                            widget.user.payload!.publicKey ??
                                                '',
                                            'product',
                                            'terminate',
                                            "termination_code");
                                            print(a);
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
                                                      content: Text(toTitleCase(a['Message'])));
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

  sellerTerminateContract() async {
    String code = '';
     StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
  final _pinEditController = TextEditingController();
    Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
    if (pin == null || !pin.containsKey('pin')) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (confirm) {
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
                                            widget.contract.payload!.privilledges!.terminationCode??'',
                                            pin['pin'],
                                            widget.contract.payload!
                                                    .contractID ??
                                                '',
                                            widget.user.payload!.publicKey ??
                                                '',
                                            'product',
                                            'terminate',
                                            "termination_code");
                                            print(a);
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
                                                      content: Text(toTitleCase(a['Message'])));
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
  }
}
