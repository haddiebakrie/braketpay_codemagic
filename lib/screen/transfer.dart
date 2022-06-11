import 'dart:convert';
import 'dart:io';

import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:searchfield/searchfield.dart';

import '../brakey.dart';
import '../uix/roundbutton.dart';

class SendMoney extends StatefulWidget {
  SendMoney({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;

  @override
  State<SendMoney> createState() => _RechargeState();
  // final User user;
}

class _RechargeState extends State<SendMoney> {
  Brakey brakey = Get.put(Brakey());
  String query = '';
  int _networkIndex = 0;
  String phoneNumber = '';
  String userName = '';
  String accountNumber = '';
  double fee = 0;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final List _networkList = [
    'Braket Wallet',
    'FCMB',
    'Access Bank',
    'First Bank'
  ];
  String bankName = 'Select Bank Name';
  String bankCode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Future a = askBankName();
                    // a.then((value) =>
                    // Future payload = getUserWith(id: accountNumber, type: 'account number')

                    // );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    color: Color.fromARGB(24, 158, 158, 158),
                    child: Text(bankName, style: TextStyle(fontSize: 18)),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(24, 158, 158, 158),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Enter Account number',
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (text) async {
                      userName = 'Checking for username';
                      accountNumber = text.trim();
                      Map a;
                      if (bankName == 'Braket Wallet') {
                        a = await getUserWith(text.trim(), 'account number');
                        userName = a.containsKey('Payload')
                            ? a['Payload']['fullname']
                            : 'Incorrect Braket Account';
                        setState(() {
                          userName = a.containsKey('Payload')
                              ? 'Name: ${a['Payload']['fullname']}'
                              : a.containsKey('Message')
                                  ? a['Message']
                                  : 'No Internet access';
                        });
                      } else {
                        a = await getBanks(
                            widget.user.payload!.email ?? '',
                            widget.user.payload!.password ?? '',
                            'account',
                            bankCode,
                            text.trim());
                        print(a);
                        // userName = a.containsKey('status') && a['status'] == 'true'
                        //     ? a['data']['account_name']['message']
                        //     : 'Incorrect Account number';
                        setState(() {
                          userName = a.containsKey('status') &&
                                  a['status'] == true
                              ? 'Name: ${a['data']['account_name']}'
                              : a.containsKey('status') && a['status'] == false
                                  ? 'Invalid Account Number'
                                  : 'No Internet access';
                        });
                      }
                      print(userName);

                      // setState(() {
                      // userName =
                      //     "Can't fetch account detail please check your internet connection";

                      // });

                      //     print(a);

                      // }
                      // setState(() {
                      //   // if (bankName!='Braket Wallet') {
                      //   //   return;
                      //   // }
                      //   // if (bankName=='Select Bank Name') {
                      //   //   userName = '';
                      //   //   return;
                      // }
                      //     // print('hi');
                      // userName = 'Fetching account detail';
                      // );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    color: Color.fromARGB(24, 158, 158, 158),
                    child: Text(userName, style: TextStyle(fontSize: 18)),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(24, 158, 158, 158),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Enter Amount',
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      } else if (double.parse(value) < 50) {
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
                    if (fee <= 50) {
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
                                content: const Text(
                                    'Transfer amount must not be less than NGN 50'));
                          });
                      _loginButtonController.reset();
                      return;
                    } else if (bankName == 'raket Wallet') {
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
                                title: const Text("Not Implemented!"),
                                content:
                                    const Text('Please select Braket Wallet'));
                          });
                      _loginButtonController.reset();
                      return;
                    } else if (accountNumber ==
                        widget.user.payload!.accountNumber) {
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
                                title: const Text("Invalid Account Number!"),
                                content: const Text(
                                    "You entered your own Account number!"));
                          });
                      _loginButtonController.reset();
                      return;
                    } else if (!userName.startsWith('Name:')) {
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
                                title: const Text("Invalid Account Number!"),
                                content: const Text(
                                    "Enter with valid Braket Account!"));
                          });
                      _loginButtonController.reset();
                      return;
                    }
                    // print('$username, $pin, $password');
                    Map a = await cashTransfer(
                        fee.toInt().toString(),
                        widget.user.payload!.password ?? '',
                        widget.pin,
                        widget.user.payload!.accountNumber ?? '',
                        accountNumber,
                        'Braket',
                        'intrabank');
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
                                title: const Text("Money sent!"),
                                content: Text(
                                    'Your transfer of $fee to $userName was successful, check transaction history for your receipt.'));
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
                                      // Navigator.of(context).pop();
                                      // Navigator.of(context).pop();
                                    },
                                  )
                                ],
                                title: const Text("Can't make Transfer!"),
                                content: Text(a['Message']));
                          });
                    }
                  } else {
                    _loginButtonController.reset();
                  }
                },
                child: Text('Send ${formatAmount(fee.toString())}',
                    style: const TextStyle(fontFamily: 'Roboto'))),
          )
        ],
      ),
    );
  }

  Future<dynamic> askBankName() {
    Future<Map> banks = getBanks(widget.user.payload!.email ?? "",
        widget.user.payload!.password ?? "", 'bank', '', '');
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (contex) {
          return StatefulBuilder(
            builder: (context, changeState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: FutureBuilder<Map>(
                      future: banks,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.containsKey('data')) {
                            // snapshot.data!['data'].insert(
                            //     0,);
                            List _data = List.from(snapshot.data!['data']);
                            // for (var e in data) {
                            //   if (!e['name'].toLowerCase().contains(query) && query != '') {
                            //     data.remove(e);
                            List data = List.from(_data);
                            // }}
                            if (query != '') {
                              print(snapshot.data!['data']);
                              data = _data;
                              data.removeWhere((e) => !e['name'].toLowerCase().contains(query.toLowerCase()));
                            }
                            if (data.isEmpty) {
                              data.insert(0,  {'name': 'Braket Wallet', 'code': 'logo'});

                            }
                            if (data[0]['name'] != 'Braket Wallet') {
                              data.insert(0,  {'name': 'Braket Wallet', 'code': 'logo'});

                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final a = [];
                                // a.insert(index, element)
                                if (index == 0) {
                                  return Column(
                                    children: [
                                      TextFormField(
                                        cursorColor: Colors.black,
                                        decoration: const InputDecoration(
                                          fillColor: Color.fromARGB(24, 158, 158, 158),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          hintText: 'Search Bank',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          contentPadding:
                                              EdgeInsets.symmetric(horizontal: 10),
                                        ),
                                        onChanged: (text) {
                                          changeState(() {
                                            query = text;
                                            print(query);
                                          });
                                        },
                                      ),
                                      GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        bankName =
                                            data[index]['name'];
                                        bankCode =
                                            data[index]['code'];
                                      });
                                      Navigator.of(context).pop(context);
                                    },
                                    child: BankListItem(
                                        data: data[index]),)
                                    ],
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        bankName =
                                            data[index]['name'];
                                        bankCode =
                                            data[index]['code'];
                                      });
                                      Navigator.of(context).pop(context);
                                    },
                                    child: BankListItem(
                                        data: data[index]),
                                  );
                                }
                              },
                            );
                          } else {
                            return Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                      bottom: Radius.zero),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Column(
                                  children: [
                                    Image.asset('assets/sammy-no-connection.gif',
                                        width: 150),
                                    const Text(
                                        "No internet access\nCoudn't Load Contract History!",
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 20),
                                    RoundButton(
                                        text: 'Retry',
                                        color1: Colors.black,
                                        color2: Colors.black,
                                        onTap: () {
                                          banks = getBanks(
                                              widget.user.payload!.email ?? "",
                                              widget.user.payload!.password ?? "",
                                              'bank',
                                              '',
                                              '');
                                        })
                                  ],
                                )));
                          }
                          // print(snapshot.data!['data'].length);
                        } else {
                          return Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20), bottom: Radius.zero),
                                color: Colors.white,
                              ),
                              child: Center(
                                  child: Column(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: CircularProgressIndicator(
                                        color: Colors.grey),
                                  ),
                                  Text("Loading list of banks..."),
                                ],
                              )));
                        }
                      }),
                ),
              );
            }
          );
        });
  }
}

class BankListItem extends StatelessWidget {
  BankListItem({Key? key, required this.data}) : super(key: key);

  Map data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(data['name']),
          leading: Container(
              margin: EdgeInsets.all(8),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child: Image.asset(
                'bank_images/${data['code']}.png',
                width: 50,
                errorBuilder: (context, exception, stackTrace) {
                  return Icon(Icons.account_balance);
                },
              )),
        ),
        Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.withAlpha(100),
            margin: EdgeInsets.only(bottom: 0))
      ],
    );
  }
}
