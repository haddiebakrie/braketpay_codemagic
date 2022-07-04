import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:searchfield/searchfield.dart';

import '../bank_list.dart';
import '../brakey.dart';
import '../uix/askpin.dart';
import '../uix/roundbutton.dart';
import '../uix/themedcontainer.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;

  @override
  State<SendMoney> createState() => _RechargeState();
  // final User user;
}

class _RechargeState extends State<SendMoney> {
  Brakey brakey = Get.put(Brakey());
  final TextEditingController _amountController = TextEditingController();
  String query = '';
  final int _networkIndex = 0;
  String phoneNumber = '';
  String note = '';
  String userName = '';
  String accountNumber = '';
  double fee = 0;
  
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final List amounts = [
    '1000',
    '2000',
    '5000',
    '10000',
    '50000',
    '100000'
  ];
  List beneficiaries = [
    {'Mom': ['373874712', '011', 'Abu-bakry Ramotallahi']},
    {'Dad': ['090982340', '214', 'Abubakry Mufutau']},
    {'Mo': ['230982340', '000', 'Lawal Ramota']},
    {'Qudus': ['432982340', '000', 'Abubakry Qudus']},
  ];
  String bankName = 'Select Bank Name';
  String bankCode = '';
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Send Money'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        decoration: ContainerBackgroundDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Bank', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                                setState(() {
                                  bankName =
                                      'Braket Wallet';
                                  bankCode =
                                      '000';
                                });

                            },
                            child: const BankAvatar(title: 'BRAKET', code: '000')),
                          InkWell(
                            onTap: () {
                                setState(() {
                                  bankName =
                                      'FCMB Plc';
                                  bankCode =
                                      '214';
                                });

                            },
                            child: const BankAvatar(title: 'FCMB', code: '214')),
                          InkWell(
                            onTap: () {
                                setState(() {
                                  bankName =
                                      'Ecobank';
                                  bankCode =
                                      '050';
                                });

                            },
                            child: const BankAvatar(title: 'ECOBANK', code: '050')),
                          InkWell(
                            onTap: () {
                                setState(() {
                                  bankName =
                                      'Access Bank Nigeria';
                                  bankCode =
                                      '044';
                                });

                            },
                            child: const BankAvatar(title: 'ACCESS', code: '044')),
                        ],
                      ),
                    ),
                        TextButton(onPressed: () {
                          Future a = askBankName();
                          setState((){
                          userName = '';
                          query = '';

                          });
                        }, child: const Text('more'))
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        // margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(vertical:15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // color: Colors.white,
                        color: const Color.fromARGB(24, 158, 158, 158),
                      ),
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              title: Text(bankName, style: const TextStyle(fontSize: 18)),
                            leading: Container(
                                    width: 30,
                                    height: 30,
                                    // margin: EdgeInsets.all(8),

                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration:
                                        BoxDecoration(
                                          color: Theme.of(context).primaryColorLight,
                                          borderRadius: BorderRadius.circular(10)),
                                    child: Image.asset(
                                      'bank_images/$bankCode.png',
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, exception, stackTrace) {
                                        return Icon(Icons.account_balance, size:20, color: Theme.of(context).primaryColor);
                                      },
                                    )),
                              ),
                                                    Container(
                        margin:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            TextFormField(
                              maxLength: 10,
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                print(text);
                                if (text.length < 10) {
                                  return;
                                }
                                userName = 'Checking Account Number';
                                accountNumber = text.trim();
                                setState(() {
                                });
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
                                            : 'No Internet access (Tap to Retry)';
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
                                            : 'No Internet access (Tap to Retry)';
                                  });
                                }

                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      InkWell(
                        onTap: () async {
                          userName = 'Checking Account Number';
                                accountNumber = accountNumber.trim();
                                setState(() {
                                });
                                Map a;
                                if (bankName == 'Braket Wallet') {
                                  a = await getUserWith(accountNumber.trim(), 'account number');
                                  userName = a.containsKey('Payload')
                                      ? a['Payload']['fullname']
                                      : 'Incorrect Braket Account';
                                  setState(() {
                                    userName = a.containsKey('Payload')
                                        ? 'Name: ${a['Payload']['fullname']}'
                                        : a.containsKey('Message')
                                            ? a['Message']
                                            : 'No Internet access (Tap to Retry)';
                                  });
                                } else {
                                  a = await getBanks(
                                      widget.user.payload!.email ?? '',
                                      widget.user.payload!.password ?? '',
                                      'account',
                                      bankCode,
                                      accountNumber.trim());
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
                                            : 'No Internet access (Tap to Retry)';
                                  });
                                }

                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(24, 158, 158, 158),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(5),
                
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration:
                                    BoxDecoration(
                                      // color: Theme.of(context).primaryColorLight,
                                      borderRadius: BorderRadius.circular(40)),
                                child: Image.asset(
                                  'assets/avatar-03.png',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, exception, stackTrace) {
                                    return const SizedBox();
                                  },
                                )),
                                const SizedBox(width:5),
                              Text(userName=="" ? 'Enter a valid account number' : userName),
                            ],
                          ),
                        ),
                      ),
                      
                      
                      
                          ],
                        ),
                      ),

                      Container(
                        margin:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                'Amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              controller: _amountController,
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                              helperText: "Current balance: ${formatAmount(brakey.user.value!.payload!.accountBalance.toString())}",
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                hintText: '${nairaSign()} 0.000 ',
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
                                if (value == null || value.isEmpty || double.parse(value) > brakey.user.value!.payload!.accountBalance!) {
                                  return 'Please enter an amount below ${formatAmount(brakey.user.value!.payload!.accountBalance.toString())}';
                                }
                              },
                            ),])),

                      Container(
                        margin:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                'Add a note',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                hintText: 'Leave a quick note ',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  note = text;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
              
              Container(
                padding: const EdgeInsets.only(top:40),
                child: RoundedLoadingButton(
                    borderRadius: 10,
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    controller: _loginButtonController,
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_formKey.currentState!.validate()) {
                        if (fee < 100) {
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
                                        'Transfer amount must not be less than NGN 100'));
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
                          } else if (fee < 100) {
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
                                    title: const Text("Below minimum amount!"),
                                    content: const Text(
                                        "The amount you entered is below NGN 100!"));
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
                                        "Enter a valid Account Number!"));
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
                        Map a = await cashTransfer(
                            fee.toInt().toString(),
                            widget.user.payload!.password ?? '',
                            pin['pin'],
                            widget.user.payload!.accountNumber ?? '',
                            accountNumber,
                            bankName == 'Braket Wallet' ? 'Braket' : bankName,
                            userName.replaceAll('Name:', ''),
                            bankCode,
                            note,
                            bankName == 'Braket Wallet' ? 'intrabank' : 'interbank');
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
                                    title: const Text("Can't make Transfer!"),
                                    content: Text(a['Message'].runtimeType != String && a['Message'].containsKey('data') ? toTitleCase(a['Message']['data'][a['Message']['data'].keys.toList()[0]]['message'].toString().replaceFirst('destination.', '') ): a['Message'].toString()));
                              });

                              // {Message: {data: {destination.amount: {message: destination.amount must be greater than or equal to 100}}, error: bad_request, message: invalid request data, status: false}, Response code: 400, Status: failed}
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
        ),
      ),
        ]))));
  }

  Future<dynamic> askBankName() {
    List banks = nibbsBanks;
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (contex) {
          return WillPopScope(
            onWillPop: () async {
              setState(() {
              query = '';
              });
                return true;
            },
            child: StatefulBuilder(
              builder: (context, changeState) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: double.infinity,
                    decoration: ContainerBackgroundDecoration(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: ListView.builder(
                      itemCount: 2,
                        itemBuilder: (context, i) {
                          if (i == 0) {
                            return Column(
                                      children: [
                                        TextFormField(
                                          cursorColor: Colors.grey,
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
                                        InkWell(
                                      onTap: () {
                                        setState(() {
                                          bankName =
                                              'Braket Wallet';
                                          bankCode =
                                              '000';
                                        });
                                        Navigator.of(context).pop(context);
                                      },
                                      child: BankListItem(
                                          data: const {'name':'Braket Wallet'}),)
                                      ],
                                    );
                                  
                          }
                            else {
                              // snapshot.data!['data'].insert(
                              //     0,);
                              List _data = List.from(banks);
                              // for (var e in data) {
                              //   if (!e['name'].toLowerCase().contains(query) && query != '') {
                              //     data.remove(e);
                              List data = List.from(_data);
                              // }}
                              if (query != '') {
                                data = _data;
                                data.removeWhere((e) => !e['name'].toLowerCase().contains(query.toLowerCase()));
                              }
                              if (data.isEmpty) {
                                data.insert(0,  {'name': 'Braket Wallet', 'code': 'logo'});
          
                              }
                              if (data[0]['name'] != 'Braket Wallet') {
                                // data.insert(0,  {'name': 'Braket Wallet', 'code': 'logo'});
          
                              }
                              return GroupedListView<dynamic, dynamic>(
                                shrinkWrap: true,
                                elements: data,
                                groupBy: (item) => item['name'][0],
                                useStickyGroupSeparators: true,
                                floatingHeader: true,
                                order: GroupedListOrder.ASC,
                                groupSeparatorBuilder: (dynamic groupByValue) => Container(
                                  height: 25,
                                  padding: const EdgeInsets.all(5),
                                  width: double.infinity,
                                  color: groupByValue == null ? Colors.transparent : Colors.transparent,
                                  child: Text(groupByValue)),
                                itemComparator: (item, item2) => item['name'].compareTo(item2['name']),
                                // itemCount: data.length,
                                indexedItemBuilder: (BuildContext context,  dynamic element, int index) {
                                  final a = [];
                                  // a.insert(index, element
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          bankName =
                                              element['name'];
                                          bankCode =
                                              element['code'];
                                        });
                                        Navigator.of(context).pop(context);
                                      },
                                      child: BankListItem(
                                          data: element),
                                    );
                                  
                                },
                              );
              }}),
                  ),
                );
              }
            ),
          );
        });
  }
}

class BankAvatar extends StatelessWidget {
  const BankAvatar({
    Key? key,
    required this.title,
    required this.code,
  }) : super(key: key);

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
              height: 50,
              margin: const EdgeInsets.all(2),
    
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration:
        BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
          child: Image.asset('bank_images/$code.png', width: 40,
                height: 40,
                fit: BoxFit.fill,)
        ),
        Text(title)
      ],
    );
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
          horizontalTitleGap: 5,
          leading: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(8),

              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration:
                  BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                data['name'].contains('Braket') ? 'assets/braket_logo.png' : 'bank_images/${data['code']}.png',
                width: 40,
                height: 40,
                fit: BoxFit.fill,
                errorBuilder: (context, exception, stackTrace) {
                  return Icon(Icons.account_balance, size:30, color: Theme.of(context).primaryColor);
                },
              )),
        ),
        Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.withAlpha(100),
            margin: const EdgeInsets.only(bottom: 0))
      ],
    );
  }
}
