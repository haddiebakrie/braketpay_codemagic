import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'manager.dart';

Future<dynamic> askBVN(
  context,
  username,
  password,
  email,
  phone,
) {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  String pin = '';
  String bvn = '';
  String addr = '';
  return showModalBottomSheet(
      context: context,
      isDismissible: false,
      // enableDrag: false,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      isScrollControlled: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: _formKey,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: ListView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Security Infomation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: TextFormField(
                            cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              hintMaxLines: 2,
                              helperMaxLines: 2,
                              errorMaxLines: 2,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'BVN',
                              helperText: 'Enter your BVN, dail *565# with the same number linked with your BVN',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onChanged: (text) {
                              bvn = text.trim();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value.trim().length < 11) {
                                return 'Enter your BVN, dail *565# with the same number linked with your BVN';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: TextFormField(
                            cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              obscureText: true,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              hintMaxLines: 2,
                              helperMaxLines: 2,
                              errorMaxLines: 2,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Transaction PIN',
                              helperText: 'Set your 4 digit Transaction PIN ',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onChanged: (text) {
                              pin = text.trim();
                              _loginButtonController.reset();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value.trim().length < 4) {
                                return 'Set your 4 digit Transaction PIN ';
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: TextFormField(
                            
                            cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              obscureText: true,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              hintMaxLines: 2,
                              helperMaxLines: 2,
                              errorMaxLines: 2,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Confirm Transaction PIN',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty || value != pin) {
                                return 'Enter the same Transaction PIN ';
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
                                  // try{
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState!.validate()) {
        
                                    Map a = await setBVN(
                                      phone,
                                      email,
                                      password,
                                      username,
                                      bvn,
                                      pin,
                                      ''
                                    );
                                  //   print(a);
                                    if (a.containsKey('Status')) {
                                      if (a['Status'] == 'successful') {
                                        _loginButtonController.success();
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (loading) {
                                              return WillPopScope(
                                                onWillPop: () async => false,
                                                child: AlertDialog(
                                                    title: const Text("Security Information Updated"),
                                                    content: Row(
                                                      children: const [
                                                        Padding(
                                                          padding: const EdgeInsets.all(15.0),
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                        Text('Logging you in...'),
                                                      ],
                                                    )),
                                              );
                                            });
                                              User user = await loginUser(username, password, pin);
                                              Navigator.push(context, 
                                              MaterialPageRoute(builder: (context) => Manager(pin: pin, user:user, mcurrentIndex: 0,))
                                              );
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
                                                      },
                                                    )
                                                  ],
                                                  title: const Text(
                                                      "Account creation failed"),
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
                                                        // Navigator.of(context)
                                                        //     .pop();
                                                        // Navigator.of(context)
                                                        //     .pop();
                                                      },
                                                    )
                                                  ],
                                                  title: const Text(
                                                      "Failed"),
                                                  content: Text(a['Message']));
                                            });
                                        // }
        
                                      }
                                  } else {
                                    _loginButtonController.reset();
                                  }
                                },
                                child: const Text('Login')))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
