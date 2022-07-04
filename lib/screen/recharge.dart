import 'dart:async';

import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../brakey.dart';
import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';

class Recharge extends StatefulWidget {
  const Recharge({Key? key, required this.user, required this.pin}) : super(key: key);

  @override
  State<Recharge> createState() => _RechargeState();
  final User user;
  final String pin;
}

class _RechargeState extends State<Recharge> {
  Brakey brakey = Get.put(Brakey());
  int _networkIndex = 0;
  String phoneNumber = '';
  String amount = '';
  double fee = 0;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
    RoundedLoadingButtonController();
  final List _networkList = ['mtn', 'glo', 'airtel', 'etisalat'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Recharge'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
              decoration: ContainerBackgroundDecoration(),
        child: Column(
          children: [
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _networkIndex = 0;

                      });
                    },
                    child: Container(
                      padding: _networkIndex == 0 ? const EdgeInsets.all(5) : EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        // borderRadius: BorderRadius.circular(20),
                  
                      ),
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/mtn.png', fit: BoxFit.contain)
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _networkIndex = 1;

                      });
                    },
                    child: Container(
                      padding: _networkIndex == 1 ? const EdgeInsets.all(5) : EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        // borderRadius: BorderRadius.circular(20),
                  
                      ),
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/glo.jpg', fit: BoxFit.contain)
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _networkIndex = 2;

                      });
                    },
                    child: Container(
                      padding: _networkIndex == 2 ? const EdgeInsets.all(5) : EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        // borderRadius: BorderRadius.circular(20),
                  
                      ),
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/airtel.png', fit: BoxFit.contain)
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _networkIndex = 3;

                      });
                    },
                    child: Container(
                      padding: _networkIndex == 3 ? const EdgeInsets.all(5) : EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        // borderRadius: BorderRadius.circular(20),
                  
                      ),
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/9mobile.png', fit: BoxFit.cover)
                    ),
                  )
                ],

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_networkList[_networkIndex] != 'etisalat' ? _networkList[_networkIndex].toUpperCase() : '9Mobile', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                            margin: const EdgeInsets.symmetric(vertical: 15, horizontal:10),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Enter Phone number',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                phoneNumber = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                Container(
                            margin: const EdgeInsets.symmetric(vertical: 15, horizontal:10),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: const Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                helperText: 'Minimum ${formatAmount("50")}',
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Enter Amount',
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                setState(() {
                                fee = text.trim() == '' ? 0 : double.parse(text.trim());
                                  
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                else if (double.parse(value) < 50) {
                                  return 'Amount must be atleast NGN 50';
                                }
                                return null;
                              },
                            ),
                          ),
                ],
              ),
            ),
            
            Container(
              margin: const EdgeInsets.all(10),
              child: RoundedLoadingButton(
                  borderRadius: 10,
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  controller: _loginButtonController,
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      if (fee < 50) {
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
                                    },
                                  )
                                ],
                                title: const Text("Invalid Amount!"),
                                content: const Text('Rechard amount must not be less than NGN 50'));
                          });
                          _loginButtonController.reset();
                          return;
                          }
                          StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                          final _pinEditController = TextEditingController();
                           Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
                          if (pin == null || !pin.containsKey('pin')) {
                            _loginButtonController.reset();
                            return;
                          }
                      // print('$username, $pin, $password');
                      Map a = await
                          buyAirtime(phoneNumber, _networkList[_networkIndex], widget.user.payload!.accountNumber?? '', fee.toString(), pin['pin']);
                      if (a.containsKey('Payload')) {
                          _loginButtonController.success();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                    actions: [
                                      TextButton(
                                        // 2204112769
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          // Navigator.of(context).pop();
                                          brakey.refreshUserDetail();
                                          brakey.changeManagerIndex(2);
                                          // brakey.managerIndex = Rxn(3);
                                        },
                                      )
                                    ],
                                    title: const Text("Airtime Recharge Successful!"),
                                    content: const Text(
                                        'Your transaction was successful, Check your transaction history for your reciept.'));
                              });
                        } else {
                          _loginButtonController.reset();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                print(a['Message'].runtimeType);
                                return AlertDialog(
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
                                    title: const Text("Can't complete transaction!"),
                                    content: Text(toTitleCase(a['Message']??'Failed to connect to Network, Please try again')));
                              });

                              // {Message: {data: {destination.amount: {message: destination.amount must be greater than or equal to 100}}, error: bad_request, message: invalid request data, status: false}, Response code: 400, Status: failed}
                        }
                        
                    } else {
                      _loginButtonController.reset();
                    }
                  },
                  child: Text(
                    'Pay ${formatAmount(fee.toString())}',
                    style: const TextStyle(fontFamily: 'Roboto'))),
            )
          ],
        ),
      ),
    );
  }
}
