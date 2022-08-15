import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/savings.dart';
import '../brakey.dart';
import '../uix/roundbutton.dart';
import '../utils.dart';

class SavingsForm extends StatefulWidget {
  SavingsForm({Key? key, required this.pin}) : super(key: key);

  @override
  State<SavingsForm> createState() => _SavingsFormState();

  final String pin;
}

class _SavingsFormState extends State<SavingsForm> {
  final Brakey brakey = Get.put(Brakey());

  List<String> savingsPlan = ['Lite', 'Crystal', 'Stack', 'Vault'];
  List<String> savingsPPlan = ['Lite', 'Crystal', 'Stack', 'Vault'];
  List<String> frequencyTypes = [
    'Daily',
    'Every 2 days',
    'Every 3 days',
    'Every 4 days',
    'Every 5 days',
    'Weekly',
    'Every 2 weeks',
    'Every 3 weeks',
    'Monthly'
  ];
  String savingsName = '';
  String firstCommitment = '';
  String targetAmount = '';
  String frequency = '';
  String frequencyAmount = '';

  final _formKey = GlobalKey<FormState>();
  final _formPKey = GlobalKey<FormState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
    Map savingsDetail = {
    'Lite': {
      'month': "3",
      "interest": "2.5",
      "firstCommit": "0",
      'minimum': "100",
      "range" : "${formatAmount('100')} - ${formatAmount('50000')}"
    },
    'Crystal': {
      'month': "6",
      "range" : "${formatAmount('50000')} - ${formatAmount('300000')}",
      "interest": "5",
      "firstCommit": "50000",
      "minimum": "50000"
    },
    'Stack': {
      'month': "9",
      "interest": "7.5",
      "range" : "${formatAmount('300000')} - ${formatAmount('1000000')}",
      "firstCommit": "100000",
      "minimum": "300000"
    },
    'Vault': {
      'month': "12",
      "interest": "10",
      "range" : "> ${formatAmount('1000000')}",
      "firstCommit": "300000",
      "minimum": "1000000"
    },
  };
  
String value = 'Lite';
  String freqValue = 'Daily';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
                      appBar: AppBar(
                        title: Text(''),
                        elevation: 0,
                        // backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                      ),
                      body: Container(
                              decoration: ContainerBackgroundDecoration(),
                        child: ListView(
                          children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal:20),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        const Center(
                                          child: Text(
                                            'Tap a plan for more detail',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SavingsPlanButton(
                                                color: const Color.fromARGB(
                                                    255, 0, 112, 173),
                                                title: 'Lite'),
                                            SavingsPlanButton(
                                                color: const Color.fromARGB(
                                                    255, 0, 162, 162),
                                                title: 'Crystal'),
                                            SavingsPlanButton(
                                                color: const Color.fromRGBO(
                                                    152, 97, 77, 1),
                                                title: 'Stack'),
                                            SavingsPlanButton(
                                                color: const Color.fromARGB(
                                                    255, 74, 73, 84),
                                                title: 'Vault'),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Column(children: [
                                          const Text(
                                            'Select Savings plan',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100),
                                          ),
                                          DropdownButton(
                                              isExpanded: true,
                                              value: value,
                                              items: savingsPlan.map((String items) {
                                                print(items);
                                                return DropdownMenuItem(
                                                    value: items, child: RichText(text: TextSpan( children: [TextSpan(text:"$items ", style: TextStyle(color: adaptiveColor, fontWeight: FontWeight.bold)), TextSpan(text:"${savingsDetail[items]['range']}", style: TextStyle(color: adaptiveColor, fontFamily: ''))])));
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  value = newValue!;
                                                });
                                              }),
                                        ]),
                                        SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: Text(
                                                'Name your savings',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            TextFormField(
                                              cursorColor: Colors.grey,
                                              decoration: const InputDecoration(
                                                fillColor:
                                                    Color.fromARGB(24, 158, 158, 158),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                hintText: 'Eg, School Project',
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                              ),
                                              onChanged: (text) {
                                                savingsName = text.trim();
                                              },
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Savings name is required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.symmetric(vertical: 10),
                                                child: Text(
                                                  'How much do you want to save (Your target)',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              TextFormField(
                                              keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                                                cursorColor: Colors.grey,
                                                decoration: const InputDecoration(
                                                  fillColor:
                                                      Color.fromARGB(24, 158, 158, 158),
                                                  filled: true,
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10))),
                                                  hintText: '\u20a6',
                                                  hintStyle: TextStyle(fontFamily: ''),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10))),
                                                  contentPadding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                ),
                                                onChanged: (text) {
                                                  targetAmount = text.trim();
                                                },
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Savings Target is required';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ]),
                                        SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.symmetric(vertical: 10),
                                              child: Text(
                                                'How much do you want to start with (Your first commit)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                                              cursorColor: Colors.grey,
                                              decoration: const InputDecoration(
                                                fillColor:
                                                    Color.fromARGB(24, 158, 158, 158),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                hintText: '\u20a6',
                                                hintStyle: TextStyle(fontFamily: ''),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                              ),
                                              onChanged: (text) {
                                                firstCommitment = text.trim();
                                              },
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'First commitment is required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 10),
                                          child: Text(
                                            'How often do you want to save',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          ),
                                        ),
                                        DropdownButton(
                                            isExpanded: true,
                                            value: freqValue,
                                            items: frequencyTypes.map((String i) {
                                              return DropdownMenuItem(
                                                  value: i, child: Text(i));
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                freqValue = newValue!;
                                              });
                                            }),
                                        SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.symmetric(vertical: 10),
                                              child: Text(
                                                'How much do you want to save $freqValue',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                                              cursorColor: Colors.grey,
                                              decoration: const InputDecoration(
                                                fillColor:
                                                    Color.fromARGB(24, 158, 158, 158),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                hintText: '\u20a6',
                                                hintStyle: TextStyle(fontFamily: ''),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                              ),
                                              onChanged: (text) {
                                                frequencyAmount = text.trim();
                                              },
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'This field is required';
                                                }
                                                return null;
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
                                                    FocusManager.instance.primaryFocus
                                                        ?.unfocus();
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      // print('$username, $pin, $password');
                                                      Map a = await createSavings(
                                                          value.toLowerCase(),
                                                          savingsName,
                                                          firstCommitment,
                                                          targetAmount,
                                                          freqValue
                                                              .replaceAll('Every', '')
                                                              .replaceAll(' ', '')
                                                              .toLowerCase(),
                                                          frequencyAmount,
                                                          brakey.user.value!.payload!
                                                                  .accountNumber ??
                                                              '',
                                                          widget.pin);
                              
                                                      if (a.containsKey('Payload')) {
                                                        _loginButtonController
                                                            .success();
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (context) {
                                                              return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'Okay'),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                          Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                            brakey.refreshUserDetail();
                                                                      },
                                                                    )
                                                                  ],
                                                                  title: const Text(
                                                                      "Success!"),
                                                                  content: Text(
                                                                      '$savingsName was created successfully.',
                                                                    style: TextStyle(fontFamily: ''),
                                                                      ));
                                                            });
                                                      } else {
                                                        _loginButtonController.reset();
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (context) {
                                                              return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'Okay'),
                                                                      onPressed: () {
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                        // Navigator.of(context).pop();
                                                                        // Navigator.of(context).pop();
                                                                      },
                                                                    )
                                                                  ],
                                                                  title: const Text(
                                                                      "Can't create Savings"),
                                                                  content: Text(
                                                                      a['Message'],
                                                                    style: TextStyle(fontFamily: ''),
                                                                      ));
                                                            });
                                                      }
                                                    } else {
                                                      _loginButtonController.reset();
                                                    }
                                                  },
                                                  child: const Text('Create')),
                                            )
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                
  }
}