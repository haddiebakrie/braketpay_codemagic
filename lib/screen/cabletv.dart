
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';
import '../uix/askpin.dart';

class CableTV extends StatefulWidget {
  CableTV({Key? key, required this.user, required this.pin}) : super(key: key);

  @override
  State<CableTV> createState() => _CableTVState();
  final User user;
  final String pin;
}

class _CableTVState extends State<CableTV> {
  int _networkIndex = 0;
  String phoneNumber = '';
  String userName = '';
  String ownerName = '';
  Map fee = {'total_price': ''};
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final List _networkList = ['dstv', 'gotv', 'startimes'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Cable TV'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: ContainerBackgroundDecoration(),
        child: Column(
          
          children: [
            SizedBox(height:10),
            Container(
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _networkIndex = 0;
                        fee = {'total_price': ''};
                      });
                      setState(() {
                      ownerName = 'Fetching Meter detail.';
                    });
                    Map a = await getCableTVOwner(
                        widget.user.payload!.accountNumber ?? '',
                        widget.pin,
                        widget.user.payload?.password??'',
                        _networkList[_networkIndex],
                        userName);
                    setState(() {
                      ownerName = a.containsKey('Payload')
                          ? "Decoder Type: ${_networkList[_networkIndex].toUpperCase()}\n${a['Payload']['decoder_due_date']}\nDecoder Due date: ${a['Payload']['decoder_due_date']}\nStatus: ${a['Payload']['decoder_status']}"
                          : a.containsKey('Message')
                              ? a['Message']
                              : 'No Internet access';
                    });
                    },
                    child: Container(
                        padding: _networkIndex == 0
                            ? EdgeInsets.all(5)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 43, 255, 89),
                          // borderRadius: BorderRadius.circular(20),
                        ),
                        width: 60,
                        height: 60,
                        child:
                            Image.asset('assets/dstv.png', fit: BoxFit.contain)),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _networkIndex = 1;
                        fee = {'total_price': ''};
                      });
                      setState(() {
                      ownerName = 'Fetching Meter detail.';
                    });
                    Map a = await getCableTVOwner(
                        widget.user.payload!.accountNumber ?? '',
                        widget.pin,
                        widget.user.payload?.password??'',
                        _networkList[_networkIndex],
                        userName);
                    setState(() {
                      ownerName = a.containsKey('Payload')
                          ? "Decoder Type: ${_networkList[_networkIndex].toUpperCase()}\n${a['Payload']['decoder_due_date']}\nDecoder Due date: ${a['Payload']['decoder_due_date']}\nStatus: ${a['Payload']['decoder_status']}"
                          : a.containsKey('Message')
                              ? a['Message']
                              : 'No Internet access';
                    });
                    },
                    child: Container(
                        padding: _networkIndex == 1
                            ? EdgeInsets.all(5)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 43, 255, 89),
                          // borderRadius: BorderRadius.circular(20),
                        ),
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/gotv.png', fit: BoxFit.fill)),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _networkIndex = 2;
                        fee = {'total_price': ''};
                      });
                      setState(() {
                      ownerName = 'Fetching Meter detail.';
                    });
                    Map a = await getCableTVOwner(
                        widget.user.payload!.accountNumber ?? '',
                        widget.pin,
                        _networkList[_networkIndex],
                        userName,
                        widget.user.payload?.password??'',
                        );
                    setState(() {
                      ownerName = a.containsKey('Payload')
                          ? "Decoder Type: ${_networkList[_networkIndex].toUpperCase()}\n${a['Payload']['decoder_due_date']}\nDecoder Due date: ${a['Payload']['decoder_due_date']}\nStatus: ${a['Payload']['decoder_status']}"
                          : a.containsKey('Message')
                              ? a['Message']
                              : 'No Internet access';
                    });
                    },
                    child: Container(
                        padding: _networkIndex == 2
                            ? EdgeInsets.all(5)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 43, 255, 89),
                          // borderRadius: BorderRadius.circular(20),
                        ),
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/startimes.jpg',
                            fit: BoxFit.contain)),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: ContainerBackgroundDecoration(),
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: TextFormField(
                  cursorColor: Colors.grey,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(24, 158, 158, 158),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Enter Unique number',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onChanged: (text) async {
                    setState(() {
                      ownerName = 'Fetching Meter detail.';
                    });
                    userName = text;
                    phoneNumber = text.trim();
                    Map a = await getCableTVOwner(
                        widget.user.payload!.accountNumber ?? '',
                        widget.pin,
                        widget.user.payload?.password??'',
                        _networkList[_networkIndex],
                        text.trim());
                    setState(() {
                      ownerName = a.containsKey('Payload')
                          ? "Decoder Type: ${_networkList[_networkIndex].toUpperCase()}\n${a['Payload']['decoder_due_date']}\nDecoder Due date: ${a['Payload']['decoder_due_date']}\nStatus: ${a['Payload']['decoder_status']}"
                          : a.containsKey('Message')
                              ? a['Message']
                              : 'No Internet access';
                    });
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
            InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: Color.fromARGB(24, 158, 158, 158),
                child: Text(ownerName, style: TextStyle(fontSize: 18)),
              ),
              onTap: () async {
                setState(() {
                      ownerName = 'Fetching Meter detail.';
                    });
                    Map a = await getCableTVOwner(
                        widget.user.payload!.accountNumber ?? '',
                        widget.pin,
                        widget.user.payload?.password??'',
                        _networkList[_networkIndex],
                        userName);
                    setState(() {
                      ownerName = a.containsKey('Payload')
                          ? "Decoder Type: ${_networkList[_networkIndex].toUpperCase()}\n${a['Payload']['decoder_due_date']}\nDecoder Due date: ${a['Payload']['decoder_due_date']}\nStatus: ${a['Payload']['decoder_status']}"
                          : a.containsKey('Message')
                              ? a['Message']
                              : 'No Internet access';
                    });
              }
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_networkList[_networkIndex].toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: cable_tv_plan_rate['Cable_TV']
                        [_networkList[_networkIndex]]
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        fee = cable_tv_plan_rate['Cable_TV']
                                ?[_networkList[_networkIndex]]
                            ?.values
                            .elementAt(index);
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: fee ==
                                    cable_tv_plan_rate['Cable_TV']
                                            ?[_networkList[_networkIndex]]
                                        ?.values
                                        .elementAt(index)
                                ? Theme.of(context).primaryColor
                                : Get.isDarkMode ? Color.fromARGB(255, 15, 15, 21) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.04),
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
                                cable_tv_plan_rate['Cable_TV']
                                            ?[_networkList[_networkIndex]]
                                        ?.values
                                        .elementAt(index)['about']
                                        .toString()
                                        .replaceAll('DStv', '')
                                        .replaceAll('GOtv', '')
                                        .replaceAll('Startimes', '')
                                        .replaceAll('+', '\n')
                                        .split('=')[1] ??
                                    '',
                                style: TextStyle(
                                  color: fee ==
                                          cable_tv_plan_rate['Cable_TV']
                                                  ?[_networkList[_networkIndex]]
                                              ?.values
                                              .elementAt(index)
                                      ? Colors.white
                                      : Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "${formatAmount(cable_tv_plan_rate['Cable_TV']?[_networkList[_networkIndex]]?.values.elementAt(index)['total_price'].toInt().toString() ?? '')}",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: fee ==
                                          cable_tv_plan_rate['Cable_TV']
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
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    if (fee['total_price'] == '') {
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
                    }
                    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                          final _pinEditController = TextEditingController();
                            Map? pin = await askPin(_pinEditController, _pinErrorController,
                            topWidget: GlassContainer(
                            // color: Colors.red,
                            child: Container(
                            padding: EdgeInsets.all(10),
                            height: 70,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.asset('assets/${_networkList[_networkIndex]}.png',
                                  fit: BoxFit.contain)),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Phone: $phoneNumber', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                                      Text('Amount: ${nairaSign()}${fee['total_price']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                                      Text('Charges: ${nairaSign()}0.00', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))
                                    ]
                                  )
                                ],
                              ),
                            ),
                          )
                            
                            );
                            
                            if (pin == null || !pin.containsKey('pin')) {
                              _loginButtonController.reset();
                              return;
                            };
                              _loginButtonController.reset();
                    // print('$username, $pin, $password');
                    // Future<User> a =
                    //     loginUser(username, password, pin);
                    // a.then((value) => a.whenComplete(() {
                    //       _loginButtonController.success();
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => Manager(
                    //                   user: value, pin: pin)));
                    //     }));
                    // a.onError((error, stackTrace) {
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
                    //             title: const Text("Can't Login!"),
                    //             content: const Text(
                    //                 'Please check your Internet connection'));
                    //       });
                    //   throw Exception(error);
                    // });
                  } else {
                    _loginButtonController.reset();
                  }
                },
                child: Text(
                    'Pay ${fee["total_price"] == "" ? "" : formatAmount(fee['total_price'].toString())}',
                    style: TextStyle(fontFamily: 'Roboto')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
