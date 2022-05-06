import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Recharge extends StatefulWidget {
  Recharge({Key? key, required this.user, required this.pin}) : super(key: key);

  @override
  State<Recharge> createState() => _RechargeState();
  final User user;
  final String pin;
}

class _RechargeState extends State<Recharge> {
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
      appBar: AppBar(
        title: Text('Recharge'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _networkIndex = 0;

                    });
                  },
                  child: Container(
                    padding: _networkIndex == 0 ? EdgeInsets.all(5) : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      // borderRadius: BorderRadius.circular(20),
                
                    ),
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/mtn.png', fit: BoxFit.contain)
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _networkIndex = 1;

                    });
                  },
                  child: Container(
                    padding: _networkIndex == 1 ? EdgeInsets.all(5) : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      // borderRadius: BorderRadius.circular(20),
                
                    ),
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/glo.jpg', fit: BoxFit.contain)
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _networkIndex = 2;

                    });
                  },
                  child: Container(
                    padding: _networkIndex == 2 ? EdgeInsets.all(5) : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      // borderRadius: BorderRadius.circular(20),
                
                    ),
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/airtel.png', fit: BoxFit.contain)
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _networkIndex = 3;

                    });
                  },
                  child: Container(
                    padding: _networkIndex == 3 ? EdgeInsets.all(5) : EdgeInsets.zero,
                    decoration: BoxDecoration(
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
            child: Text(_networkList[_networkIndex] != 'etisalat' ? _networkList[_networkIndex].toUpperCase() : '9Mobile', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                          margin: const EdgeInsets.symmetric(vertical: 15, horizontal:10),
                          child: TextFormField(
                            cursorColor: Colors.black,
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
                            cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Enter Amount',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                    // print('$username, $pin, $password');
                    Future<bool> a =
                        buyAirtime(phoneNumber, _networkList[_networkIndex], widget.user.payload!.accountNumber?? '', fee.toString(), widget.pin);
                    a.then((value) => a.whenComplete(() {
                          _loginButtonController.success();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
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
                              title: const Text("Airtime recharge successful!"),
                              content: Text('You have successfully recharged NGN$fee to $phoneNumber, check your transaction history for the reciept'));
                        });
                          
                          }));
                    
                    a.onError((error, stackTrace) {
                      print('$error ppppppppppppppppppppppppp');
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
                                    },
                                  )
                                ],
                                title: const Text("Can't Login!"),
                                content: Text(
                                    error.toString()));
                          });
                      throw Exception(error);
                    });
                  } else {
                    _loginButtonController.reset();
                  }
                },
                child: Text(
                  'Pay ${formatAmount(fee.toString())}',
                  style: TextStyle(fontFamily: 'Roboto'))),
          )
        ],
      ),
    );
  }
}
