import 'dart:convert';
import 'dart:typed_data';

import 'package:braketpay/api_callers/merchant.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../uix/listitemseparated.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class MerchantCreateServiceFromScan extends StatefulWidget {
  const MerchantCreateServiceFromScan(
      {Key? key, required this.product, required this.user, required this.pin})
      : super(key: key);

  final Map product;
  final User user;
  final String pin;

  @override
  State<MerchantCreateServiceFromScan> createState() =>
      _MerchantCreateServiceFromScanState();
}

class _MerchantCreateServiceFromScanState extends State<MerchantCreateServiceFromScan> {
  late String shipDest;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final TextEditingController _shipDestFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map stages = jsonDecode(widget.product['about_service_delivery_stages']);

    List<dynamic> ld =
        jsonDecode(utf8.decode(hex.decode(widget.product['service_picture'])));
    List<int> image = ld.map((s) => s as int).toList();
    print(
        // decode(hex.decode(widget.product['Payload']['product_picture']))
        (image.length));
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(elevation: 0),
        body: Container(
          decoration: ContainerBackgroundDecoration(),
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
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
                            const SizedBox(height: 10),
                            const Text(
                              'Contract Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ListItemSeparated(
                          text: widget.product['contract_title'],
                          title: 'Contract Title'),
                      ListItemSeparated(
                          text: '${widget.product['contract_type'].toUpperCase()} CONTRACT',
                          title: 'Contract Type'),
                      ListItemSeparated(
                          text: 'NGN ${(widget.product['downpayment'].toString())}',
                          title: 'Downpayment'),
                      ListItemSeparated(
                          text: widget.product['delivery_duration'],
                          title: 'Delivers In', isLast: true,),
                  const SizedBox(height: 20),],)),
          Container(
            margin: const EdgeInsets.only(top: 10),
                  decoration: ContainerDecoration(),

              child: Column(
                children: [
                  const SizedBox(height: 10),
                      const Text(
                        'Service stages',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: stages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListItemSeparated(title: stages[stages.keys.toList()[index]]['about_stage'], text: formatAmount('${stages[stages.keys.toList()[index]]['cost_of_stage']}'));
                    },
                  ),
                ],
              ),        
              ),
                  const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                            const SizedBox(height: 10),
                            const Text(
                              'Delivery Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: const Text(
                                      'Delivery Destination',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _shipDestFieldController,
                                    cursorColor: Colors.black,
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
                                      _loginButtonController.reset();
                                      shipDest = text.trim();
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'The field is required';
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
                                child: const Text('Create'),
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
                                    'Creating Service contract',
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
                            print(widget.product.keys.toList());
                        Map a = await activateServiceMerchantContract(
                           widget.user.payload!.bvn ?? '',
                          widget.product['merchant_id'],
                           widget.pin,
                            widget.product['service_id'],
                           widget.user.payload!.walletAddress ?? '',
                           shipDest,
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
                                    content:  const Text('Your Product Contract has been created.'));
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
          ),
        ));
  }
}
