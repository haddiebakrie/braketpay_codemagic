import 'dart:ui';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(widget.contract.payload!.terms!.contractTitle ?? '')),
        bottomSheet: !widget.contract
                .isContractCreator(widget.user.payload!.walletAddress ?? '')
            ? Visibility(
                visible: widget.contract.payload!.privilledges != null
                    ? true
                    : false,
                child: Container(
                    height: 70,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: widget.contract.payload!.states!.approvalState == 'Not Approved' ? Row(children: [
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 48, 48),
                              ),
                              child: TextButton(
                                  child: Text(
                                    'Terminate',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    rejectContract();

                                  }))),
                      SizedBox(width: 10),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 168, 50),
                              ),
                              child: TextButton(
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    approveContract();
                                  }))),
                    ]) : Container(

                        child: Center(child: Text('This contract has been closed'))

                    ))
              )
            : Container(
                height: 70,
              ),
        body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.zero),
            color: Colors.white,
          ),
          child: PageView(controller: _controller, children: [
            Stack(children: [
              Container(
                  margin: EdgeInsets.only(left: 30),
                  height: double.infinity,
                  width: 2,
                  color: Colors.grey),
              ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: Column(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.deepOrange,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                widget.contract.dateCreated(),
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.people_alt_rounded,
                                    color: Colors.deepOrange),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Parties',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Created by: ${widget.contract.payload!.parties!.contractCreator}',
                                style: TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Buyer: ${widget.contract.payload!.parties!.buyersName}',
                                style: TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Seller: ${widget.contract.payload!.parties!.sellersName}',
                                style: TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.label, color: Colors.deepOrange),
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Product Detail',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)))
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                widget.contract.payload!.terms!
                                        .productDetails ??
                                    '',
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.all(20),
                            child: Row(
                              children: const [
                                Icon(Icons.payment,
                                    color: Colors.deepOrange),
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Price',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)))
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Product Price: ${formatAmount(widget.contract.payload!.terms!.productAmount.toString())}',
                                style: TextStyle(fontSize: 18, fontFamily: ''),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Shipping Fee: ${formatAmount(widget.contract.payload!.terms!.logisticAmount.toString())}',
                                style: TextStyle(fontSize: 18, fontFamily: ''),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Total: ${formatAmount(widget.contract.totalAmount())}',
                                style: TextStyle(fontSize: 18, fontFamily: ''),
                              )),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.delivery_dining,
                                    color: Colors.deepOrange),
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Shipping',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)))
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'From: ${widget.contract.payload!.terms!.shippingLocation}',
                                style: TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'To: ${widget.contract.payload!.terms!.shippingDestination}',
                                style: TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                'Delivers on: ${widget.contract.deliveryDate()}',
                                style: TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.flag_circle,
                                    color: Colors.deepOrange),
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Contract State',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)))
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              child: Text(
                                widget.contract.payload!.states!
                                        .approvalState ??
                                    '',
                                style: TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                      SizedBox(height: 40)
                    ]),
                  ),
                ],
              )
            ])
          ]),
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
                      print(widget.contract.payload!.privilledges!.toJson());
                      try {
                      Map a = await contractAction(
                          widget.contract.payload!.privilledges!.approvalCode ??
                              '',
                          widget.pin,
                          widget.contract.payload!.contractID ?? '',
                          widget.user.payload!.publicKey ?? '',
                          'product',
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
                                    content:
                                        const Text('This contract has been approved'));
                              });
                          }
                            else {
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
                                        Navigator.of(error).pop();
                                        Navigator.of(error).pop();
                                        Navigator.of(error).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("No internet access!"),
                                  content: Text('Make sure you are connected to the internet and try again'));
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
                                      padding: const EdgeInsets.all(15.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                    Text('Please wait...'),
                                  ],
                                ));
                          });
                      print(widget.contract.payload!.privilledges!.toJson());
                      try {
                      Map a = await contractAction(
                          widget.contract.payload!.privilledges!.approvalCode ??
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
                                    content:
                                        const Text('This contract has been rejected'));
                              });
                          }
                            else {
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
                                        Navigator.of(error).pop();
                                        Navigator.of(error).pop();
                                        Navigator.of(error).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("No internet access!"),
                                  content: Text('Make sure you are connected to the internet and try again'));
                            });
                      }
                    })
                // )
              ],
              title: const Text("Are you sure?"),
              content: const Text(
                  'This action cannot be reversed.'));
        });
  }
}
