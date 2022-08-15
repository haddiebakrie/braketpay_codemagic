import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/screen/otp.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'manager.dart';

Future<dynamic> askSignup(
  context,
) {
  String email = '';
  String password = '';
  String firstname = '';
  String surname = '';
  String username = '';
  String phone = '';
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();

  return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: true,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                children: [
                  const SizedBox(height: 50),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Firstname',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            firstname = text.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your Firstname';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Surname',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            surname = text.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your Surname';
                            }

                            return null;
                          },
                        ),
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
                            hintText: 'Phone number',
                            helperMaxLines: 2,
                            helperText:
                                'Enter your a Phone number without country code Ex. 09011001100',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            phone = text.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your a Phone number without country code Ex. 09011001100';
                            }
                            if (value.length < 11 || !value.startsWith('0')) {
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
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                        title:
                                            const Text("Invalid phone number!"),
                                        content: const Text(
                                            'Phone number must be in the format 09011001100'));
                                  });
                              return 'Enter your a Phone number without country code Ex. 09011001100';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          cursorColor: Colors.grey,
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
                            print(email);
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
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Username',
                            helperText: 'Enter your unique username',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            username = text.trim();
                          },
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().contains(' ')) {
                              return 'Enter a username (empty spaces are not allowed)';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          obscureText: true,
                          cursorColor: Colors.grey,
                          // controller: _userPasswordController,
                          decoration: const InputDecoration(
                            // suffixIcon: IconButton(onPressed: () {
                            //   setState(() {
                            //     _passwordVisible = !_passwordVisible;
                            //   });
                            // }, icon: Icon(_passwordVisible ?
                            // Icons.visibility :
                            // Icons.visibility_off

                            // )),
                            hintText: 'Password',
                            helperText: 'Password must be at least 8 digits',
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            password = text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your Password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          obscureText: true,
                          cursorColor: Colors.grey,
                          // controller: _userPasswordController,
                          decoration: const InputDecoration(
                            // suffixIcon: IconButton(onPressed: () {
                            //   setState(() {
                            //     _passwordVisible = !_passwordVisible;
                            //   });
                            // }, icon: Icon(_passwordVisible ?
                            // Icons.visibility :
                            // Icons.visibility_off

                            // )),
                            hintText: 'Comfirm Password',
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != password) {
                              return 'Enter your the same Password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: RoundedLoadingButton(
                              borderRadius: 10,
                              color: Theme.of(context).primaryColor,
                              elevation: 0,
                              controller: _loginButtonController,
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  Map a = await sendOTP(email, '', '', '');
                                  if (a.containsKey('Status')) {
                                    if (a['Status'] == 'successful' || a['Status'] == 'successfull' || a['Status'] == 'successful') {
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
                                                    child: const Text('Verify OTP'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _loginButtonController
                                                          .reset();
                                                      askOTP(context, username, password,
                                                          firstname, surname, email, phone);

                                                      // Navigator.of(context)
                                                      //     .pop();
                                                      // Navigator.of(context)
                                                      //     .pop();
                                                    },
                                                  )
                                                ],
                                                title: Text(
                                                    "OTP sent to $email"),
                                                content: Text(a['Message']));
                                          });
                                      _loginButtonController.reset();
                                    } else {
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
                                                    child: const Text('Okay'),
                                                    onPressed: () {
                                                      Navigator.of(context)
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Okay'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
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
                                                  "Account creation failed"),
                                              content: Text((a['Message'])));
                                        });
                                  }
                                } else {
                                  _loginButtonController.reset();
                                }
                              },
                              child: const Text('Sign up')))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
