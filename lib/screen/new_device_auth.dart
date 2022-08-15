import 'package:braketpay/constants.dart';
import 'package:braketpay/screen/bvn.dart';
import 'package:braketpay/screen/forgot_password.dart';
import 'package:braketpay/screen/userlogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/userinfo.dart';
import '../brakey.dart';
import '../classes/user.dart';
import '../modified_packages/modified_numerickeyboard.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';
import 'changepassword.dart';
import 'login.dart';
import 'manager.dart';

class NewDeviceAuth extends StatefulWidget {
  NewDeviceAuth({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<NewDeviceAuth> createState() => _NewDeviceAuthState();

  String email;
  String password;
}

class _NewDeviceAuthState extends State<NewDeviceAuth> {
  final Brakey brakey = Get.find();
  String otp='';

  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  // String _errorMessage = '';
  final TextEditingController _pinEditController = TextEditingController();
  String username = '';
  String password = '';
  String pin = '';
  late String _errorMessage = '';
  bool passwordVisible = true;
  final Icon _passwordIcon = const Icon(Icons.visibility_off);
  @override
  Widget build(BuildContext context) {
    checkForUpdate();

    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Theme(
            data: ThemeData.dark(),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          colors: [
                        Color.fromARGB(255, 68, 19, 137),
                        Color.fromARGB(255, 19, 1, 213)
                      ])),
                ),
                Opacity(
                    opacity: 0.8,
                    child: Image.asset('assets/braket-bg_grad-01.png',
                        height: double.infinity, fit: BoxFit.cover)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // height: 150,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0).copyWith(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Verify it\'s you!',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Impact',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'This device is\'t recognized. For your security, Braket wants to make sure it\'s really you.',
                              style: TextStyle(
                                  fontFamily: 'Impact',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: 'NewDeviceAuthContainer',
                          child: Container(
                            margin: const EdgeInsets.all(10.0).copyWith(top: 0),
                            child: GlassContainer(
                              blur: 4,
                              borderRadius: BorderRadius.circular(20),
                              // shadowStrength: 10,
                              color: Colors.white.withOpacity(0.15),
                              //   gradient: LinearGradient(
                              //   begin: Alignment.topLeft,
                              //   end: Alignment.bottomRight,
                              //   colors: [
                              //     Colors.white.withOpacity(0.2),
                              //     Colors.blue.withOpacity(0.3),
                              //   ],
                              // ),
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                // decoration: ContainerDecoration().copyWith(
                                // ),
                                child: SingleChildScrollView(
                                  child: AutofillGroup(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          width: 60,
                                          height: 5,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        Text(
                                          'Enter the OTP sent to ${widget.email}',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        PinCodeTextField(
                                          textStyle: TextStyle(color: Colors.white),
                                          onChanged: (value) {
                                            setState(() {
                                              otp = value;
                                            });
                                          },
                                          // onCompleted: (text) {
                                          //   _loginButtonController.c;
                                          // },
                                          appContext: context,
                                          animationDuration: Duration(milliseconds: 100),
                                          animationType: AnimationType.scale,
                                          length: 6,
                                          blinkWhenObscuring: true,
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.underline,
                                            borderRadius: BorderRadius.circular(10),
                                            activeFillColor: Colors.transparent,
                                            borderWidth: 0,
                                            inactiveColor: Colors.transparent,
                                            activeColor: Colors.transparent,
                                            inactiveFillColor: Colors.transparent,
                                            selectedFillColor: Colors.transparent,
                                            selectedColor: Colors.transparent,
                                          ),
                                          keyboardType: TextInputType.number,
                                          obscureText: true,
                                          controller: _pinEditController,
                                          hintCharacter: '●',
                                          hintStyle: TextStyle(color: Colors.white54),
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CustomNumericKeyboard(
                                          textColor: Colors.white,
                                          rightIcon: const Icon(CupertinoIcons.delete_left_fill),
                                          rightButtonFn: () {
                                            _pinEditController.text = _pinEditController.text.substring(0, _pinEditController.text.length - 1);
                                    
                                          },
                                          onKeyboardTap: 
                                          (text) {
                                            _pinEditController.text = _pinEditController.text + text;
                                          }
                                        ),
    
                                        // Container(
                                        //   margin: const EdgeInsets.symmetric(
                                        //       vertical: 5),
                                        //   child: TextFormField(
                                        //     autofillHints: const [
                                        //       AutofillHints.username
                                        //     ],
                                        //     cursorColor: Colors.grey,
                                        //     keyboardType: TextInputType.multiline,
                                        //     minLines: null,
                                        //     style: TextStyle(
                                        //         fontWeight: FontWeight.w600,
                                        //         fontSize: 17),
                                        //     maxLines: null,
                                        //     decoration: const InputDecoration(
                                        //       fillColor: Color.fromARGB(
                                        //           30, 255, 255, 255),
                                        //       filled: true,
                                        //       focusedBorder: OutlineInputBorder(
                                        //           borderSide: BorderSide.none,
                                        //           borderRadius: BorderRadius.all(
                                        //               Radius.circular(10))),
                                        //       hintText: 'Username\n',
                                        //       hintStyle: const TextStyle(
                                        //           fontWeight: FontWeight.w600),
                                        //       border: OutlineInputBorder(
                                        //           borderSide: BorderSide.none,
                                        //           borderRadius: BorderRadius.all(
                                        //               Radius.circular(10))),
                                        //       contentPadding: EdgeInsets.all(10),
                                        //     ),
                                        //     onChanged: (text) {
                                        //       username = text.trim();
                                        //     },
                                        //     validator: (value) {
                                        //       if (value == null ||
                                        //           value.isEmpty) {
                                        //         return 'Enter your username';
                                        //       }
                                        //       return null;
                                        //     },
                                        //   ),
                                        // ),
                                        // SizedBox(height: 10),
                                        // Container(
                                        //   margin: const EdgeInsets.symmetric(
                                        //       vertical: 5),
                                        //   child: TextFormField(
                                        //     obscureText: passwordVisible,
                                        //     cursorColor: Colors.grey,
                                        //     autofillHints: const [
                                        //       AutofillHints.password
                                        //     ],
                                        //     // controller: _userPasswordController,
                                        //     obscuringCharacter: '●',
                                        //     style: TextStyle(
                                        //         fontWeight: FontWeight.w600,
                                        //         fontSize: 17),
                                        //     decoration: InputDecoration(
                                        //       // suffixIcon: 
                                        //       suffixIcon: password == '' ? Container(
                                        //           margin: EdgeInsets.all(5),
                                        //           decoration: BoxDecoration(
                                        //               // color: Colors.teal,
                                        //               // gradient: tealGradient,
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                       10)),
                                        //           child: TextButton(
                                        //               child: Text(
                                        //                 'Forgot?',
                                        //                 style: TextStyle(
                                        //                     color: Colors.white),
                                        //               ),
                                        //               onPressed: () {Get.to(() => ForgotPassword());})) : IconButton(onPressed: () {
                                        //         // print(passwordVisible);
                                        //        setState(() {
                                        //          passwordVisible = !passwordVisible;
                                        //        });
                                        //         // print(passwordVisible);
                                        //       },
                                        //        icon: passwordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                                        //       ),
                                        //       hintText: 'Password\n',
    
                                        //       hintStyle: const TextStyle(
                                        //           fontWeight: FontWeight.w600),
                                        //       fillColor: Color.fromARGB(
                                        //           30, 255, 255, 255),
                                        //       filled: true,
                                        //       focusedBorder:
                                        //           const OutlineInputBorder(
                                        //               borderSide: BorderSide.none,
                                        //               borderRadius:
                                        //                   BorderRadius.all(
                                        //                       Radius.circular(
                                        //                           10))),
                                        //       border: const OutlineInputBorder(
                                        //           borderSide: BorderSide.none,
                                        //           borderRadius: BorderRadius.all(
                                        //               Radius.circular(10))),
                                        //       contentPadding:
                                        //           const EdgeInsets.symmetric(
                                        //               horizontal: 10),
                                        //     ),
                                        //     onChanged: (text) {
                                        //       setState(() {
                                        //           password = text;
                                                
                                        //       });
                                        //     },
                                        //     validator: (value) {
                                        //       if (value == null ||
                                        //           value.isEmpty) {
                                        //         return 'Enter your Password';
                                        //       }
                                        //       return null;
                                        //     },
                                        //   ),
                                        // ),
                                        // // Row(
                                        // //         mainAxisAlignment: MainAxisAlignment.end,
                                        // //         children: [
                                        //           TextButton(child: Text('Forgot password?')
                                        //           ,
                                        //           onPressed: () {
                                        //             forgotPasswordPrompt();
                                        //           },
                                        //           ),
                                        //         ],
                                        //       ),
                                        SizedBox(height: 30),
                                        Container(
                                          // margin: const EdgeInsets.all(10),
                                          child: RoundedLoadingButton(
                                              borderRadius: 10,
                                              color:
                                                  Theme.of(context).primaryColor,
                                              elevation: 6,
                                              controller: _loginButtonController,
                                              onPressed: () async {
                                                FocusManager.instance.primaryFocus
                                                    ?.unfocus();
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  
                                                  // print('$username, $pin, $password');
                                                  try {
                                                    bool a = await fetchUserRecord(
                                                        widget.email, widget.password, otp);
                                                    _loginButtonController
                                                        .success();
                                                    print(a);
                                                    // return;
                                                    Get.offUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserLogin(),
                                                            maintainState: true),
                                                        (route) => false);
                                                    // promptSaveBiometric();
    
                                                    // Navigator.pushAndRemoveUntil(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             Manager(user: a, pin: "")), Manager(user:a, pin:''));
                                                  } catch (e) {
                                                    print(e);
                                                    _loginButtonController
                                                        .reset();
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
                                                                  "Can't Login!"),
                                                              content: Text(
                                                                  toTitleCase(e
                                                                      .toString())));
                                                        });
                                                  }
                                                } else {
                                                  _loginButtonController.reset();
                                                }
                                              },
                                              child: const Text('Login')),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'New to BraketPay?',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white54),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Get.close(1);
                                                  Get.to(() => AskBVN());
                                                },
                                                child: Text(
                                                  'Sign up',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

promptSaveBiometric() {
  final Brakey brakey = Get.find();

  return Get.bottomSheet(BottomSheet(
      backgroundColor: Colors.transparent,
      onClosing: () {},
      builder: (context) {
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
                const SizedBox(height: 10),
                Icon(Icons.fingerprint_rounded, color: Colors.green, size: 40),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  'Enable Fingerprint Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  'This can be changed in your profile setting',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Skip')),
                    TextButton(
                        onPressed: () {
                          brakey.toggleBiometric(true);
                          Get.close(1);
                        },
                        child: const Text('Enable')),
                  ],
                ),
              ],
            ));
      }));
}
