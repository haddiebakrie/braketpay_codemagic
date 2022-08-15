import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/buydata.dart';
import 'package:braketpay/screen/cabletv.dart';
import 'package:braketpay/screen/electricity.dart';
import 'package:braketpay/screen/recharge.dart';
import 'package:braketpay/screen/savingsdetail.dart';
import 'package:braketpay/screen/savingsform.dart';
import 'package:braketpay/screen/transfer.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/savings.dart';
import '../brakey.dart';
import '../uix/listitemseparated.dart';
import '../uix/roundbutton.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class Savings extends StatefulWidget {
  final User user;

  final String pin;
  const Savings({Key? key, required this.user, required this.pin})
      : super(key: key);
  @override
  State<Savings> createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {
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
  late Future<Map> savings = getSavings(
      widget.user.payload!.accountNumber ?? '', brakey.user.value!.payload!.password??'', brakey.user.value!.payload!.password??'', 'all', '');
  Map savingsDetail = {
    'Lite': {
      'month': "3",
      "interest": "2.5",
      "firstCommit": "0",
      'minimum': "100",
      "range": "${formatAmount('100')} - ${formatAmount('50000')}"
    },
    'Crystal': {
      'month': "6",
      "range": "${formatAmount('50000')} - ${formatAmount('300000')}",
      "interest": "5",
      "firstCommit": "50000",
      "minimum": "50000"
    },
    'Stack': {
      'month': "9",
      "interest": "7.5",
      "range": "${formatAmount('300000')} - ${formatAmount('1000000')}",
      "firstCommit": "100000",
      "minimum": "300000"
    },
    'Vault': {
      'month': "12",
      "interest": "10",
      "range": "> ${formatAmount('1000000')}",
      "firstCommit": "300000",
      "minimum": "1000000"
    },
  };
  Map planColor = {'Lite': const Color.fromARGB(
                          255, 0, 112, 173),
                'Crystal': const Color.fromARGB(
                          255, 0, 162, 162),
                'Stack': const Color.fromRGBO(
                          152, 97, 77, 1),
                'Vault': const Color.fromARGB(
                          255, 74, 73, 84),
                };
  String value = 'Lite';
  String freqValue = 'Daily';
  String Pvalue = 'Lite';
  String PfreqValue = 'Daily';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Savings'),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FutureBuilder<Map>(
        future: savings,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.containsKey('Savings')) {
          return RoundButton(
              radius: 10,
              text: 'Create savings',
              width: 180,
              onTap: () {
                Get.to(() => SavingsForm(pin: widget.pin));
              });

          } else {
            return const SizedBox();
          }
        }
      ),
      body: Container(
        child: RefreshIndicator(
          key: brakey.refreshSavings.value,
          onRefresh: () async {
            final _savings = await getSavings(
                widget.user.payload!.accountNumber ?? '', widget.pin, brakey.user.value!.payload!.password??'', 'all', '');
            setState(() {
              // print(_commitments['Payload']);
              savings = Future.value(_savings);
            });
          },
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: ContainerBackgroundDecoration(),
              child: FutureBuilder<Map>(
                  future: savings,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        {
                          return Container(
                              height: double.infinity,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: CircularProgressIndicator(
                                        color: Colors.grey),
                                  ),
                                  Text("Loading your Savings..."),
                                ],
                              )));
                        }
                      case ConnectionState.done:
                        {
                          print(snapshot.data);
                          if (snapshot.hasData) {
                            if (snapshot.data!.containsKey('Savings')) {
                              return ListView.builder(
                                  // shrinkWrap: true,
                                  itemCount: snapshot.data!['Savings'].length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: ContainerDecoration(),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      SavingsDetail(
                                                          user: widget.user,
                                                          pin: widget.pin,
                                                          savings: snapshot
                                                                      .data![
                                                                  'Savings']
                                                              [index])));
                                        },
                                        title: Text(snapshot.data!['Savings']
                                                [index]['name_of_savings']
                                            .toUpperCase()),
                                        subtitle: Text(snapshot.data!['Savings']
                                            [index]['savings_type']),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                formatAmount(snapshot
                                                    .data!['Savings'][index]
                                                        ['money_saved']
                                                    .toString()),
                                                style:
                                                    const TextStyle(fontFamily: '')),
                                            Text(
                                                '\u2191' +
                                                    formatAmount(snapshot
                                                        .data!['Savings'][index]
                                                            [
                                                            'total_saving_interest']
                                                        .toString()),
                                                style: const TextStyle(
                                                    fontFamily: '',
                                                    color: Colors.blue)),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else if (snapshot.data!.containsKey('Message') &&
                                snapshot.data!['Message'] != 'Empty') {
                              return Container(
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          'assets/sammy-no-connection.gif',
                                          width: 150),
                                      const Text(
                                          "No internet access\nCouldn't Load Savings!",
                                          textAlign: TextAlign.center),
                                      const SizedBox(height: 20),
                                      RoundButton(
                                                              icon: Icons.refresh,

                                          text: 'Retry',
                                          color1: Colors.black,
                                          color2: Colors.black,
                                          onTap: () {
                                            brakey.refreshSavings.value!.currentState!.show();
                                          })
                                    ],
                                  )));
                            } else {
                              print(snapshot.data!);
                              
                              return SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                color: planColor['Lite'],
                                                title: 'Lite'),
                                            SavingsPlanButton(
                                                color: planColor['Crystal'],
                                                title: 'Crystal'),
                                            SavingsPlanButton(
                                                color: planColor['Stack'],
                                                title: 'Stack'),
                                            SavingsPlanButton(
                                                color: planColor['Vault'],
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
                                              value: Pvalue,
                                              items:
                                                  savingsPlan.map((String items) {
                                                return DropdownMenuItem(
                                                    value: items,
                                                child: RichText(text: TextSpan( children: [TextSpan(text:"$items ", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), TextSpan(text:"${savingsDetail[items]['range']}", style: const TextStyle(color: Colors.black, fontFamily: ''))])));
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  Pvalue = newValue!;
                                                });
                                              }),
                                        ]),
                                        const SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 10),
                                              child: const Text(
                                                'Name your savings',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            TextFormField(
                                              cursorColor: Colors.grey,
                                              decoration: const InputDecoration(
                                                fillColor: Color.fromARGB(
                                                    24, 158, 158, 158),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10))),
                                                hintText: 'Eg, School Project',
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10))),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                              ),
                                              onChanged: (text) {
                                                savingsName = text.trim();
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Savings name is required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: const Text(
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
                                                  fillColor: Color.fromARGB(
                                                      24, 158, 158, 158),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                  hintText: '\u20a6',
                                                  hintStyle:
                                                      TextStyle(fontFamily: ''),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                ),
                                                onChanged: (text) {
                                                  targetAmount = text.trim();
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Savings Target is required';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ]),
                                        const SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: const Text(
                                                'How much do you want to start with (Your first commit)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            TextFormField(
                                              cursorColor: Colors.grey,
                                              keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              decoration: const InputDecoration(
                                                fillColor: Color.fromARGB(
                                                    24, 158, 158, 158),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10))),
                                                hintText: '\u20a6',
                                                hintStyle:
                                                    TextStyle(fontFamily: ''),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10))),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                              ),
                                              onChanged: (text) {
                                                firstCommitment = text.trim();
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'First commitment is required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.symmetric(vertical: 10),
                                          child: const Text(
                                            'How often do you want to save',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          ),
                                        ),
                                        DropdownButton(
                                            isExpanded: true,
                                            value: PfreqValue,
                                            items: frequencyTypes.map((String i) {
                                              return DropdownMenuItem(
                                                  value: i, child: Text(i));
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                PfreqValue = newValue!;
                                              });
                                            }),
                                        const SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                'How much do you want to save $PfreqValue',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              cursorColor: Colors.grey,
                                              decoration: const InputDecoration(
                                                fillColor: Color.fromARGB(
                                                    24, 158, 158, 158),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10))),
                                                hintText: '\u20a6',
                                                hintStyle:
                                                    TextStyle(fontFamily: ''),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10))),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                              ),
                                              onChanged: (text) {
                                                frequencyAmount = text.trim();
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'This field is required';
                                                }
                                                return null;
                                              },
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: RoundedLoadingButton(
                                                  borderRadius: 10,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  elevation: 0,
                                                  controller:
                                                      _loginButtonController,
                                                  onPressed: () async {
                                                    FocusManager
                                                        .instance.primaryFocus
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
                                                              .replaceAll(
                                                                  'Every', '')
                                                              .replaceAll(' ', '')
                                                              .toLowerCase(),
                                                          frequencyAmount,
                                                          widget.user.payload!
                                                                  .accountNumber ??
                                                              '',
                                                          widget.pin);
                              
                                                      if (a.containsKey(
                                                          'Payload')) {
                                                        _loginButtonController
                                                            .success();
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
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
                                                                      },
                                                                    )
                                                                  ],
                                                                  title: const Text(
                                                                      "Success!"),
                                                                  content: Text(
                                                                      '$savingsName was created successfully.'));
                                                            });
                                                      } else {
                                                        _loginButtonController
                                                            .reset();
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
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
                                                                          () {
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
                                                                  content: Text(a[
                                                                      'Message']));
                                                            });
                                                      }
                                                    } else {
                                                      _loginButtonController
                                                          .reset();
                                                    }
                                                  },
                                                  child: const Text('Create')),
                                            )
                                          ],
                                        ),
                                      ]),
                                ),
                              );
                            }
                          } else {
                            return Container(

                                child: Center(
                                    child: Column(
                                  children: [
                                    Image.asset(
                                        'assets/sammy-no-connection.gif',
                                        width: 150),
                                    const Text(
                                        "No internet access\nCouldn't Load Contract History!",
                                        textAlign: TextAlign.center),
                                    RoundButton(
                                                              icon: Icons.refresh,

                                        text: 'Retry',
                                        color1: Colors.black,
                                        color2: Colors.black,
                                        onTap: () {
                                          _refreshKey.currentState!.show();
                                        })
                                  ],
                                )));
                          }
                        }
                    }
                  })

              ),
        ),
      ),
    );
  }
}
