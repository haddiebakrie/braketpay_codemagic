import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
                      Map a = await getUserWith(text.trim(), 'account number');
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
                                    'Rechard amount must not be less than NGN 50'));
                          });
                      _loginButtonController.reset();
                      return;
                    } else if (bankName != 'Braket Wallet') {
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
                    } else if (accountNumber == widget.user.payload!.accountNumber) {
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
                                content:
                                    const Text("You entered your own Account number!"));
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
                                content:
                                    const Text("Enter with valid Braket Account!"));
                          });
                      _loginButtonController.reset();
                      return;}
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
                                      child: const Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("Money sent!"),
                                  content:  Text('Your transfer of $fee to $userName was successful, check transaction history for your receipt.'));
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
                                  content:  Text(a['Message']));
                            });

                      }
                    // a.onError((error, stackTrace) {
                    //   print('$error ppppppppppppppppppppppppp');
                    //   _loginButtonController.reset();
                    //   showDialog(
                    //       context: context,
                    //       barrierDismissible: false,
                    //       builder: (context) {
                    //         return AlertDialog(
                    //             actions: [
                    //               TextButton(
                    //                 child: const Text('Okay'),
                    //                 onPressed: () {
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               )
                    //             ],
                    //             title: const Text("Can't Make transfer!"),
                    //             content: Text(error.toString()));
                    //       });
                    //   throw Exception(error);
                    // });
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
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _networkList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        bankName = _networkList[index];
                      });
                      Navigator.of(context).pop(context);
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(_networkList[index]),
                          leading: Container(
                              margin: EdgeInsets.all(8),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Image.asset(
                                  'assets/${_networkList[index].split(" ")[0].toLowerCase()}.png')),
                        ),
                        Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.withAlpha(100),
                            margin: EdgeInsets.only(bottom: 0))
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
