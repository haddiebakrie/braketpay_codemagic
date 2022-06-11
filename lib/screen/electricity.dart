import 'package:braketpay/api_callers/pay.dart';
import 'package:braketpay/api_callers/utilities.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:braketpay/utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


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
      appBar: AppBar(
        title: Text('Electricity'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        
        children: [
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _networkIndex = 0;
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
                      child: Column(
                        children: [
                          Container(
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
                                  Image.asset('assets/Abuja-Electricity.jpg', fit: BoxFit.fill)),
                                  Text(_networkList[0].replaceAll('-electric', '').toUpperCase())
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _networkIndex = 1;
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
                      child: Column(
                        children: [
                          Container(
                              padding: _networkIndex == 1
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 43, 255, 89),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/eko-electric.jpg', fit: BoxFit.fill)),
                                  Text(_networkList[1].replaceAll('-electric', '').toUpperCase())
                        
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _networkIndex = 2;
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
                      child: Column(
                        children: [
                          Container(
                              padding: _networkIndex == 2
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 43, 255, 89),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/ibadan-electricpng.png',
                                  fit: BoxFit.fill)),
                                  Text(_networkList[2].replaceAll('-electric', '').toUpperCase())
                        
                        ],
                      ),
                    ),
                    GestureDetector(
                          onTap: () async {
                            setState(() {
                              _networkIndex = 3;
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
                          child: Column(
                            children: [
                              Container(
                                  padding: _networkIndex == 3
                                      ? EdgeInsets.all(5)
                                      : EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 43, 255, 89),
                                    // borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: 60,
                                  height: 60,
                                  child: Image.asset('assets/Ikeja-Electric.jpg',
                                      fit: BoxFit.fill)),
                                  Text(_networkList[3].replaceAll('-electric', '').toUpperCase())
                            
                            ],
                          ),
                        ),
                    ],),
                    SizedBox(height:20),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _networkIndex = 4;
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
                      
                      child: Column(
                        children: [
                          Container(
                              padding: _networkIndex == 4
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 43, 255, 89),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/jed.jpg',
                                  fit: BoxFit.contain)),
                                  Text(_networkList[4].replaceAll('-electric', '').toUpperCase())

                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _networkIndex = 5;
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
                      
                      child: Column(
                        children: [
                          Container(
                              padding: _networkIndex == 5
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 43, 255, 89),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/kaduna-electric.jfif',
                                  fit: BoxFit.fill)),
                                  Text(_networkList[5].replaceAll('-electric', '').toUpperCase())

                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _networkIndex = 6;
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
                      
                      child: Column(
                        children: [
                          Container(
                              padding: _networkIndex == 6
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 43, 255, 89),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/KEDCO.png',
                                  fit: BoxFit.contain)),
                                  Text(_networkList[6].replaceAll('-electric', '').toUpperCase())

                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _networkIndex = 7;
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
                      
                      child: Column(
                        children: [
                          Container(
                              padding: _networkIndex == 7
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 43, 255, 89),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/ph-electric.jpg',
                                  fit: BoxFit.contain)),
                                  Text(_networkList[7].replaceAll('-electric', '').toUpperCase())

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
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
          GestureDetector(
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
          Expanded(
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: electricity_plan_rate['ServiceType'].length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
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
                              style: TextStyle(fontSize: 17,color: fee == electricity_plan_rate['ServiceType']
                                       ?.values.elementAt(index) ? Colors.white : Colors.black, ),
                              textAlign: TextAlign.center,
                                ),
                            Text(
                              "${formatAmount(electricity_plan_rate['ServiceType']?.values.elementAt(index)['total_price'].toInt().toString() ?? '')}",
                              style: TextStyle(fontSize: 20, fontFamily: 'Roboto',fontWeight: FontWeight.bold,color: fee == electricity_plan_rate['ServiceType']
                                        ?.values.elementAt(index) ? Colors.white : Colors.black, ),
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
                        _loginButtonController.reset();}
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
    );
  }
}
