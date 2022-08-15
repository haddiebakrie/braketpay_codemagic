import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../utils.dart';

class BVNPrompt extends StatefulWidget {
  const BVNPrompt({Key? key}) : super(key: key);

  @override
  State<BVNPrompt> createState() => _BVNPromptState();
}

class _BVNPromptState extends State<BVNPrompt> {
  @override
  final _formKey = GlobalKey<FormState>();
  String bvn = '';
    final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
    final RoundedLoadingButtonController _verifyButtonController =
      RoundedLoadingButtonController();
  Brakey brakey = Get.put(Brakey());
  String pin = '';
  String phone = '';
  String demoPhone = '';
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: const Text('Set Transaction PIN'),
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: ContainerBackgroundDecoration(),
          child: ListView(
            children: [
              Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(height:20),
                    const Text('Your NIN or BVN is required to set your Transaction PIN', textAlign: TextAlign.center, style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),),
                    const SizedBox(height:20),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(
                              'Enter your NIN or BVN',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                // height: 100,
                                child: TextFormField(
                                  cursorColor: Colors.grey,
                                    maxLength:11,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    fillColor: Color.fromARGB(24, 158, 158, 158),
                                    filled: true,
                                    // suffixIcon: IconButton(
                                    //   icon: Icon(Icons.phone, color: Theme.of(context).primaryColor),
                                    //   onPressed: () {

                                    //     FlutterPhoneDirectCaller.callNumber('*565#');
                                    //   }
                                    //   ),
                                    hintMaxLines: 2,
                                    helperMaxLines: 2,
                                    errorMaxLines: 2,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    hintText: 'XXXXXXXXXXX',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                    bvn = text.trim();
                                      
                                    });
                                    _verifyButtonController.reset();
                                  },
                                  validator: (value) {
                                    if (value != null &&
                                        value.isNotEmpty &&
                                        value.trim().length < 11) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(

                                  width: 70,
                                child: RoundedLoadingButton(
                                  successColor: Colors.white,
                                  loaderStrokeWidth: 4,
                                  borderRadius: 0,
                                  valueColor: Theme.of(context).primaryColor,
                                  elevation: 0,
                                  color: Colors.transparent,
                                  controller: _verifyButtonController,
                                  child: Text('verify', style: TextStyle(color: Theme.of(context).primaryColor)), onPressed: () async{
                                  Map a = await sendOTP(brakey.user.value!.payload!.email??'', bvn, 'verify bvn_nin_after_signup', brakey.user.value!.payload!.password??'');
                                print('ab');
                                if (a.containsKey('Payload')) {
                                      _verifyButtonController.success();
                                      setState(() {
                                      demoPhone = a['Payload']['phone_number'];
                                        
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
                                                  child: const Text(
                                                      'Okay'),
                                                  onPressed: () {
                                                    Navigator.of(
                                                            context)
                                                        .pop();
                                                    _verifyButtonController.reset();
                                                    // Navigator.of(context)
                                                    //     .pop();
                                                    // Navigator.of(context)
                                                    //     .pop();
                                                  },
                                                )
                                              ],
                                              title: const Text(
                                                  "BVN Validation failed"),
                                              content:
                                                  Text(toTitleCase(a['Message'])));
                                        });
                                  }
                                }),
                              )
                            ],
                          ),
                          Visibility(
                            visible: demoPhone != '',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height:20),
                          Container(
                            child: Text(
                              'Verify Phone number - ${demoPhone != '' ? demoPhone.substring(0, 5): ''}XXXXXX',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      cursorColor: Colors.grey,
                                      // controller: _userPasswordController,
                                      decoration: InputDecoration(
                                        hintText: '${demoPhone != '' ? demoPhone.substring(0, 5): ''}XXXXXX',
                                        helperText: 'Confirm the phone number linked to $bvn',
                                        fillColor: const Color.fromARGB(24, 158, 158, 158),
                                        filled: true,
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                        contentPadding:
                                            const EdgeInsets.symmetric(horizontal: 10),
                                      ),
                                      onChanged: (text) {
                                        setState(() {
                                        phone = text;
                                          
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Confirm the phone number linked to $bvn';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                obscureText: passwordVisible,
                                maxLength: 4,
                                cursorColor: Colors.grey,
                                // controller: _userPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(onPressed: () {
                                      print(passwordVisible);
                                     setState(() {
                                       passwordVisible = !passwordVisible;
                                     });
                                      // print(passwordVisible);
                                    },
                                     icon: passwordVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)
                                    ),
                                  hintText: 'Transaction PIN',
                                  helperText: 'Set a 4 digits transaction PIN',
                                  fillColor: const Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (text) {
                                  setState(() {
                                  pin = text;
                                    
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter your PIN';
                                  }
                                  if (value.length < 4) {
                                    return 'PIN must be 4 digits';
                                  }
                                  return null;
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height:20),
                    RoundedLoadingButton(
                                  borderRadius: 10,
                                  color: demoPhone.length > 10 && pin.length == 4  ? Theme.of(context).primaryColor : Colors.grey,
                                  elevation: 0,
                                  controller: _loginButtonController,
                                  onPressed: () async {
                                    if (demoPhone == '') {
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
                                                            _loginButtonController
                                                                .reset();
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "BVN not Verified"),
                                                      content: const Text('Enter your NIN or BVN and click on the verify Button to verify.')));
                                    });
                                      _loginButtonController.reset();
                                      return;
                                    }
                                    // print(phone+demoPhone);
                                    if (phone != demoPhone) {
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
                                                            _loginButtonController
                                                                .reset();
                                                          },
                                                        )
                                                      ],
                                                      title: const Text(
                                                          "Invalid phone number"),
                                                      content: Text('The phone number entered does not match the one linked to $bvn')));
                                    });
                                                return;}
                                    if (_formKey.currentState!.validate()) {
        
                                      Map a = await setBVN(
                                        brakey.user.value!.payload!.phoneNumber?.replaceFirst('234', '') ?? '',
                                        brakey.user.value!.payload!.email ?? '',
                                        brakey.user.value!.payload!.password ?? '',
                                        brakey.user.value!.payload!.username ?? '',
                                        bvn,
                                        pin,
                                        brakey.user.value!.payload!.walletAddress ?? '',
                                      
                                      );
                                    //   print(a);
                                      if (a.containsKey('Status')) {
                                        if (a['Status'] == 'successfull' || a['Status'] == 'successful') {
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
                                                              // Navigator.of(context)
                                                              //   .pop();
                                                            _loginButtonController
                                                                .reset();
                                                            brakey.refreshUserDetail();
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
                                  child: const Text('Set PIN')),
                                  const SizedBox(height: 20,),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.shield, color: Colors.blueGrey, size:15),
                                        SizedBox(width: 5),
                                        Text('Braket is CBN KYC Compliant', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                      ],
                                    ),
                                  )
                  ])),
            ],
          ),
        ));
  }
}
