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
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/savings.dart';
import '../brakey.dart';
import '../uix/listitemseparated.dart';
import '../uix/roundbutton.dart';
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
      widget.user.payload!.accountNumber ?? '', widget.pin, 'all', '');
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
      floatingActionButton: RoundButton(
          radius: 10,
          text: 'Create savings',
          width: 100,
          onTap: () {
            Get.to(SavingsForm(pin: widget.pin));
          }),
      body: RefreshIndicator(
        key: brakey.refreshSavings.value,
        onRefresh: () async {
          final _savings = await getSavings(
              widget.user.payload!.accountNumber ?? '', widget.pin, 'all', '');
          setState(() {
            // print(_commitments['Payload']);
            savings = Future.value(_savings);
          });
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
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
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                  bottom: Radius.zero),
                              color: Colors.white,
                            ),
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
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.2),
                                            spreadRadius: 3,
                                            blurRadius: 10,
                                            offset: const Offset(0, 0),
                                          )
                                        ]),
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
                                                  TextStyle(fontFamily: '')),
                                          Text(
                                              '\u2191' +
                                                  formatAmount(snapshot
                                                      .data!['Savings'][index]
                                                          [
                                                          'total_saving_interest']
                                                      .toString()),
                                              style: TextStyle(
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
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                      bottom: Radius.zero),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        'assets/sammy-no-connection.gif',
                                        width: 150),
                                    const Text(
                                        "No internet access\nCoudn't Load Savings!",
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 20),
                                    RoundButton(
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
                                      Center(
                                        child: const Text(
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
                                            value: Pvalue,
                                            items:
                                                savingsPlan.map((String items) {
                                              return DropdownMenuItem(
                                                  value: items,
                                              child: RichText(text: TextSpan( children: [TextSpan(text:"$items ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), TextSpan(text:"${savingsDetail[items]['range']}", style: TextStyle(color: Colors.black, fontFamily: ''))])));
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                Pvalue = newValue!;
                                              });
                                            }),
                                      ]),
                                      SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            cursorColor: Colors.black,
                                            decoration: const InputDecoration(
                                              fillColor: Color.fromARGB(
                                                  24, 158, 158, 158),
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: 'Ex School Project',
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
                                      SizedBox(height: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                'How much do you want to save (Your target)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            TextFormField(
                                              cursorColor: Colors.black,
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
                                      SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              'How much do you want to start with (Your first commit)',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          TextFormField(
                                            cursorColor: Colors.black,
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
                                            EdgeInsets.symmetric(vertical: 10),
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
                                              PfreqValue = newValue!;
                                            });
                                          }),
                                      SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              'How much do you want to save $PfreqValue',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          TextFormField(
                                            cursorColor: Colors.black,
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
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                    bottom: Radius.zero),
                                color: Colors.white,
                              ),
                              child: Center(
                                  child: Column(
                                children: [
                                  Image.asset(
                                      'assets/sammy-no-connection.gif',
                                      width: 150),
                                  const Text(
                                      "No internet access\nCoudn't Load Contract History!",
                                      textAlign: TextAlign.center),
                                  RoundButton(
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
            //                 ListView(
            //                 children: [
            //                   SingleChildScrollView(
            //                       child: FutureBuilder<Map>(
            //                           future: savings,
            //                           builder:
            //                               (BuildContext context, AsyncSnapshot snapshot) {
            //                                 switch (snapshot.connectionState) {
            //                                   case ConnectionState.none:
            //                                   case ConnectionState.waiting:
            //                                   case ConnectionState.active:
            //                                     {
            //                                       return Container(
            //                                         margin: const EdgeInsets.all(20),
            //                                           decoration: const BoxDecoration(
            //                                             borderRadius:
            //                                                 BorderRadius.vertical(
            //                                                     top: Radius.circular(20),
            //                                                     bottom: Radius.zero),
            //                                             color: Colors.white,
            //                                           ),
            //                                           child: const Center(
            //                                               child: Text(
            //                                                   "Please wait...")));
            //                                     }
            //                                   case ConnectionState.done:
            //                                     {
            //                             // if (snapshot.hasData && snapshot.data.containsKey('Status')) {
            //                             //   print(snapshot.data);
            //                             //   if (snapshot.data.containsKey('Status') &&
            //                             //       snapshot.data['Status'] == 'successful') {

            //                             //     return Container(
            //                             //         padding: const EdgeInsets.all(10),
            //                             //         child: Column(children: [
            //                             //           Container(
            // decoration: BoxDecoration(
            //     borderRadius:
            //         BorderRadius.circular(10),
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey
            //             .withOpacity(0.2),
            //         spreadRadius: 3,
            //         blurRadius: 10,
            //         offset: const Offset(0, 0),
            //       )
            //     ]),
            //                             //               child: Column(
            //                             //                 children: [
            //                             //                   const SizedBox(height: 10),
            //                             //                   const Text(
            //                             //                     'Business Detail',
            //                             //                     style: TextStyle(
            //                             //                         fontSize: 20,
            //                             //                         fontWeight:
            //                             //                             FontWeight.bold),
            //                             //                   ),
            //                             //                   ListItemSeparated(
            //                             //                       text:
            //                             //                           snapshot.data['Payload']
            //                             //                               ['merchant_id'],
            //                             //                       title: 'Business ID'),
            //                             //                   ListItemSeparated(
            //                             //                       text:
            //                             //                           snapshot.data['Payload']
            //                             //                               ['business_email'],
            //                             //                       title: 'Business Email'),
            //                             //                   ListItemSeparated(
            //                             //                       text: snapshot
            //                             //                               .data['Payload']
            //                             //                           ['business_location'],
            //                             //                       title: 'Business Website',
            //                             //                       isLast: true),
            //                             //                 ],
            //                             //               )),
            //                             //           const SizedBox(height: 20),

            //                             //           SizedBox(
            //                             //               width: double.infinity,
            //                             //               child: Padding(
            //                             //                 padding:
            //                             //                     const EdgeInsets.all(8.0),
            //                             //                 child: Column(
            //                             //                   children: const [
            //                             //                     Text(
            //                             //                       'Your saved templates',
            //                             //                       style: TextStyle(
            //                             //                           fontSize: 20,
            //                             //                           fontWeight:
            //                             //                               FontWeight.bold),
            //                             //                     ),
            //                             //                   ],
            //                             //                 ),
            //                             //               )),

            //                             //         ]));
            //                             //   } else {

            //                             //     return Form(
            //                             //       // key: _formKey,
            //                             //       child: Container(
            //                             //         padding:
            //                             //             MediaQuery.of(context).viewInsets,
            //                             //         decoration: const BoxDecoration(
            //                             //             color: Colors.white,
            //                             //             borderRadius: BorderRadius.vertical(
            //                             //                 top: Radius.circular(20))),
            //                             //         child: Padding(
            //                             //           padding: const EdgeInsets.all(20.0),
            //                             //           child: Column(
            //                             //             mainAxisSize: MainAxisSize.min,
            //                             //             children: [
            //                             //               const Text(
            //                             //                 'Create a Merchant account',
            //                             //                 style: TextStyle(
            //                             //                     fontSize: 22,
            //                             //                     fontWeight: FontWeight.bold),
            //                             //               ),
            //                             //               Container(
            //                             //                   color: Colors.grey,
            //                             //                   height: 1,
            //                             //                   margin: const EdgeInsets.symmetric(
            //                             //                       vertical: 20)),
            //                             //               const Text(
            //                             //                 'With a Merchant account, you can create and reuse contract templates to share with your customers.',
            //                             //                 textAlign: TextAlign.center,
            //                             //                 style: TextStyle(
            //                             //                     color: Colors.grey,
            //                             //                     fontSize: 15),
            //                             //               ),
            //                             //               const SizedBox(height: 20),
            //                             //               Container(
            //                             //                 margin:
            //                             //                     const EdgeInsets.symmetric(
            //                             //                         vertical: 5),
            //                             //                 child: Column(
            //                             //                   crossAxisAlignment:
            //                             //                       CrossAxisAlignment.start,
            //                             //                   children: [
            //                             //                     Container(
            //                             //                       margin: const EdgeInsets.only(
            //                             //                           bottom: 10),
            //                             //                       child: const Text(
            //                             //                         'Business Name*',
            //                             //                         style: TextStyle(
            //                             //                             fontWeight:
            //                             //                                 FontWeight.w600,
            //                             //                             fontSize: 15),
            //                             //                       ),
            //                             //                     ),
            //                             //                     TextFormField(
            //                             //                       cursorColor: Colors.black,
            //                             //                       decoration:
            //                             //                           const InputDecoration(
            //                             //                         fillColor: Color.fromARGB(
            //                             //                             24, 158, 158, 158),
            //                             //                         filled: true,
            //                             //                         focusedBorder: OutlineInputBorder(
            //                             //                             borderSide:
            //                             //                                 BorderSide.none,
            //                             //                             borderRadius:
            //                             //                                 BorderRadius.all(
            //                             //                                     Radius
            //                             //                                         .circular(
            //                             //                                             10))),
            //                             //                         hintText: 'Ex King store',
            //                             //                         border: OutlineInputBorder(
            //                             //                             borderSide:
            //                             //                                 BorderSide.none,
            //                             //                             borderRadius:
            //                             //                                 BorderRadius.all(
            //                             //                                     Radius
            //                             //                                         .circular(
            //                             //                                             10))),
            //                             //                         contentPadding:
            //                             //                             EdgeInsets.symmetric(
            //                             //                                 horizontal: 10),
            //                             //                       ),
            //                             //                       onChanged: (text) {
            //                             //                       },
            //                             //                       validator: (value) {
            //                             //                         if (value == null ||
            //                             //                             value.isEmpty) {
            //                             //                           return 'Business name is required';
            //                             //                         }
            //                             //                         return null;
            //                             //                       },
            //                             //                     ),
            //                             //                   ],
            //                             //                 ),
            //                             //               ),
            //                             //               Row(
            //                             //                 children: [
            //                             //                   Expanded(
            //                             //                     child: Container(
            //                             //                       margin: const EdgeInsets
            //                             //                           .symmetric(vertical: 5),
            //                             //                       child: Column(
            //                             //                         crossAxisAlignment:
            //                             //                             CrossAxisAlignment
            //                             //                                 .start,
            //                             //                         children: [
            //                             //                           Container(
            //                             //                             margin:
            //                             //                                 const EdgeInsets.only(
            //                             //                                     bottom: 10),
            //                             //                             child: const Text(
            //                             //                               'Business Email*',
            //                             //                               style: TextStyle(
            //                             //                                   fontWeight:
            //                             //                                       FontWeight
            //                             //                                           .w600,
            //                             //                                   fontSize: 15),
            //                             //                             ),
            //                             //                           ),
            //                             //                           TextFormField(
            //                             //                             keyboardType:
            //                             //                                 TextInputType
            //                             //                                     .emailAddress,
            //                             //                             cursorColor:
            //                             //                                 Colors.black,
            //                             //                             decoration:
            //                             //                                 const InputDecoration(
            //                             //                               fillColor:
            //                             //                                   Color.fromARGB(
            //                             //                                       24,
            //                             //                                       158,
            //                             //                                       158,
            //                             //                                       158),
            //                             //                               filled: true,
            //                             //                               focusedBorder: OutlineInputBorder(
            //                             //                                   borderSide:
            //                             //                                       BorderSide
            //                             //                                           .none,
            //                             //                                   borderRadius:
            //                             //                                       BorderRadius.all(
            //                             //                                           Radius.circular(
            //                             //                                               10))),
            //                             //                               hintText:
            //                             //                                   'Ex king@store.com',
            //                             //                               border: OutlineInputBorder(
            //                             //                                   borderSide:
            //                             //                                       BorderSide
            //                             //                                           .none,
            //                             //                                   borderRadius:
            //                             //                                       BorderRadius.all(
            //                             //                                           Radius.circular(
            //                             //                                               10))),
            //                             //                               contentPadding:
            //                             //                                   EdgeInsets
            //                             //                                       .symmetric(
            //                             //                                           horizontal:
            //                             //                                               10),
            //                             //                             ),
            //                             //                             onChanged: (text) {
            //                             //                             },
            //                             //                             validator: (value) {
            //                             //                               if (value == null ||
            //                             //                                   value.isEmpty) {
            //                             //                                 return 'Business email is required';
            //                             //                               }
            //                             //                               return null;
            //                             //                             },
            //                             //                           ),
            //                             //                         ],
            //                             //                       ),
            //                             //                     ),
            //                             //                   ),
            //                             //                   Container(
            //                             //                     width: 120,
            //                             //                     margin: const EdgeInsets
            //                             //                             .symmetric(
            //                             //                         vertical: 5,
            //                             //                         horizontal: 10),
            //                             //                     child: Column(
            //                             //                       crossAxisAlignment:
            //                             //                           CrossAxisAlignment
            //                             //                               .start,
            //                             //                       children: [
            //                             //                         Container(
            //                             //                           margin: const EdgeInsets.only(
            //                             //                               bottom: 10),
            //                             //                           child: const Text(
            //                             //                             'Location*',
            //                             //                             style: TextStyle(
            //                             //                                 fontWeight:
            //                             //                                     FontWeight
            //                             //                                         .w600,
            //                             //                                 fontSize: 15),
            //                             //                           ),
            //                             //                         ),
            //                             //                         TextFormField(
            //                             //                           keyboardType:
            //                             //                               TextInputType
            //                             //                                   .streetAddress,
            //                             //                           cursorColor:
            //                             //                               Colors.black,
            //                             //                           decoration:
            //                             //                               const InputDecoration(
            //                             //                             fillColor:
            //                             //                                 Color.fromARGB(
            //                             //                                     24,
            //                             //                                     158,
            //                             //                                     158,
            //                             //                                     158),
            //                             //                             filled: true,
            //                             //                             focusedBorder: OutlineInputBorder(
            //                             //                                 borderSide:
            //                             //                                     BorderSide
            //                             //                                         .none,
            //                             //                                 borderRadius:
            //                             //                                     BorderRadius.all(
            //                             //                                         Radius.circular(
            //                             //                                             10))),
            //                             //                             hintText: 'Ex Epe',
            //                             //                             border: OutlineInputBorder(
            //                             //                                 borderSide:
            //                             //                                     BorderSide
            //                             //                                         .none,
            //                             //                                 borderRadius:
            //                             //                                     BorderRadius.all(
            //                             //                                         Radius.circular(
            //                             //                                             10))),
            //                             //                             contentPadding:
            //                             //                                 EdgeInsets
            //                             //                                     .symmetric(
            //                             //                                         horizontal:
            //                             //                                             10),
            //                             //                           ),
            //                             //                           onChanged: (text) {
            //                             //                           },
            //                             //                           validator: (value) {
            //                             //                             if (value == null ||
            //                             //                                 value.isEmpty) {
            //                             //                               return 'Business Location is required';
            //                             //                             }
            //                             //                             return null;
            //                             //                           },
            //                             //                         ),
            //                             //                       ],
            //                             //                     ),
            //                             //                   ),
            //                             //                 ],
            //                             //               ),
            //                             //               Container(
            //                             //                 margin:
            //                             //                     const EdgeInsets.symmetric(
            //                             //                         vertical: 5),
            //                             //                 child: Column(
            //                             //                   crossAxisAlignment:
            //                             //                       CrossAxisAlignment.start,
            //                             //                   children: [
            //                             //                     Container(
            //                             //                       margin: const EdgeInsets.only(
            //                             //                           bottom: 10),
            //                             //                       child: const Text(
            //                             //                         'Business Website',
            //                             //                         style: TextStyle(
            //                             //                             fontWeight:
            //                             //                                 FontWeight.w600,
            //                             //                             fontSize: 15),
            //                             //                       ),
            //                             //                     ),
            //                             //                     TextFormField(
            //                             //                       keyboardType:
            //                             //                           TextInputType.url,

            //                             //                       cursorColor: Colors.black,
            //                             //                       decoration:
            //                             //                           const InputDecoration(
            //                             //                         fillColor: Color.fromARGB(
            //                             //                             24, 158, 158, 158),
            //                             //                         filled: true,
            //                             //                         focusedBorder: OutlineInputBorder(
            //                             //                             borderSide:
            //                             //                                 BorderSide.none,
            //                             //                             borderRadius:
            //                             //                                 BorderRadius.all(
            //                             //                                     Radius
            //                             //                                         .circular(
            //                             //                                             10))),
            //                             //                         hintText:
            //                             //                             'Ex www.mybusiness.com',
            //                             //                         border: OutlineInputBorder(
            //                             //                             borderSide:
            //                             //                                 BorderSide.none,
            //                             //                             borderRadius:
            //                             //                                 BorderRadius.all(
            //                             //                                     Radius
            //                             //                                         .circular(
            //                             //                                             10))),
            //                             //                         contentPadding:
            //                             //                             EdgeInsets.symmetric(
            //                             //                                 horizontal: 10),
            //                             //                       ),
            //                             //                       onChanged: (text) {
            //                             //                       },
            //                             //                       // validator: (value) {
            //                             //                       //   if (value == null || value.isEmpty) {
            //                             //                       //     return 'Business name is required';
            //                             //                       //   }
            //                             //                       //   return null;
            //                             //                       // },
            //                             //                     ),
            //                             //                   ],
            //                             //                 ),
            //                             //               ),
            //                             //               Container(
            //                             //                 margin: const EdgeInsets.all(10),
            //                             //                 // child: RoundedLoadingButton(
            //                             //                 //     borderRadius: 10,
            //                             //                 //     color: Theme.of(context)
            //                             //                 //         .primaryColor,
            //                             //                 //     elevation: 0,
            //                             //                 //     controller:
            //                             //                 //         _loginButtonController,
            //                             //                 //     onPressed: () async {
            //                             //                 //       FocusManager
            //                             //                 //           .instance.primaryFocus
            //                             //                 //           ?.unfocus();
            //                             //                 //       if (_formKey.currentState!
            //                             //                 //           .validate()) {
            //                             //                         // print('$username, $pin, $password');
            //                             //                         // Map a = await createMerchant(
            //                             //                         //     website,
            //                             //                         //     email,
            //                             //                         //     widget.user.payload!
            //                             //                         //             .password ??
            //                             //                         //         '',
            //                             //                         //     bizName,
            //                             //                         //     widget.user.payload!
            //                             //                         //             .accountNumber ??
            //                             //                         //         '',
            //                             //                         //     widget.pin,
            //                             //                         //     bizLoc);

            //                             //                       //   if (a.containsKey(
            //                             //                       //       'Payload')) {
            //                             //                       //     _loginButtonController
            //                             //                       //         .success();
            //                             //                       //     showDialog(
            //                             //                       //         context: context,
            //                             //                       //         barrierDismissible:
            //                             //                       //             false,
            //                             //                       //         builder: (context) {
            //                             //                       //           return AlertDialog(
            //                             //                       //               actions: [
            //                             //                       //                 TextButton(
            //                             //                       //                   child: const Text(
            //                             //                       //                       'Okay'),
            //                             //                       //                   onPressed:
            //                             //                       //                       () async {
            //                             //                       //                     Navigator.of(context)
            //                             //                       //                         .pop();
            //                             //                       //                     final _merchant =
            //                             //                       //                         await getMerchant(
            //                             //                       //                       widget.user.payload!.walletAddress ??
            //                             //                       //                           '',
            //                             //                       //                       widget
            //                             //                       //                           .pin,
            //                             //                       //                     );

            //                             //                       //                     setState(
            //                             //                       //                         () {
            //                             //                       //                       merchant =
            //                             //                       //                           Future.value(_merchant);
            //                             //                       //                     });
            //                             //                       //                   },
            //                             //                       //                 )
            //                             //                       //               ],
            //                             //                       //               title: const Text(
            //                             //                       //                   "Success!"),
            //                             //                       //               content:
            //                             //                       //                   const Text(
            //                             //                       //                       'Your Merchant account was created successfully, you can now create contract templates.'));
            //                             //                       //         });
            //                             //                       //   } else {
            //                             //                       //     _loginButtonController
            //                             //                       //         .reset();
            //                             //                       //     showDialog(
            //                             //                       //         context: context,
            //                             //                       //         barrierDismissible:
            //                             //                       //             false,
            //                             //                       //         builder: (context) {
            //                             //                       //           return AlertDialog(
            //                             //                       //               actions: [
            //                             //                       //                 TextButton(
            //                             //                       //                   child: const Text(
            //                             //                       //                       'Okay'),
            //                             //                       //                   onPressed:
            //                             //                       //                       () {
            //                             //                       //                     Navigator.of(context)
            //                             //                       //                         .pop();
            //                             //                       //                     // Navigator.of(context).pop();
            //                             //                       //                     // Navigator.of(context).pop();
            //                             //                       //                   },
            //                             //                       //                 )
            //                             //                       //               ],
            //                             //                       //               title: const Text(
            //                             //                       //                   "Can't create Merchant Account!\nPull down to refresh"),
            //                             //                       //               content: Text(
            //                             //                       //                   a['Message']));
            //                             //                       //         });
            //                             //                       //   }
            //                             //                       // } else {
            //                             //                       //   _loginButtonController
            //                             //                       //       .reset();
            //                             //                       // }
            //                             //                     // },
            //                             //                     // child: const Text('Create')),
            //                             //               )
            //                             //             ],
            //                             //           ),
            //                             //         ),
            //                             //       ),
            //                             //     );
            //                             //   }
            //                             // } else{
            //                             //             return Container(
            //                             //               margin: const EdgeInsets.all(30),
            //                             //                 decoration: const BoxDecoration(
            //                             //                   borderRadius:
            //                             //                       BorderRadius.vertical(
            //                             //                           top:
            //                             //                               Radius.circular(20),
            //                             //                           bottom: Radius.zero),
            //                             //                   color: Colors.white,
            //                             //                 ),
            //                             //                 child: Center(
            //                             //                     child: Column(
            //                             //                       children: [
            //                             //                         Image.asset('assets/sammy-no-connection.gif'),
            //                             //                         const Text(
            //                             //                             "No internet access"),
            //                             //                         const SizedBox(height:10),
            //                             //                         RoundButton(
            //                             //                           text: 'Retry',
            //                             //                           color1: Colors.black,
            //                             //                           color2: Colors.black,
            //                             //                           onTap: () {
            //                             //                             _refreshKey.currentState!.show();
            //                             //                           }

            //                             //                         )
            //                             //                       ],
            //                             //                     )));
            //                             //           }

            //                                     }}
            // })),
            //                 ],
            //               )
            // ])
            // child: GridView(
            //   gridDelegate:
            //       const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            //   children: [
            //   ],
            // ),
            // ]),
            ),
      ),
    );
  }
}
