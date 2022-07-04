import 'dart:convert';
import 'dart:typed_data';

import 'package:braketpay/api_callers/merchant.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../uix/listitemseparated.dart';
import '../utils.dart';

class MerchantCreateProductFromScan extends StatefulWidget {
  const MerchantCreateProductFromScan(
      {Key? key, required this.product, required this.user, required this.pin})
      : super(key: key);

  final Map product;
  final User user;
  final String pin;

  @override
  State<MerchantCreateProductFromScan> createState() =>
      _MerchantCreateProductFromScanState();
}

class _MerchantCreateProductFromScanState extends State<MerchantCreateProductFromScan> {
  late int shipFee;
  late String shipDest;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final TextEditingController _shipFeeFieldController = TextEditingController();
  final TextEditingController _shipDestFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<dynamic> ld =
        jsonDecode(utf8.decode(hex.decode(widget.product['product_picture'])));
    List<int> image = ld.map((s) => s as int).toList();
    print(
        // decode(hex.decode(widget.product['Payload']['product_picture']))
        (image.length));
    return Scaffold(
        appBar: AppBar(elevation: 0),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.memory(Uint8List.fromList(image),),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            )
                          ]),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Contract Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          ListSeparated(
                              text: widget.product['contract_title'],
                              title: 'Contract Title'),
                          ListSeparated(
                              text:
                                  '${widget.product['contract_type'].toUpperCase()} CONTRACT',
                              title: 'Contract Type'),
                          ListSeparated(
                              text: widget.product['product_name'],
                              title: 'Product Name'),
                          ListSeparated(
                              text: widget.product['product_details'],
                              title: 'Product Detail'),
                          ListSeparated(
                              text:
                                  'NGN ${(widget.product['product_amount'].toString())}',
                              title: 'Product Amount'),
                          ListSeparated(
                            text: widget.product['minimum_delivery_date'],
                            title: 'Delivers In',
                            isLast: true,
                          ),
                        ],
                      )),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            )
                          ]),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Shipping Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Shipping Destination',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ),
                                TextFormField(
                                  controller: _shipDestFieldController,
                                  cursorColor: Colors.grey,
                                  decoration: const InputDecoration(
                                    fillColor:
                                        Color.fromARGB(24, 158, 158, 158),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Ex Lagos',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                  ),
                                  onChanged: (text) {
                                    shipDest = text.trim();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'The cost of shipping is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Cost of Shipping',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ),
                                TextFormField(
                                  controller: _shipFeeFieldController,
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    prefixText: 'NGN',
                                    prefixStyle: TextStyle(color: Colors.grey),
                                    fillColor:
                                        Color.fromARGB(24, 158, 158, 158),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: '0.00',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                  ),
                                  onChanged: (text) {
                                    shipFee = int.parse(text.trim());
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'The cost of shipping is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          RoundedLoadingButton(
                              borderRadius: 10,
                              color: Theme.of(context).primaryColor,
                              elevation: 0,
                              controller: _loginButtonController,
                              child: Text('Create'),
                              onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();

                                if (!_formKey.currentState!.validate()) {
                                  _loginButtonController.reset();
                                } else {
showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return AlertDialog(
                                title: const Text(
                                  'Creating product contract',
                                  textAlign: TextAlign.center,
                                ),
                                // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                                content: Row(children: const [
                                  Padding(
                                    padding:  EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                  Text('Please wait....', style: TextStyle(fontWeight: FontWeight.w500))
                                ]));
                          });
                      Map a = await activateMerchantContract(
                         widget.user.payload!.bvn ?? '',
                          widget.product['merchant_id'],
                         widget.pin,
                          widget.product['product_id'],
                         widget.user.payload!.walletAddress ?? '',
                         shipDest,
                         shipFee.toString()
                         );
                
                if (a.containsKey('Payload')) {
                        _loginButtonController.success();
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
                                        Navigator.of(context).pop(true);
                                      },
                                    )
                                  ],
                                  title: const Text("Contract created!"),
                                  content:  Text('Your Product Contract has been created.'));
                            });
                      } else {
                        _loginButtonController.reset();
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
                                        // Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("Can't create Template!"),
                                  content:  Text(a['Message']));
                            });

                      }
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
