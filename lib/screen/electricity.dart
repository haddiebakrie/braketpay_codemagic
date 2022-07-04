import 'dart:async';

import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';


class Electricity extends StatefulWidget {
  Electricity({Key? key, required this.user, required this.pin}) : super(key: key);

  @override
  State<Electricity> createState() => _ElectricityState();
  final User user;
  final String pin;
}

class _ElectricityState extends State<Electricity> {
  int _networkIndex = 0;
  String phoneNumber = '';
  String ownerName = '';
  Map fee = {'total_price': ''};
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
    RoundedLoadingButtonController();
  final List _networkList = ['abuja-electric', 'eko-electric', 'ibadan-electric', 'ikeja-electric',
  "jos-electric", "kaduna-electric", "kano-electric", "portharcout-electric"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Electricity'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
            // padding: const EdgeInsets.all(10),
                  decoration: ContainerBackgroundDecoration(),
            child: ListView(
              
              children: [
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.all(5),
                  child: GridView.builder(
                    itemCount: _networkList.length,

                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                            onTap: () async {
                              setState(() {
                                _networkIndex = index;
                                fee = {'total_price': ''};
                              });
                              setState(() {
                                  ownerName = 'Fetching Meter detail.';
                                });
                                Map a = await getMeterOwner(
                                    widget.user.payload!.accountNumber ?? '',
                                    widget.pin,
                                    _networkList[_networkIndex],
                                    phoneNumber);
                                setState(() {
                                  ownerName = a.containsKey('Payload')
                                      ? "\n${a['Payload']['decoder_due_date']}\nDecoder Due date: ${a['Payload']['decoder_due_date']}\nStatus: ${a['Payload']['decoder_status']}"
                                      : a.containsKey('Message')
                                          ? a['Message']
                                          : 'No Internet access';
                                });
                            },
                            child: ElectricityGridItem(networkIndex: _networkIndex, networkList: _networkList, imageUrl: 'assets/${_networkList[index]}.jpg', index: index)
                  );}, 
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
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
                                hintText: 'Enter Meter number',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                                onChanged: (text) async {
                                  setState(() {
                                  phoneNumber = text.trim();
                                    ownerName = 'Fetching Meter detail.';
                                  });
                                  Map a = await getMeterOwner(
                                      widget.user.payload!.accountNumber ?? '',
                                      widget.pin,
                                      _networkList[_networkIndex],
                                      text.trim());
                                  setState(() {
                                    ownerName = a.containsKey('Payload')
                                        ? "\n${a['Payload']['decoder_due_date']}\nDecoder Due date: ${a['Payload']['decoder_due_date']}\nStatus: ${a['Payload']['decoder_status']}"
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
                                  Map a = await getMeterOwner(
                                      widget.user.payload!.accountNumber ?? '',
                                      widget.pin,
                                      "ikeja-electric",
                                      phoneNumber.trim());
                                  setState(() {
                                    ownerName = a.containsKey('Payload')
                                        ? "\n${a['Payload']['decoder_due_date']}\nDecoder Due date: ${a['Payload']['decoder_due_date']}\nStatus: ${a['Payload']['decoder_status']}"
                                        : a.containsKey('Message')
                                            ? a['Message']
                                            : 'No Internet access';
                                  });
                  }
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Electricity Plans', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: electricity_plan_rate['ServiceType'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            fee = electricity_plan_rate['ServiceType']
                                ?.values
                                .elementAt(index);
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical:10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                            color: fee ==
                                        electricity_plan_rate['ServiceType']
                                            ?.values
                                            .elementAt(index)
                                    ? Theme.of(context).primaryColor
                                : Get.isDarkMode ? Color.fromARGB(255, 15, 15, 21) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            
                            boxShadow: [ 
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.04),
                                spreadRadius: 8,
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              )
                            ]),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(electricity_plan_rate['ServiceType']
                                              
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
                                    style: TextStyle(color: fee == electricity_plan_rate['ServiceType']
                                             ?.values.elementAt(index) ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color, ),
                                    textAlign: TextAlign.center,
                                      ),
                                  Text(
                                    "${formatAmount(electricity_plan_rate['ServiceType']?.values.elementAt(index)['total_price'].toInt().toString() ?? '')}",
                                    style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,color: fee == electricity_plan_rate['ServiceType']
                                              ?.values.elementAt(index) ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color, ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
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
                              return;

                          } else if (!ownerName.contains('"Decoder Due date"')) {
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
                                    title: const Text("Invalid Meter Number!"),
                                    content: const Text('Please use a valid Meter number'));
                              });
                              _loginButtonController.reset();
                          return;
                          } 
                          
                          else {
                              _loginButtonController.reset();
                              StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                              final _pinEditController = TextEditingController();
                                Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
                          if (pin == null || !pin.containsKey('pin')) {
                            _loginButtonController.reset();
                            return;
                          };
                                  _loginButtonController.reset();

                              }
                          
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
                        style: TextStyle(fontFamily: 'Roboto'))),
                )
              ],
            ),
          ),
    );
  }
}

class ElectricityGridItem extends StatelessWidget {
  ElectricityGridItem({
    Key? key,
    required int networkIndex,
    required this.index,
    required this.imageUrl,
    required List networkList,
  }) : _networkIndex = networkIndex, _networkList = networkList, super(key: key);

  final int _networkIndex;
  final int index;
  final List _networkList;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: _networkIndex == index
                ? EdgeInsets.all(3)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 255),
              borderRadius: BorderRadius.circular(25),
            ),
            width: 50,
            height: 50,
            child:
                Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),child: Image.asset(imageUrl, fit: BoxFit.contain))),
            SizedBox(height: 5,),
                Text(toTitleCase(_networkList[index].replaceAll('-electric', '')), style: TextStyle(fontSize: 13))
      ],
    );
  }
}
