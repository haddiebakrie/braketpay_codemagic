import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../brakey.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class ChangePassword extends StatefulWidget {

  ChangePassword({Key? key, required this.email}) : super(key: key);

  String email;
  
  @override
  State<ChangePassword> createState() => _ChangePasswordState();

}

class _ChangePasswordState extends State<ChangePassword> {
  Brakey brakey = Get.put(Brakey());
  String pin = '';
  bool passwordVisible = true;
  String otp = '';
    final _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
      elevation: 0,
      title: const Text('Change Password')

      ),
      body: Container(
          decoration: ContainerBackgroundDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(children: [
                            const SizedBox(height:10),
              Container(
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height:15),
                        Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Enter the OTP sent to ${widget.email}',
                                      style: const TextStyle(),
                                    ),
                                  ),
                                TextFormField(
                                  autofillHints: const [AutofillHints.oneTimeCode],
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                                  decoration: const InputDecoration(
                                    // suffixIcon: otp.length == 6 ? Container(height: 10, width: 10, padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth:2)) : Container(width:0, height:0),
                                    fillColor: Color.fromARGB(24, 158, 158, 158),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    hintText: '******',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onChanged: (text) async {
                                    setState(() {
                                    otp = text.trim();

                                    });
                                    // if (otp.length == 6) {
                    
                                    // }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: const Text(
                                      'Set new Password',
                                      style: TextStyle(),
                                    ),
                                  ),
                                TextFormField(
                                  obscureText: passwordVisible,
                                  autofillHints: const [AutofillHints.newPassword],
                                    // keyboardType: TextInputType.number,
                                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                          // print(passwordVisible);
                                        },
                                        icon: passwordVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)
                                        ),
                                    // suffixIcon: otp.length == 6 ? Container(height: 10, width: 10, padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth:2)) : Container(width:0, height:0),
                                    fillColor: const Color.fromARGB(24, 158, 158, 158),
                                    filled: true,
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    hintText: '*******',
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onChanged: (text) async {
                                    setState(() {
                                    pin = text.trim();
                                      
                                    });
                                    // if (otp.length == 6) {
                    
                                    // }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value.length < 8) {
                                      return 'Password should be at least 8 characters long';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height:20),
                      RoundedLoadingButton(
                                    borderRadius: 10,
                                    color: pin.length > 8 && otp.length > 3 ? Theme.of(context).primaryColor : Colors.grey.withAlpha(100),
                                    elevation: 0,
                                    controller: _loginButtonController,
                                    onPressed: () async {

                                      if (_formKey.currentState!.validate()) {
                  
                                        Map a = await changePIN('password', brakey.user.value!.payload!.email??'', brakey.user.value!.payload!.publicKey??'', otp, pin, '');
                                      //   print(a);
                                        if (a.containsKey('Status')) {
                                          if (a['Status'] == 'successfull'|| a['Status'] == 'successful' ) {
                                            _loginButtonController.success();
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return WillPopScope(
                                                    onWillPop: (() async => false),
                                                    child: AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                                                              _loginButtonController
                                                                  .reset();
                                                                  brakey.refreshUserDetail();
                                                                 Get.offUntil(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              WelcomeBack(),
                                                                          maintainState: false),
                                                                      (route) => false);
                                                                  brakey.logoutUser();
                                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(email: email, payload: bvn == '' ? {} : a['Payload'])));
                                                  
                                                              // Navigator.of(context)
                                                              //     .pop();
                                                              // Navigator.of(context)
                                                              //     .pop();
                                                            },
                                                          )
                                                        ],
                                                        title: const Text(
                                                            "Successful"),
                                                        content: Text(toTitleCase(a['Message']))),
                                                  );
                                                });
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
                                                                _loginButtonController.reset();
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Failed"),
                                                      content: Text(toTitleCase(a['Message'])));
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
                                                      content: Text(toTitleCase(a['Message']??'No Internet access')));
                                                });
                                            // }
                  
                                          }
                                      } else {
                                        _loginButtonController.reset();
                                      }
                                      },
                                    child: const Text('Set Password')),
          
          
            ],),
          )
          
          )

    );
  }
}


  forgotPasswordPrompt() async {
     final RoundedLoadingButtonController _sendOTPButtonController =
      RoundedLoadingButtonController();
      final RoundedLoadingButtonController _loginOTPButtonController =
      RoundedLoadingButtonController();
      Brakey brakey = Get.put(Brakey());
    Get.bottomSheet(
          BottomSheet(
            backgroundColor: Colors.transparent,
            onClosing: () {}, builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
                decoration: ContainerBackgroundDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
          width: 60,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(height:10),
        Icon(Icons.lock, color: Colors.blue, size: 40),
        //   const Text(
        //   'Change transaction PIN',
        //   style: TextStyle(
        //       fontSize: 20, fontWeight: FontWeight.w300),
        // ),
        const SizedBox(height:15),
        Text('To protect your account, a verification OTP will be sent to ${brakey.user.value!.payload!.email}'),
        const SizedBox(height:10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();

            }, child: const Text('Cancel')),
        RoundedLoadingButton(
          width: 30,
          elevation: 0,
          color: Colors.transparent,
          valueColor: Theme.of(context).primaryColor,
          controller: _sendOTPButtonController,
          onPressed: () async {
          Map a = await forgotPINOtp('Password' ,brakey.user.value!.payload!.email??'', brakey.user.value!.payload!.publicKey??'');
            if (a.containsKey('Status')) {
              Get.close(1);
                    if (a['Status'] == 'successfull' || a['Response Code'] == 202 || a['Response Code'] == 422 || a['Response Code'] == 406 || a['Status'] == 'successful') {
                      _sendOTPButtonController.success();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return WillPopScope(
                              onWillPop: (() async => false),
                              child: AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Verify OTP'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop();
                                        _loginOTPButtonController
                                            .reset();
                                          Get.to(() => ChangePassword(email: brakey.user.value!.payload!.email??''));
                            
                                        // Navigator.of(context)
                                        //     .pop();
                                        // Navigator.of(context)
                                        //     .pop();
                                      },
                                    )
                                  ],
                                  title: Text(
                                      "OTP sent to ${brakey.user.value!.payload!.email}"),
                                  content: Text(toTitleCase(a['Message']))),
                            );
                          });
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
                                          _sendOTPButtonController.reset();
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                actions: [
                                  TextButton(
                                    child: const Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop();
                                          _sendOTPButtonController.reset();
                                      // Navigator.of(context)
                                      //     .pop();
                                      // Navigator.of(context)
                                      //     .pop();
                                    },
                                  )
                                ],
                                title: const Text(
                                    "Failed"),
                                content: Text(toTitleCase(a['Message']??'No Internet access')));
                          });
                      // }

                    }


        }, child: Text('Change Password', style: TextStyle(color: Theme.of(context).primaryColor))),
          ],
        ),
                  ],
                )

            );
          })

        );
  }
