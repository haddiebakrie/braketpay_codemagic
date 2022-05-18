import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/savings.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../uix/listitemseparated.dart';

class SavingsDetail extends StatefulWidget {
  SavingsDetail(
      {Key? key, required this.savings, required this.pin, required this.user})
      : super(key: key);

  final Map savings;
  final User user;
  final String pin;

  @override
  State<SavingsDetail> createState() => _SavingsDetailState();
}

class _SavingsDetailState extends State<SavingsDetail> {
  String amount = '';
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();

  late Map commitments = jsonDecode(widget.savings['savings_commit']);
  late DateTime dateCreated =
      DateTime.parse(widget.savings['date_savings_created']);
  late DateTime maturityDate =
      HttpDate.parse(widget.savings['breaking_timeline']);
  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () async {
        final _commitments = await getSavings(
            widget.user.payload!.accountNumber ?? '',
            widget.pin,
            'single',
            widget.savings['savings_id']);
        setState(() {
          print(_commitments['Payload']['savings_commit']);
          commitments = jsonDecode(_commitments['Payload']['savings_commit']);
        });
      },
      child: Scaffold(
          floatingActionButton: RoundButton(
              text: 'Save',
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    enableDrag: true,
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                    isScrollControlled: true,
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(''),
                          toolbarHeight: 90,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                        ),
                        body: Form(
                          key: _formKey,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(children: [
                              Column(mainAxisSize: MainAxisSize.min, children: [
                                const Text(
                                  'How much do you want to save',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                              SizedBox(height: 10),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: TextFormField(
                                  cursorColor: Colors.black,
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
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onChanged: (text) {
                                    amount = text.trim();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter the amount you want to save';
                                    }
                                    return null;
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
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        if (_formKey.currentState!.validate()) {
                                          Map a = await savingsCommit(
                                              widget.savings['savings_id'],
                                              amount,
                                              widget.pin);
                                          if (a.containsKey('Status')) {
                                            if (a['Status'] == 'successful' ||
                                                a['Status'] == 'successfull' ||
                                                a['Status'] == 'successful') {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        actions: [
                                                          TextButton(
                                                            child: const Text(
                                                                'Okay'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _loginButtonController
                                                                  .reset();
                                                              // askOTP(context, username, password,
                                                              //     firstname, surname, email, phone);

                                                              // Navigator.of(context)
                                                              //     .pop();
                                                              // Navigator.of(context)
                                                              //     .pop();
                                                            },
                                                          )
                                                        ],
                                                        title: Text(
                                                            "You have successfully saved $amount to ${widget.savings['savings_name']}"),
                                                        content:
                                                            Text(a['Message']));
                                                  });
                                              _loginButtonController.reset();
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        actions: [
                                                          TextButton(
                                                            child: const Text(
                                                                'Okay'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _loginButtonController
                                                                  .reset();

                                                              // Navigator.of(context)
                                                              //     .pop();
                                                              // Navigator.of(context)
                                                              //     .pop();
                                                            },
                                                          )
                                                        ],
                                                        title: const Text(
                                                            "Savings commit failed"),
                                                        content:
                                                            Text(a['Message']));
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
                                                          child: const Text(
                                                              'Okay'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            _loginButtonController
                                                                .reset();

                                                            // Navigator.of(context)
                                                            //     .pop();
                                                            // Navigator.of(context)
                                                            //     .pop();
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Savings commit failed"),
                                                      content:
                                                          Text((a['Message'])));
                                                });
                                          }
                                        } else {
                                          _loginButtonController.reset();
                                        }
                                      },
                                      child: const Text('Save')))
                            ]),
                          ),
                        ),
                      );
                    });
              }),
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(widget.savings['name_of_savings'] ?? '')),
          body: ListView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20), bottom: Radius.zero),
                  color: Colors.white,
                ),
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                )
                              ]),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Savings Detail',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              ListItemSeparated(
                                  text:
                                      '${DateFormat('MMM, dd yyyy').format(dateCreated)}',
                                  title: 'Start date'),
                              ListItemSeparated(
                                  text:
                                      '${DateFormat('MMM, dd yyyy').format(maturityDate)}',
                                  title: 'Maturity date'),
                              ListItemSeparated(
                                  text: formatAmount(
                                      '${widget.savings['savings_target']}'),
                                  title: 'Savings target'),
                              ListItemSeparated(
                                  text: formatAmount(
                                      '${widget.savings['money_saved']}'),
                                  title: 'You have saved'),
                              ListItemSeparated(
                                  text: formatAmount(
                                      '${widget.savings['total_saving_interest']}'),
                                  title: 'Total interest earned'),
                            ],
                          ))
                    ])),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      )
                    ]),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Committments',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: commitments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListItemSeparated(
                            title: DateFormat('MMMM, dd yyyy')
                                .format(DateTime.parse(commitments[
                                        commitments.keys.toList()[
                                            commitments.length - index - 1]]
                                    ['date_committed']))
                                .toString(),
                            text: formatAmount(
                                '${commitments[commitments.keys.toList()[commitments.length - index - 1]]['amount']}'));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40)
            ],
          )),
    );
  }
}
