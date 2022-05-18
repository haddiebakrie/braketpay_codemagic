import 'dart:convert';
import 'dart:typed_data';

import 'package:braketpay/uix/listitemseparated.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.user, required this.pin}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
  final User user;
  final String pin;
}

class _ProfileState extends State<Profile> {
    final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  late var byte = hex.decode(widget.user.payload!.qrCode ?? '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepOrange,
        appBar: AppBar(title: const Text('Profile'), centerTitle: true, elevation: 0),
        body: Container(
            height: double.infinity,
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            )
                          ]),
                      padding: const EdgeInsets.all(5),
                      child: Column(children: [
                        ListTile(
                          trailing: const Icon(Icons.qr_code_2, color: Colors.deepOrange),
                          horizontalTitleGap: 10,
                          title: Text('@${widget.user.payload!.fullname!.split(' ')[0]}'),
                            subtitle: Text('${widget.user.payload!.accountNumber}'),
                          leading: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20)),
                            child: IconButton(
                                icon: const Icon(IconlyBold.profile),
                                color: Colors.white,
                                iconSize: 20,
                                onPressed: () {
                                  
                                }),
                          ),
                        ),
                        ListTile(subtitle: Text(widget.user.payload!.fullname ??''), title: const Text('Fullname')),
                        ListTile(subtitle: Text(widget.user.payload!.email ??''), title: const Text('Email')),
                        ListTile(subtitle: Text(widget.user.payload!.phoneNumber ??''), title: const Text('Phone')),
                        ListTile(subtitle: Text(widget.user.payload!.walletAddress ??''), title: const Text('Address')),
                      ])),
                      Container(
                      // height: 250,
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            )
                          ]),
                          child: Column(
                            children: [
                              const Text(
                              'Preferences',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.w300),),
                                ListTile(title: const Text('Dark mode'), trailing: Switch(value: false, onChanged: (a) => {} )),
                                ListTile(title: const Text('Disable screenshot'),subtitle: const Text('Prevent screenshot while using BraketPay'),  trailing: Switch(value: true, onChanged: (a) => {} ))
                            ]
                          ),
                          ),
                const SizedBox(height:20),
                RoundedLoadingButton(controller: _loginButtonController, 
                color: Colors.black,
                onPressed: (
                ) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                }, child: const Text('Logout'))
                ],
              ),
            )));
  }
}
