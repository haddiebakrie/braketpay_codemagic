import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/index.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';
import 'package:braketpay/brakey.dart';
import 'manager.dart';

Future<dynamic> askBVN(
  context,
  // username,
  // password,
  // email,
  // phone,
) {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  String pin = '';
  String bvn = '';
  String email = '';
  String addr = '';
  final Brakey brakey = Get.find();
  return showModalBottomSheet(
      context: context,
      isDismissible: false,
      // enableDrag: false,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
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
                          autofillHints: [AutofillHints.email],
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Email address',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            email = text.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your email address';
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
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      // Container(
                      //   margin: const EdgeInsets.symmetric(vertical: 15),
                      //   child: TextFormField(
                      //     cursorColor: Colors.black,
                      //       keyboardType: TextInputType.number,
                      //       maxLength: 4,
                      //       obscureText: true,
                      //     decoration: const InputDecoration(
                      //       fillColor: Color.fromARGB(24, 158, 158, 158),
                      //       filled: true,
                      //       hintMaxLines: 2,
                      //       helperMaxLines: 2,
                      //       errorMaxLines: 2,
                      //       focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide.none,
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10))),
                      //       hintText: 'Transaction PIN',
                      //       helperText: 'Set your 4 digit Transaction PIN ',
                      //       border: OutlineInputBorder(
                      //           borderSide: BorderSide.none,
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10))),
                      //       contentPadding:
                      //           EdgeInsets.symmetric(horizontal: 10),
                      //     ),
                      //     onChanged: (text) {
                      //       pin = text.trim();
                      //       _loginButtonController.reset();
                      //     },
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty || value.trim().length < 4) {
                      //         return 'Set your 4 digit Transaction PIN ';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      
                      // Container(
                      //   margin: const EdgeInsets.symmetric(vertical: 15),
                      //   child: TextFormField(
                          
                      //     cursorColor: Colors.black,
                      //       keyboardType: TextInputType.number,
                      //       maxLength: 4,
                      //       obscureText: true,
                      //     decoration: const InputDecoration(
                      //       fillColor: Color.fromARGB(24, 158, 158, 158),
                      //       filled: true,
                      //       hintMaxLines: 2,
                      //       helperMaxLines: 2,
                      //       errorMaxLines: 2,
                      //       focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide.none,
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10))),
                      //       hintText: 'Confirm Transaction PIN',
                      //       border: OutlineInputBorder(
                      //           borderSide: BorderSide.none,
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10))),
                      //       contentPadding:
                      //           EdgeInsets.symmetric(horizontal: 10),
                      //     ),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty || value != pin) {
                      //         return 'Enter the same Transaction PIN ';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      
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
        
                                  Map a = await sendOTP(
                                    email,
                                    bvn,
                                  );
                                //   print(a);
                                  if (a.containsKey('Payload')) {
                                    if (a['Status'] == 'successful' || a['Response Code'] == 202) {
                                      _loginButtonController.success();
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return WillPopScope(
                                              onWillPop: (() async => false),
                                              child: AlertDialog(
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('Verify OTP'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        _loginButtonController
                                                            .reset();
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(email: email, payload: a['Payload'])));
                                            
                                                        // Navigator.of(context)
                                                        //     .pop();
                                                        // Navigator.of(context)
                                                        //     .pop();
                                                      },
                                                    )
                                                  ],
                                                  title: Text(
                                                      "OTP sent to $email"),
                                                  content: Text(toTitleCase(a['Message']))),
                                            );
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
                                                          _loginButtonController.reset();
                                                    },
                                                  )
                                                ],
                                                title: const Text(
                                                    "OTP request failed"),
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
                                                      // Navigator.of(context)
                                                      //     .pop();
                                                      // Navigator.of(context)
                                                      //     .pop();
                                                    },
                                                  )
                                                ],
                                                title: const Text(
                                                    "Failed"),
                                                content: Text(toTitleCase(a['Message'])));
                                          });
                                      // }
        
                                    }
                                } else {
                                  _loginButtonController.reset();
                                }
                              },
                              child: const Text('Send OTP')))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
