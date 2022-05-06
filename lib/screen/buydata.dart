import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BuyData extends StatefulWidget {
  BuyData({Key? key, required this.user, required this.pin}) : super(key: key);

  User user;
  String pin;
  @override
  State<BuyData> createState() => _BuyDataState();
  // final User user;
}

class _BuyDataState extends State<BuyData> {
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
      appBar: AppBar(
        title: Text('Data'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: TextFormField(
                cursorColor: Colors.black,
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
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
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
                          ? EdgeInsets.all(4)
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
                GestureDetector(
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
                          ? EdgeInsets.all(5)
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
                GestureDetector(
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
                          ? EdgeInsets.all(5)
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
                GestureDetector(
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
                          ? EdgeInsets.all(5)
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
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount:
                  data_plan_rate['Network'][_networkList[_networkIndex]].length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
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
                              ? Colors.deepOrange
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
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
                                fontSize: 17,
                                color: fee ==
                                        data_plan_rate['Network']
                                                ?[_networkList[_networkIndex]]
                                            ?.values
                                            .elementAt(index)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${formatAmount(data_plan_rate['Network']?[_networkList[_networkIndex]]?.values.elementAt(index)['total_price'].toInt().toString() ?? '')}",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: fee ==
                                        data_plan_rate['Network']
                                                ?[_networkList[_networkIndex]]
                                            ?.values
                                            .elementAt(index)
                                    ? Colors.white
                                    : Colors.black,
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
                    Future<bool> a = buyData(
                        phoneNumber,
                        _networkList[_networkIndex],
                        widget.user.payload!.accountNumber ?? '',
                        fee['total_price'].toString(),
                        widget.pin,
                        key);
                    a.then(
                      (value) => a.whenComplete(
                        () {
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
                                          _loginButtonController.success();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                    title: const Text("Success!"),
                                    content: const Text(
                                        'Your transaction was successful, Check your transaction history for your reciept'));
                              });
                        },
                      ),
                    );

                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => Manager(
                    //                   user: value, pin: pin)));
                    // }));
                    a.onError((error, stackTrace) {
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
                                title: const Text("Can't Complete Transaction!"),
                                content: const Text(
                                    'Please check your Internet connection'));
                          });
                          throw Exception(error);
                    });
                  }
                },
                child: Text(
                    'Pay ${fee["total_price"] == "" ? "" : formatAmount(fee['total_price'].toString())}',
                    style: TextStyle(fontFamily: 'Roboto'))),
          )
        ],
      ),
    );
  }
}
