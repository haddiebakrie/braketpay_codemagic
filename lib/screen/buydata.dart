import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../uix/askpin.dart';
class BuyData extends StatefulWidget {
  BuyData({Key? key, required this.user, required this.pin}) : super(key: key);

  User user;
  String pin;
  @override
  State<BuyData> createState() => _BuyDataState();
  // final User user;
}

class _BuyDataState extends State<BuyData> {
  Brakey brakey = Get.put(Brakey());
  int _networkIndex = 0;
  String phoneNumber = '';
  String key = '';
  Map fee = {'total_price': ''};
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final List _networkList = ['mtn', 'glo', 'airtel', 'etisalat'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Data'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
              decoration: ContainerBackgroundDecoration(),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: TextFormField(
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(24, 158, 158, 158),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Enter Phone number',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _networkIndex = 0;
                        fee = {'total_price': ''};
                        key:
                        '';
                      });
                    },
                    child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: _networkIndex == 0
                            ? const EdgeInsets.all(4)
                            : EdgeInsets.zero,
                        width: 60,
                        height: 60,
                        child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset('assets/mtn.png',
                                fit: BoxFit.contain))),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _networkIndex = 1;
                        fee = {'total_price': ''};
                        key:
                        '';
                      });
                    },
                    child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: _networkIndex == 1
                            ? const EdgeInsets.all(5)
                            : EdgeInsets.zero,
                        width: 60,
                        height: 60,
                        child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset('assets/glo.jpg',
                                fit: BoxFit.contain))),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _networkIndex = 2;
                        fee = {'total_price': ''};
                        key:
                        '';
                      });
                    },
                    child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: _networkIndex == 2
                            ? const EdgeInsets.all(5)
                            : EdgeInsets.zero,
                        width: 60,
                        height: 60,
                        child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset('assets/airtel.png',
                                fit: BoxFit.contain))),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _networkIndex = 3;
                        fee = {'total_price': ''};
                        key:
                        '';
                      });
                    },
                    child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: _networkIndex == 3
                            ? const EdgeInsets.all(5)
                            : EdgeInsets.zero,
                        width: 60,
                        height: 60,
                        child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset('assets/9mobile.png',
                                fit: BoxFit.fill))),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  _networkList[_networkIndex] != 'etisalat'
                      ? _networkList[_networkIndex].toUpperCase()
                      : '9Mobile',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount:
                    data_plan_rate['Network'][_networkList[_networkIndex]].length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        fee = data_plan_rate['Network']
                                ?[_networkList[_networkIndex]]
                            ?.values
                            .elementAt(index);
                        key = data_plan_rate['Network']
                                ?[_networkList[_networkIndex]]
                            ?.keys
                            .elementAt(index);
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: fee ==
                                    data_plan_rate['Network']
                                            ?[_networkList[_networkIndex]]
                                        ?.values
                                        .elementAt(index)
                                ? Theme.of(context).primaryColor
                                : Get.isDarkMode ? Color.fromARGB(255, 15, 15, 21) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                spreadRadius: 8,
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              )
                            ]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                data_plan_rate['Network']
                                            ?[_networkList[_networkIndex]]
                                        ?.values
                                        .elementAt(index)['about']
                                        .toString()
                                        .replaceAll('(SME)', '')
                                        .replaceAll('MTN Data', '')
                                        .replaceAll('Glo Data', '')
                                        .replaceAll('9mobile Data', '')
                                        .replaceAll('Airtel Data', '')
                                        .replaceAll('-', '\n')
                                        .split('=')[1] ??
                                    '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: fee ==
                                          data_plan_rate['Network']
                                                  ?[_networkList[_networkIndex]]
                                              ?.values
                                              .elementAt(index)
                                      ? Colors.white
                                      : Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                formatAmount(data_plan_rate['Network']?[_networkList[_networkIndex]]?.values.elementAt(index)['total_price'].toInt().toString() ?? ''),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: fee ==
                                          data_plan_rate['Network']
                                                  ?[_networkList[_networkIndex]]
                                              ?.values
                                              .elementAt(index)
                                      ? Colors.white
                                      : Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
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
                    print(fee);
                    print(key);
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!_formKey.currentState!.validate()) {
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
                                title: const Text("No phone number!"),
                                content: const Text('Please add a phone number'));
                          });
                      _loginButtonController.reset();
                      return;
                    } else if (fee['total_price'] == '') {
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
                                title: const Text("No plan selected!"),
                                content: const Text('Please select a plan'));
                          });
                      _loginButtonController.reset();
                      return;
                    }
                    // print('$username, $pin, $password');
                    // });
                    else {
                    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                        final _pinEditController = TextEditingController();
                          Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
                          if (pin == null || !pin.containsKey('pin')) {
                            _loginButtonController.reset();
                            return;
                          }
                      Map a = await buyData(
                          phoneNumber,
                          _networkList[_networkIndex],
                          widget.user.payload!.accountNumber ?? '',
                          fee['total_price'].toString(),
                          pin['pin'],
                          key);
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
                                        },
                                      )
                                    ],
                                    title: const Text("Can't complete transaction!"),
                                    content: Text(toTitleCase(a['Message']??'Failed to connect to Network, Please try again')));
                              });

                              // {Message: {data: {destination.amount: {message: destination.amount must be greater than or equal to 100}}, error: bad_request, message: invalid request data, status: false}, Response code: 400, Status: failed}
                        }}},
                      
                  child: Text(
                      'Pay ${fee["total_price"] == "" ? "" : formatAmount(fee['total_price'].toString())}',
                      style: const TextStyle(fontFamily: 'Roboto'))),
            )
          ],
        ),
      ),
    );
  }
}
