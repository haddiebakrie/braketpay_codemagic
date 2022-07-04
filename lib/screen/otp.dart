import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/screen/bvn.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'manager.dart';

Future<dynamic> askOTP(
  context,
  username,
  password,
  firstname,
  surname,
  email,
  phone,
) {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  String otp = '';
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
              decoration: ContainerBackgroundDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter the code sent to $email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                            keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'OTP',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            otp = text.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the OTP code sent to your email';
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
                                  Map a = await createUserAccount(
                                    '$surname $firstname',
                                    phone,
                                    '',
                                    email,
                                    password,
                                    username,
                                    otp,
                                    '',
                                    '',
                                    ""
                                  );
                                  print(a);
                                  if (a.containsKey('Status')) {
                                    if (a['Status'] == 'successful') {
                                      _loginButtonController.reset();
                                      // askBVN(context, username, password, email, phone);
                                      // showDialog(
                                      //     context: context,
                                      //     barrierDismissible: false,
                                      //     builder: (loading) {
                                      //       return AlertDialog(
                                      //           title: const Text("Account creation successful"),
                                      //           content: Row(
                                      //             children: const [
                                      //               Padding(
                                      //                 padding: const EdgeInsets.all(15.0),
                                      //                 child: CircularProgressIndicator(),
                                      //               ),
                                      //               Text('Logging you in...'),
                                      //             ],
                                      //           ));
                                      //     });
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
                                                    "Account creation failed"),
                                                content: Text(a['Message']));
                                          });
                                      // }

                                    }
                                }
                              },
                              child: const Text('Verify')))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
