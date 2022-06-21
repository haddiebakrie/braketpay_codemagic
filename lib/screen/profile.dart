import 'dart:convert';
import 'dart:typed_data';

import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/changepassword.dart';
import 'package:braketpay/screen/changepin.dart';
import 'package:braketpay/uix/listitemseparated.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../uix/roundbutton.dart';
import '../utils.dart';
import './userqr.dart';
import './login.dart';
import 'bvnprompt.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.user, required this.pin})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
  final User user;
  final String pin;
}

class _ProfileState extends State<Profile> {
  Brakey brakey = Get.put(Brakey());
  bool isDark = false;
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  late var byte = hex.decode(widget.user.payload!.qrCode ?? '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            title: const Text('Profile'), centerTitle: true, elevation: 0),
        body: Container(
            height: double.infinity,
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: ContainerBackgroundDecoration().copyWith(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(29),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //     height: 250,
                  //     width: double.infinity,
                  //     clipBehavior: Clip.antiAliasWithSaveLayer,
                  //     margin: EdgeInsets.all(5),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Colors.white,
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.grey.withOpacity(0.5),
                  //             spreadRadius: 3,
                  //             blurRadius: 10,
                  //             offset: const Offset(0, 0),
                  //           )
                  //         ]),
                  //       padding: EdgeInsets.all(10),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //       Text('Your profile QRCODE', textAlign: TextAlign.center,style: TextStyle(color: Colors.grey)),
                  //       Image.memory(Uint8List.fromList(byte), width: 150, height: 150),
                  //         Text('@${widget.user.payload!.fullname}', textAlign: TextAlign.center,style: TextStyle(color: Color.fromARGB(255, 0, 15, 220))),
                  //     ])),
                  Container(
                      // height: 250,
                      width: double.infinity,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.all(5),
                      decoration: ContainerDecoration(),
                      padding: const EdgeInsets.all(5),
                      child: Column(children: [
                        ListTile(
                          trailing: Column(
                            children: [
                              SizedBox(
                                height: 35,
                                child: IconButton(
                                    icon: const Icon(CupertinoIcons.qrcode),
                                    color: Theme.of(context).primaryColor,
                                    iconSize: 25,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => UserQR()));
                                    }),
                              ),
                              const Text('scan me',
                                  style:
                                      TextStyle()),
                            ],
                          ),
                          horizontalTitleGap: 10,
                          title: Text('@${widget.user.payload!.username}'),
                          subtitle: InkWell(
                            onTap: () {
                              if (brakey.user.value!.payload!.bvn !=
                                  'Not added') {
                                print('hi');
                                Clipboard.setData(ClipboardData(
                                    text: brakey.user.value!.payload!
                                            .accountNumber ??
                                        ''));
                                Get.showSnackbar(const GetSnackBar(
                                    duration: Duration(seconds: 1),
                                    messageText: Text(
                                        'Account number has been copied',
                                        style:
                                            TextStyle(color: Colors.white))));
                              }
                            },
                            child: Row(
                              children: [
                                Text(brakey.user.value!.payload!.bvn !=
                                        'Not added'
                                    ? '${widget.user.payload!.accountNumber} '
                                    : '**********'),
                                brakey.user.value!.payload!.bvn != 'Not added'
                                    ? Icon(CupertinoIcons.doc_on_doc_fill,
                                        size: 15,
                                        color: Theme.of(context).primaryColor)
                                    : Container()
                              ],
                            ),
                          ),
                          leading: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                      icon: const Icon(CupertinoIcons.person_fill),
                                      color: Colors.white,
                                      iconSize: 30,
                                  onPressed: () {
                                  }),
                            ),
                          ),
                        ),
                        ListTile(
                            subtitle: Text(widget.user.payload!.fullname ?? ''),
                            title: const Text('Fullname')),
                        ListTile(
                            subtitle: Text(widget.user.payload!.email ?? ''),
                            title: const Text('Email')),
                        ListTile(
                            subtitle:
                                Text(widget.user.payload?.phoneNumber?.replaceFirst('234','0') ?? ''),
                            title: const Text('Phone')),
                        ListTile(
                            subtitle:
                                Text(widget.user.payload!.walletAddress ?? ''),
                            title: const Text('Your Braket Wallet Address')),
                        brakey.user.value!.payload!.bvn ==
                                        'Not added'
                                    ? InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BVNPrompt()));
                                      },
                            child: const ListTile(
                                subtitle: Text(
                                    'Set Braket PIN to get your Account Number'),
                                title: Text('Set Transaction PIN'),
                                trailing: Icon(Icons.arrow_right)
                                )) : Visibility(visible: false, child: Container()),
                      ])),
                  Container(
                    // height: 250,
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.all(5),
                    decoration: ContainerDecoration(),
                    // decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(20),
                        // color: Get.isDarkMode ? Colors.black : Colors.white,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.2),
                        //     spreadRadius: 3,
                        //     blurRadius: 10,
                        //     offset: const Offset(0, 0),
                        //   )
                        // ]),
                    child: Column(children: [
                      const Text(
                        'Security',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                      ListTile(
                        onTap: () {
                          Get.bottomSheet(
                            BottomSheet(
                              backgroundColor: Colors.transparent,
                              onClosing: () {}, builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight:Radius.circular(20))
                                  ),
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
                          Icon(Icons.password, color: Colors.blue, size: 40),
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
                          TextButton(onPressed: () {
                            Get.to(() => ChangePin(email: brakey.user.value!.payload!.email??''));

                          }, child: const Text('Ok, Send')),
                            ],
                          ),
                                    ],
                                  )

                              );
                            })

                          );
                        },
                        title: const Text(
                            'Change Transaction Pin'),
                        trailing: const Icon(Icons.arrow_right)
                        ),
                      ListTile(
                        onTap: () async {
                          await forgotPasswordPrompt();
                        },
                                title: Text(
                                    'Change Password'),
                                trailing: Icon(Icons.arrow_right)
                                ),
                      // ListTile(
                      //     title: const Text('Show balance'),
                      //     trailing: Switch(value: !brakey.showBalance.value, onChanged: (a) => {
                      //       brakey.toggleShowBalance(),
                      //       setState(() => {
                              
                      //       })
                      //       })),
                      // ListTile(
                      //     title: const Text('Pay with biometric'),
                      //     trailing: Switch(value: false, onChanged: (a) => {})),
                      // ListTile(
                      //     title: const Text('Unlock app with biometric'),
                      //     trailing: Switch(value: false, onChanged: (a) => {})),

                    ]),
                  ),
                  // const SizedBox(height: 10),
                  Container(
                    // height: 250,
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.all(5),
                    decoration: ContainerDecoration(),
                    child: Column(children: [
                      const Text(
                        'Preferences',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                      ListTile(
                          title: const Text('Dark mode'),
                          trailing: Switch(
                              value: isDark,
                              onChanged: (a) => {
                                    // setState(() {
                                    //   isDark = !isDark;
                                    // }),
                                    // print(isDark),
                                    // print(Get.isDarkMode),
                                    
                                    // Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark)
                                  })),
                      ListTile(
                          title: const Text('Hide balance'),
                          trailing: Switch(value: brakey.showWalletBalance(), onChanged: (a) => {
                            setState(() {
                            brakey.toggleBalance();

                            })
                          })),
                      // ListTile(
                      //     title: const Text('Show balance'),
                      //     trailing: Switch(value: brakey.showWalletBalance.value, onChanged: (a) => {
                      //       setState(() {

                      //       }),
                      //       brakey.toggleWalletBalance(),
                      //       brakey.refreshApp!()

                      //     }))
                    ]),
                  ),
                  const SizedBox(height: 20),
                  RoundButton(
                      // controller: _loginButtonController,
                      width: double.infinity,
                      color1: NeutralButton,
                      color2: NeutralButton,
                      onTap: () {
                        Get.offUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Login(showOnboarding: true, hasUser: true),
                                maintainState: false),
                            (route) => false);
                        brakey.logoutUser();
                      },
                      text: 'Logout')
                ],
              ),
            )));
  }

  forgotPasswordPrompt() async {
     final RoundedLoadingButtonController _sendOTPButtonController =
      RoundedLoadingButtonController();
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
          Map a = await sendOTP(brakey.user.value!.payload!.email??'', '', 'forgot password', '');
            if (a.containsKey('Status')) {
                    if (a['Status'] == 'successfull' || a['Response Code'] == 202 || a['Response Code'] == 422 || a['Response Code'] == 406 || a['Status'] == 'successful') {
                      _sendOTPButtonController.success();
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
}
