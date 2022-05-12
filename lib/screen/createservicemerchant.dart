import 'dart:convert';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productprocess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:iconly/iconly.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MerchantCreateService extends StatefulWidget {
  MerchantCreateService({Key? key, required this.creatorType, required this.user, required this.pin})
      : super(key: key);

  final String creatorType;
  final User user;
  final String pin;

  @override
  State<MerchantCreateService> createState() => _MerchantCreateServiceState();
}

class _MerchantCreateServiceState extends State<MerchantCreateService> {
  bool isUsername = true;
  late String username;
  late String receiverName = 'Unknown';
  late String receiveraddr;
  late String contractTitle;
  int lastPhase = 0;
  late String logisticLoc;
  late double downPayment;
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
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
          title: Column(
            children: [
              Text('Service Contract'),
              // Text(
              //       // 'You are creating this contract as a ${widget.creatorType}',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 18,
              //       )),
            ],
          ), centerTitle: true, elevation: 0),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(29), topRight: Radius.circular(20))),
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListView(children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                // ],
                // );
                
                Container(
                    color: Colors.grey.withAlpha(20),
                    height: 40,
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: isUsername
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 30, 0))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(0, 255, 255, 255)),
                            ),
                            child: Text(
                              'Username',
                              style: TextStyle(
                                color: isUsername
                                    ? Colors.white
                                    : Colors.deepOrange,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isUsername = true;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: !isUsername
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 30, 0))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(0, 255, 255, 255)),
                            ),
                            child: Text(
                              'Wallet Address',
                              style: TextStyle(
                                color: !isUsername
                                    ? Colors.white
                                    : Colors.deepOrange,
                              ),
                            ),
                            onPressed: () {
                              // setState(() {
                              // isUsername = false;
                              // }
                              // );
                            },
                          ),
                        ),
                      ],
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _usernameFieldController,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          prefixText: '@',
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'username',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onChanged: (text) {
                          username = text.trim();
                          Future<Map<String, dynamic>> fullname =
                              getUserInfo(text);
                          fullname.then((value) {
                            if (value.containsKey('Payload')) {
                              if (value['Payload']['wallet_address'] ==
                                  widget.user.payload!.walletAddress) {
                                setState(() {
                                  receiverName =
                                      "You can't create a contract with yourself";
                                });
                              } else {
                                setState(() {
                                  receiverName = value['Payload']['fullname'];
                                  receiveraddr =
                                      value['Payload']['wallet_address'];

                                  // print(value);
                                });
                              }
                            } else {
                              setState(() {
                                receiverName =
                                    'This username does match any user';
                              });
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The second party is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text('Receiver: $receiverName'),
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
                        cursorColor: Colors.black,
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
                          cursorColor: Colors.black,
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
                          cursorColor: Colors.black,
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Location',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _locFieldController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(IconlyBold.location),
                          prefixStyle: TextStyle(color: Colors.grey),
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Ex Lagos',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),

                        ),
                        onChanged: (text) {
                          logisticLoc = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The service location is required';
                          }
                          return null;
                        },
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
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: 'NGN',
                          prefixStyle: TextStyle(color: Colors.grey),
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: '0.00',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),

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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Timeline of execution',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _loginButtonController.reset();
                          FocusManager.instance.primaryFocus?.unfocus();
                          DatePicker.showDatePicker(context,
                              minTime: DateTime.now(),
                              currentTime: deliveryDate == 'YYYY-MM-DD'
                                  ? DateTime.now()
                                  : DateTime.tryParse(deliveryDate),
                              maxTime: DateTime(2101), onConfirm: (date) {
                            setState(() {
                              deliveryDate =
                                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            });
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          color: Color.fromARGB(24, 158, 158, 158),
                          child: Text(deliveryDate,
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
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
                    if (!_formKey.currentState!.validate()) {
                      _loginButtonController.reset();
                    }else if (receiverName == 'This username does match any user' || receiverName == "You can't create a contract with yourself" || receiverName == 'Unknown') {
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
                        _stages.addAll({'Stage_${element.index+1}':{"about_stage":element.phaseTitle, "cost_of_stage":double.parse(element.phaseCost)}});
                      },); 

                      print(_stages.toString());

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return AlertDialog(
                                title: Text(
                                  'A SERVICE CONTRACT \nWITH\n ${receiverName.toUpperCase()}',
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
                          widget.pin);
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
                                                  content: Text(a['Message']));
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
                                                  content: Text(a['Message']));
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
                                                  content: Text(a['Message']));
                                    })
                                    ;};
                                        // 

                    }
                  },
                ),
                SizedBox(height: 50)

              ]),
            )),
      ),
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
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            TextFormField(
              initialValue: phaseTitle,
              cursorColor: Colors.black,
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
              cursorColor: Colors.black,
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