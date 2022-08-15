import 'dart:async';
import 'dart:ui';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
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

  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            elevation: 0,
            
            centerTitle: true,
            title: Text(widget.contract.payload!.terms!.contractTitle ?? '')),
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
        body: Container(
          decoration: ContainerBackgroundDecoration(),
          child: PageView(controller: _controller, children: [
            Stack(children: [
              Container(
                  margin: const EdgeInsets.only(left: 30),
                  height: double.infinity,
                  width: 2,
                  color: Colors.grey),
              ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 90),
                    child: Column(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: ThemedBackgroundColor,
                            margin: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                widget.contract.dateCreated(),
                                style: const TextStyle(fontSize: 18),
                              ))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: ThemedBackgroundColor,
                            margin: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.people_alt_rounded,
                                    color: Theme.of(context).primaryColor),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Parties',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Created by: ${widget.contract.payload!.parties!.contractCreator}',
                                style: const TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Buyer: ${widget.contract.payload!.parties!.buyersName}',
                                style: const TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Seller: ${widget.contract.payload!.parties!.sellersName}',
                                style: const TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                      
                      Visibility(
                        visible: widget.contract.isProvider(widget.user.payload!.fullname ?? ''),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: ThemedBackgroundColor,
                              margin: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.lock,
                                      color: Theme.of(context).primaryColor),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Privilledges',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                             onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: widget.contract.payload!.privilledges?.confirmationCode));
                                Get.showSnackbar(const GetSnackBar(
                                    duration: Duration(seconds: 1),
                                    messageText: Text(
                                        'Confirmation code has been copied',
                                        style:
                                            TextStyle(color: Colors.white))));
                            },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Confirmation Code: ${widget.contract.payload!.privilledges?.confirmationCode}',
                                        style: const TextStyle(fontSize: 18),
                                        
                                      ),
                                      SizedBox(width: 5,),
                                      Icon(CupertinoIcons.doc_on_doc_fill,
                                          size: 15,
                                          color: Colors.blueGrey)
                                    ],
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: widget.contract.payload!.privilledges?.terminationCode));
                                Get.showSnackbar(const GetSnackBar(
                                    duration: Duration(seconds: 1),
                                    messageText: Text(
                                        'Termination code has been copied',
                                        style:
                                            TextStyle(color: Colors.white))));
                            },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Termination Code: ${widget.contract.payload?.privilledges?.terminationCode}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: 5,),
                                      Icon(CupertinoIcons.doc_on_doc_fill,
                                          size: 15,
                                          color: Colors.blueGrey)
                                    ],
                                  )),
                            ),
                            
                          ],
                        ),
                      ),
                      
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: ThemedBackgroundColor,
                            margin: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.label, color: Theme.of(context).primaryColor),
                                const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Product Detail',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)))
                              ],
                            ),
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                widget.contract.payload!.terms!
                                        .productDetails ??
                                    '',
                                style: const TextStyle(fontSize: 18),
                              ))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: ThemedBackgroundColor,
                            margin: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.payment, color: Theme.of(context).primaryColor),
                                const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Price',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)))
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Product Price: ${formatAmount(widget.contract.payload!.terms!.productAmount.toString())}',
                                style: const TextStyle(
                                    fontSize: 18, fontFamily: ''),
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Shipping Fee: ${formatAmount(widget.contract.payload!.terms!.logisticAmount.toString())}',
                                style: const TextStyle(
                                    fontSize: 18, fontFamily: ''),
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Total: ${formatAmount(widget.contract.totalAmount())}',
                                style: const TextStyle(
                                    fontSize: 18, fontFamily: ''),
                              )),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: ThemedBackgroundColor,
                            margin: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.delivery_dining,
                                    color: Theme.of(context).primaryColor),
                                const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Shipping',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)))
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'From: ${widget.contract.payload!.terms!.shippingLocation}',
                                style: const TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'To: ${widget.contract.payload!.terms!.shippingDestination}',
                                style: const TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Delivers on: ${widget.contract.deliveryDate()}',
                                style: const TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: ThemedBackgroundColor,
                            margin: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.flag_circle,
                                    color: Theme.of(context).primaryColor),
                                const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Contract State',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)))
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                widget.contract.payload!.states!
                                        .approvalState ??
                                    '',
                                style: const TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                      const SizedBox(height: 40)
                    ]),
                  ),
                ],
              )
            ])
          ]),
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
                        }else {
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
                          };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (confirm) {
          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                          };
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
    };
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
}
