import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/contracts.dart';
import '../api_callers/userinfo.dart';
import '../brakey.dart';
import '../classes/user.dart';
import '../ngstates.dart';
import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class ServicePrompt extends StatefulWidget {
  ServicePrompt({Key? key, required this.user, required this.creatorType})
      : super(key: key);

  User user;
  String creatorType;

  @override
  State<ServicePrompt> createState() => _ServicePromptState();
}

class _ServicePromptState extends State<ServicePrompt> {
    Map opposites = {
    "Provider" : "Client",
    "Client" : "Provider"
  };
bool isUsername = true;
  late String username;
  late String receiverName = 'Unknown';
  late String receiveraddr;
  int pageIndex = 0;
  String contractTitle = '';
  int lastPhase = 0;
  String logisticLoc = '';
  double downPayment = 0;
  String deliveryDate = 'YYYY-MM-DD';
  final _formKey = GlobalKey<FormState>();
  final _stageFormKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();

  List<ServicePhaseField> stages = [];
  String dummyPhaseTitle='';
  String dummyPhaseCost='';
  final _dummyController = TextEditingController();
  final _dummyCController = TextEditingController();
  final TextEditingController _usernameFieldController = TextEditingController();
  final TextEditingController _priceFieldController = TextEditingController();
  final TextEditingController _locFieldController = TextEditingController();
  final TextEditingController _titleFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Theme.of(context).primaryColor),
                Image.asset('assets/braket-bg_grad-01.png', height: 300, fit: BoxFit.cover, width: double.infinity,),

        Scaffold(
          extendBody: true,
backgroundColor: Colors.transparent,
          appBar: AppBar(
backgroundColor: Colors.transparent,
            elevation: 0,
              title: Text('${widget.creatorType} Contract'),
            ),
            body: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                widget.creatorType == 'Provider'
                    ? Container(
                        // margin: Ed,
                        // height: 200,
                        child: Stack(alignment: Alignment.topRight, children: [
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            Image.asset(
                              'assets/cleaning-supplies.png',
                              width: 160,
                            ),
                            SizedBox(width: 20,)
                          ],
                        ),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Get paid ",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white)),
                                  const Text("for every",
                                      style: TextStyle(
                                          fontSize: 35, color: Colors.white)),
                                  const Text('SWEAT',
                                      style: TextStyle(
                                          fontSize: 60, color: Colors.white)),
                                  // const Text('LOAN', style: TextStyle(fontSize: 60, color: Colors.white)),
                                  FittedBox(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: ContainerDecoration(),
                                              padding: const EdgeInsets.all(5),
                                              child: const Text('\u2713 Split your work into stages', style: TextStyle(fontSize: 9,))),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                decoration: ContainerDecoration(),
                                                padding: const EdgeInsets.all(5),
                                                child: const Text(
                                                    '\u2713 Receive payment for every stage completed',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                    ))),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [

                                            Container(
                                                decoration: ContainerDecoration(),
                                                padding: const EdgeInsets.all(5),
                                                child: const Text(
                                                    '\u2713 Become a Braket worthy Service Provider to be  trusted by clients',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),
                      ]))
                    : Container(
                        height: 200,
                        child: Stack(alignment: Alignment.topRight, children: [
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            Image.asset(
                              'assets/cleaning-supplies.png',
                              height: 170,
                            ),
                          
                          ],
                        ),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Avoid losing",
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white)),
                                  // const Text("what you", style: TextStyle(fontSize: 30, color: Colors.white)),
                                  const Text('Money',
                                      style: TextStyle(
                                          fontSize: 55, color: Colors.white)),
                                  // const Text('SCAMMED',
                                  //     style: TextStyle(
                                  //         fontSize: 50, color: Colors.white)),
                                  FittedBox(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [

                                            Container(
                                                decoration: ContainerDecoration(),
                                                padding: const EdgeInsets.all(5),
                                                child: const Text(
                                                    '\u2713 Increase your contractor work performance',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                    ))),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: ContainerDecoration(),
                                              padding: const EdgeInsets.all(5),
                                              child: const Text('\u2713 Split the work into stages', style: TextStyle(fontSize: 9,))),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                decoration: ContainerDecoration(),
                                                padding: const EdgeInsets.all(5),
                                                child: const Text(
                                                    '\u2713 Only pay for completed stage',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),
                      ])),
                Container(
                  width: double.infinity,
                  decoration: ContainerBackgroundDecoration(),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    // const SizedBox(height: 20),
                    Form(
                key: _formKey,
                child: Column(children: [
                  
                    Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  controller: _usernameFieldController,
                                  cursorColor: Colors.grey,
                                  decoration: InputDecoration(
                                    fillColor: Color.fromARGB(24, 158, 158, 158),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    hintText: "@ ${opposites[widget.creatorType]}'s username",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onChanged: (text) async {
                                    setState(() {
                                      receiverName = 'Looking for user...';
                                    });
                                    Map a = await getUserWith(text.trim(), 'username');
                                    print(a);
                                      if (!a.containsKey('Status')) {
                                        setState(() {
                                        receiverName = 'No Internet access (Tap to retry)';
                                          
                                        });
                                        return;
                                      }
                                  receiverName = a.containsKey('Payload')
                                      ? a['Payload']['fullname']
                                      : 'Incorrect Braket Account';
                                    username = text.trim();
                                    setState(() {
                                      if (a.containsKey('Payload') && a['Payload']['wallet_address'] == widget.user.payload!.walletAddress) {
                                          setState(() {
                                            receiverName =
                                                "You can't create a contract with yourself";
                                          });
                                          return;
                                      }
                                      if (a.containsKey('Payload')) {
                                          setState(() {
                                            receiveraddr = a['Payload']['wallet_address'];
                                          });
                                          return;
                                      }
                                    receiverName = 'Looking for user...';
                                        receiverName = a.containsKey('Payload')
                                      ? '${a['Payload']['fullname']}'
                                            : a.containsKey('Message')
                                                ? a['Message']
                                                : 'No Internet access (Tap to retry)';
                                      });
                                    // username = text.trim();
                                    // Future<Map<String, dynamic>> fullname =
                                    //     getUserInfo(text);
                                    // fullname.then((value) {
                                    //   if (value.containsKey('Payload')) {
                                    //     if (value['Payload']['wallet_address'] ==
                                    //         widget.user.payload!.walletAddress) {
                                    //       setState(() {
                                    //         receiverName =
                                    //             "You can't create a contract with yourself";
                                    //       });
                                    //     } else {
                                    //       setState(() {
                                    //         receiverName = value['Payload']['fullname'];
                                    //         receiveraddr =
                                    //             value['Payload']['wallet_address'];

                                    //         // print(value);
                                    //       });
                                    //     }
                                    //   } else {
                                    //     setState(() {
                                    //       receiverName =
                                    //           'This username does not match any user';
                                    //     });
                                    //   }
                                    // });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'The second party is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                setState(() {
                                  receiverName = 'Looking for user...';
                                });
                                  Map a = await getUserWith(username, 'username');
                                    print(a);
                                      if (!a.containsKey('Status')) {
                                        setState(() {
                                        receiverName = 'No Internet access (Tap to retry)';
                                          
                                        });
                                        return;
                                      }
                                  receiverName = a.containsKey('Payload')
                                      ? a['Payload']['fullname']
                                      : 'Incorrect Braket Account';
                                    
                                    setState(() {
                                      if (a.containsKey('Payload') && a['Payload']['wallet_address'] == widget.user.payload!.walletAddress) {
                                          setState(() {
                                            receiverName =
                                                "You can't create a contract with yourself";
                                          });
                                          return;
                                      }
                                    receiverName = 'Looking for user...';
                                        receiverName = a.containsKey('Payload')
                                      ? '${a['Payload']['fullname']}'
                                            : a.containsKey('Message')
                                                ? a['Message']
                                                : 'No Internet access (Tap to retry)';
                                      });
                                },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/avatar-03.png',
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, exception, stackTrace) {
                                    return const SizedBox();
                                  },
                                ),
                                  const SizedBox(width:5),
                                  FittedBox(child: Text(receiverName)),
                            ]),
                          ),
                            ],
                          ),         

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Contract title',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        TextFormField(
                          controller: _titleFieldController,
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Ex Contract for Room cleaning',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            contractTitle = text.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'The contract title is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Form(
                      key: _stageFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Service rendering phases (minimum of 3 phase)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey,
                              margin: EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                                itemCount: stages.length,
                                itemBuilder: (context, index) {
                                  print("${index}, ${stages.length}");
                                  if (index+1 == stages.length) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                      stages[index],
                                      TextButton(child: Text('Delete'),onPressed: (){

                                        setState(() {
                                          stages.removeLast();
                                          lastPhase--;
                                        });

                                      })
                                    ],);
                                  }
                                  return stages[index];
                                },),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Rendering Phase ${lastPhase + 1}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                    
                          TextFormField(
                            controller: _dummyController,
                            cursorColor: Colors.grey,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Empty',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onChanged: (text) {
                              setState(() {
                                dummyPhaseTitle = text.trim();
                                
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field can't be empty";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _dummyCController,
                            cursorColor: Colors.grey,
                            keyboardType: TextInputType.numberWithOptions(),
                    
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Cost of phase',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onChanged: (text) {
                              setState(() {
                              dummyPhaseCost = text.trim();
                                
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field can't be empty";
                              }
                              return null;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Text('Add Phase'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 30, 0)
                                  ),
                                foregroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 255,255, 255),
                                  ),
                                ),
                                onPressed: () {
                                  if (!_stageFormKey.currentState!.validate()) {

                                  } else {
                                    setState(() {
                                    stages.add(ServicePhaseField(index:lastPhase, phaseTitle:dummyPhaseTitle, phaseCost:dummyPhaseCost));
                                    lastPhase++;
                                    _dummyController.clear();
                                    _dummyCController.clear();
                                    });
                                  }


                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
  
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                
                            child: const Text(
                              'Location',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                              Container(
                                padding: EdgeInsets.only(left:10),
                                decoration: BoxDecoration(
                                color: const Color.fromARGB(24, 158, 158, 158),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                margin: EdgeInsets.symmetric(vertical:10),
                                child: DropdownSearch<dynamic>(
                                    onChanged:(e) {
                                      logisticLoc = e;
                                    },
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: 'Select State',
                                    border: InputBorder.none,
                                    // filled: true,
                                  ),
                                  // showSearchBox: true,
                                  // showClearButton: true,
                                  mode: Mode.BOTTOM_SHEET,
                                  searchDelay: Duration.zero,
                                  items: ngStates.map((e) => e['name']).toList(),
                                  selectedItem: logisticLoc != '' ? logisticLoc : 'Select State'
                                ),
                              ),
                            ],
                          ), 
                                                    Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: const Text(
                                    'Service delivery date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    final now = DateTime.now();
                                    _loginButtonController.reset();
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    DatePicker.showDatePicker(context,
                                        minTime: DateTime(now.year, now.month, now.day+1),
                                        currentTime: deliveryDate == 'YYYY-MM-DD'
                                            ? DateTime(now.year, now.month, now.day+1)                                 : DateTime.tryParse(deliveryDate),
                                        maxTime: DateTime(2101), onConfirm: (date) {
                                      setState(() {
                                        deliveryDate =
                                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                      });
                                    });

                                    print(deliveryDate);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Icon(IconlyBold.calendar, color: Theme.of(context).primaryColor),
                                        ),
                                        SizedBox(width:3),
                                        Expanded(
                                          child: Text(deliveryDate,
                                              style: const TextStyle(fontSize: 16)),
                                        ),
                                        Icon(Icons.arrow_drop_down, color: Colors.grey)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                            ],
                          ),
                          ),
                           
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Downpayment',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ),
                                TextFormField(
                                  controller: _priceFieldController,
                                  cursorColor: Colors.grey,
                                  style: TextStyle(
                                  fontSize: 40,
                                ),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                  icon: Text(nairaSign(), style:TextStyle(fontSize: 40, color: Colors.grey)),
                                  prefixStyle: TextStyle(color: Colors.grey),
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  // filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                    color: Colors.grey
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding: EdgeInsets.zero
                                ),
                                  onChanged: (text) {
                                    downPayment = double.parse(text.trim());
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Downpayment is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                 RoundedLoadingButton(
                    borderRadius: 10,
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    controller: _loginButtonController,
                    child: Text('Create'),
                    onPressed: () async {
                      if (contractTitle=='') {
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
                                                title:
                                                    const Text("All fields are required!"),
                                                content: const Text(
                                                    'Enter the contract title'));
                                          });
                              _loginButtonController.reset();
                                  return;
                            }
                            if (logisticLoc=='' || downPayment==0) {
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
                                                title:
                                                    const Text("All fields are required!"),
                                                content: const Text(
                                                    'Select Service delivery Location'));
                                          });}
                              if (downPayment==0) {
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
                                                title:
                                                    const Text("All fields are required!"),
                                                content: const Text(
                                                    'Enter a valid downpayment'));
                                          });
                              _loginButtonController.reset();
                                  return;
                            }
                      if (!_formKey.currentState!.validate()) {
                        _loginButtonController.reset();
                      }else if (receiverName == 'This username does match any user' || receiverName == "You can't create a contract with yourself" || receiverName == 'Unknown' || receiverName == 'username not recognise for an exisiting account' || receiverName == 'No Internet access (Tap to retry)') {
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
                                          title:
                                              const Text("Invalid Receiver username!"),
                                          content: const Text(
                                              'Enter a valid username'));
                                    });
                      } else if (stages.length < 3) {
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
                                          title:
                                              const Text("Minimum stages not met!"),
                                          content: const Text(
                                              'Please add at least 3 stages'));
                                    });
                      }
                      
                      else if (deliveryDate == 'YYYY-MM-DD') {
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
                                          title:
                                              const Text("Delivery date not set!"),
                                          content: const Text(
                                              'Please choose a delivery date'));
                                    });
                      } 
                      else {
                        
                        Map _stages = {};
                        stages.forEach((ServicePhaseField element) {
                          _stages.addAll({"Stage_${element.index+1}":{"about_stage":element.phaseTitle, "cost_of_stage":double.parse(element.phaseCost)}});
                        },); 

                        print(_stages.toString());
                        StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                                final _pinEditController = TextEditingController();
                                  Map? pin = await askPin(_pinEditController, _pinErrorController);
                            print(pin);
                            if (pin == null || !pin.containsKey('pin')) {
                              _loginButtonController.reset();
                              return;
                            };
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return AlertDialog(
                                  title: Text(
                                    'YOU ARE CREATING A SERVICE CONTRACT \nWITH\n ${receiverName.toUpperCase()}',
                                    textAlign: TextAlign.center,
                                  ),
                                  // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                                  content: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                    Text('Creating Contract....',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))
                                  ]));
                            });
                        Map a = await createServiceContract(
                            widget.creatorType.toLowerCase(),
                            widget.creatorType.toLowerCase() == 'client'
                                ? widget.user.payload!.walletAddress ?? ''
                                : receiveraddr,
                            widget.creatorType.toLowerCase() == 'provider'
                                ? widget.user.payload!.walletAddress ?? ''
                                : receiveraddr,
                            widget.user.payload!.bvn ?? '',
                            contractTitle,
                            jsonEncode(_stages),
                            logisticLoc,
                            downPayment.toString(),
                            deliveryDate,
                            pin['pin']);
                            if (a.containsKey('Status')) {
                                        if (a['Status'] == 'successful') {
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
                                                          Navigator.of(context)
                                                              .pop();
                                                              Navigator.of(context)
                                                              .pop();
                                                              Navigator.of(context)
                                                              .pop();
                                                              Navigator.of(context)
                                                              .pop();
                                                              _loginButtonController.reset();
                                                        },
                                                      )
                                                    ],
                                                    title: const Text(
                                                        "Contract created successfully"),
                                                    content: Text(toTitleCase(a['Message'])));
                                              });
                                        } else {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('Okay'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                              Navigator.of(context)
                                                              .pop();
                                                              _loginButtonController.reset();
                                                        },
                                                      )
                                                    ],
                                                    title: const Text(
                                                        "Contract creation failed"),
                                                    content: Text(toTitleCase(a['Message'])));
                                              });
                                        }
                                      } else {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('Okay'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                              _loginButtonController.reset();
                                                          Navigator.of(context)
                                                              .pop();
                                                          // Navigator.of(context)
                                                          //     .pop();
                                                        },
                                                      )
                                                    ],
                                                    title: const Text(
                                                        "Failed"),
                                                    content: Text(toTitleCase(a['Message'])));
                                      })
                                      ;};
                                          // 

                      }
                    },
                  ),

                
                 
                   SizedBox(height: 50)

                ])),
         
                  ]),
                )
              ]),
            )),
      ],
    );
  }
}


class ServicePhaseField extends StatelessWidget {
  ServicePhaseField({Key? key, required this.index, required this.phaseTitle, required this.phaseCost}) : super(key: key);

  int index;
  String phaseTitle;
  String phaseCost;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Rendering Phase ${index + 1}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ),
            TextFormField(
              initialValue: phaseTitle,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(24, 158, 158, 158),
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                hintText: 'Empty',
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "This field can't be empty";
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: phaseCost,
              cursorColor: Colors.grey,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.numberWithOptions(),

              decoration: const InputDecoration(
                fillColor: Color.fromARGB(24, 158, 158, 158),
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                hintText: 'Cost of phase',
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "This field can't be empty";
                }
                return null;
              })]),
    );
  }
}