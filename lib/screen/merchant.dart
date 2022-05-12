import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../api_callers/merchant.dart';
import '../uix/contractmodeselect.dart';

class Merchant extends StatefulWidget {
  Merchant({Key? key, required this.user, required this.pin}) : super(key: key);

  final User user;
  final String pin;
  @override
  State<Merchant> createState() => _MerchantState();
}

class _MerchantState extends State<Merchant> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  // String _errorMessage = '';
  String bizName = '';
  String bizLoc = '';
  String website = '';
  late Map merchant;
  String email = '';
  String password = '';
  bool hasMerchant = false;
  bool hasTemplate = false;
  // late Future<List<dynamic>> _transactions = fetchContracts(
  //     widget.user.payload!.accountNumber ?? "",
  //     widget.user.payload!.password ?? "",
  //     widget.pin);s

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 5,
          toolbarHeight: 65,
          leading: Container(),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
          ],
          title: Text(hasMerchant ? merchant['merchant_name'] : 'Merchant',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        floatingActionButton: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrange),
          child: IconButton(
              color: Colors.white, icon: Icon(Icons.add), onPressed: () {
                contractMode();
              }),
        ),
        body: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20), bottom: Radius.zero),
              color: Colors.white,
            ),
            child: RefreshIndicator(
                onRefresh: () async {
                  merchant = await getMerchant(
                    widget.user.payload!.walletAddress ?? '',
                    widget.pin,
                  );
                  if (merchant.containsKey('Status')) {
                    if (merchant['Status'] == 'successful') {
                      setState(() {
                        merchant = merchant['Payload'];
                        hasMerchant = true;
                      });
                      Map templates =
                          await fetchMerchantContract(merchant['merchant_id']);
                    }
                  }
                  // setState(() {
                  //   _transactions = Future.value(transactions);
                  // });
                },
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      child: !hasMerchant
                          ? Form(
                              key: _formKey,
                              child: Container(
                                padding: MediaQuery.of(context).viewInsets,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Create a Merchant account',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                          color: Colors.grey,
                                          height: 1,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20)),
                                      Text(
                                        'With a Merchant account, you can create and reuse contract templates to share with your customers.',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Text(
                                                'Business Name*',
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
                                                hintText: 'Ex King store',
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
                                                bizName = text.trim();
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Business name is required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: Text(
                                                      'Business Email*',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    cursorColor: Colors.black,
                                                    decoration:
                                                        const InputDecoration(
                                                      fillColor: Color.fromARGB(
                                                          24, 158, 158, 158),
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      hintText:
                                                          'Ex king@store.com',
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                    ),
                                                    onChanged: (text) {
                                                      email = text.trim();
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Business email is required';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 120,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Text(
                                                    'Location*',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                TextFormField(
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  cursorColor: Colors.black,
                                                  decoration:
                                                      const InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        24, 158, 158, 158),
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                    hintText: 'Ex Epe',
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                  ),
                                                  onChanged: (text) {
                                                    bizLoc = text.trim();
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Business Location is required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Text(
                                                'Business Website',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.url,

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
                                                hintText:
                                                    'Ex www.mybusiness.com',
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
                                                website = text.trim();
                                              },
                                              // validator: (value) {
                                              //   if (value == null || value.isEmpty) {
                                              //     return 'Business name is required';
                                              //   }
                                              //   return null;
                                              // },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: RoundedLoadingButton(
                                            borderRadius: 10,
                                            color:
                                                Theme.of(context).primaryColor,
                                            elevation: 0,
                                            controller: _loginButtonController,
                                            onPressed: () async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                // print('$username, $pin, $password');
                                                Map a = await createMerchant(
                                                    website,
                                                    email,
                                                    widget.user
                                                            .payload!.password ??
                                                        '',
                                                    bizName,
                                                    widget.user.payload!
                                                            .accountNumber ??
                                                        '',
                                                    widget.pin,
                                                    bizLoc);

                                                if (a.containsKey('Payload')) {
                                                  _loginButtonController
                                                      .success();
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            actions: [
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        'Okay'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              )
                                                            ],
                                                            title: const Text(
                                                                "Success!"),
                                                            content: const Text(
                                                                'Your Merchant account was created successfully, you can now create contract templates.'));
                                                      });
                                                } else {
                                                  _loginButtonController
                                                      .reset();
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            actions: [
                                                              TextButton(
                                                                child:
                                                                    const Text(
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
                                                                "Can't create Merchant Account!"),
                                                            content: Text(
                                                                a['Message']));
                                                      });
                                                }
                                                // a.onError((error, stackTrace) {
                                                //   print('$error ppppppppppppppppppppppppp');
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
                                                //             title: const Text("Can't Make transfer!"),
                                                //             content: Text(error.toString()));
                                                //       });
                                                //   throw Exception(error);
                                                // });
                                              } else {
                                                _loginButtonController.reset();
                                              }
                                            },
                                            child: const Text('Create')),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
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
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Text(
                                            'Business Detail',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ListItemSeparated(
                                              text: merchant['merchant_id'],
                                              title: 'Business ID'),
                                          ListItemSeparated(
                                              text: merchant['business_email'],
                                              title: 'Business Email'),
                                          ListItemSeparated(
                                              text:
                                                  merchant['business_location'],
                                              title: 'Business Website',
                                              isLast: true),
                                        ],
                                      )),
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Your saved templates',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          hasTemplate
                                              ? Container()
                                              : Container(
                                                margin: EdgeInsets.all(40),
                                                  child: Center(
                                                      child: Text(
                                                          'You have not created any template.')))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                    )
                  ],
                ))));
  }
  Future<dynamic> contractMode() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (context) {
          return MerchantContractModeSelect(user: widget.user, pin: widget.pin, merchantID: merchant['merchant_id']);
        });
  }
  //       // child:
}

class ListItemSeparated extends StatelessWidget {
  ListItemSeparated({
    Key? key,
    required this.text,
    required this.title,
    this.isLast = false,
  }) : super(key: key);

  final String text;
  final String title;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(children: [
          ListTile(title: Text(title), trailing: Text(text)),
          Container(
              color: isLast ? Colors.transparent : Colors.grey.withOpacity(.5),
              height: 1,
              width: double.infinity)
        ]));
  }
}
