import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/constants.dart';
import 'package:braketpay/screen/index.dart';
import 'package:braketpay/screen/userlogin.dart';
import 'package:braketpay/screen/welcome.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';
import 'package:braketpay/brakey.dart';
import '../uix/themedcontainer.dart';
import 'manager.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class AskBVN extends StatefulWidget {
  AskBVN({Key? key}) : super(key: key);

  @override
  State<AskBVN> createState() => _AskBVNState();
}

class _AskBVNState extends State<AskBVN> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  String pin = '';
  String bvn = '';
  String phoneNumber = '';
  String email = '';
  String addr = '';
  final Brakey brakey = Get.find();
  bool hasTextFocus = false;
  @override
  Widget build(BuildContext context) {
                                                                              // _loginButtonController.reset();
// 
    return Scaffold(
      
      // backgroundColor: Theme.of(context).primaryColor,
      body: Theme (
        data: ThemeData.dark(),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(gradient: 
              LinearGradient(
                
                begin: Alignment.bottomLeft,
                colors: [Color.fromARGB(255, 68, 19, 137), Color.fromARGB(255, 19, 1, 213)])
              ),
            ),
            Opacity(
              opacity: 0.8,
              child: Image.asset('assets/braket-bg_grad-01.png', height: double.infinity, fit: BoxFit.cover)),

            Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                      Padding(
                        padding: const EdgeInsets.only(left:20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Welcome to \nBraket Universe', style: TextStyle(fontSize: 30, fontFamily: 'Impact', color: Colors.white, fontWeight: FontWeight.w600),),
                        SizedBox(height: 10,),
                        Text('We help you secure payments ', style: TextStyle(fontFamily: 'Impact', color: Colors.white, fontWeight: FontWeight.w600),),
                          ],
                        ),
                      ),
                      
                      ])),
                  Expanded(
                    child: Hero(
                      transitionOnUserGestures: true,
                                tag: 'userLoginContainer',
                      child: Container(
                          margin: const EdgeInsets.all(10.0).copyWith(top:0),
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
                            child: Form(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              width: 60,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                  SizedBox(height: 10,),
                                          const Text(
                                            'Create account',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(vertical: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                            //     Container(
                                            // margin: const EdgeInsets.only(bottom: 10),
                                            // child: const Text(
                                            //   'Email address',
                                            //   style: TextStyle(
                                            //       fontWeight: FontWeight.w600, fontSize: 15),
                                            // ),
                                          // ),
                                                TextFormField(
                                                  autofillHints: const [AutofillHints.email],
                                                  cursorColor: Colors.white,
                                                  keyboardType: TextInputType.emailAddress,
                                                  minLines: null,
                                                  maxLines: null,
                                                  decoration: const InputDecoration(
                                                    fillColor: Color.fromARGB(30, 255, 255, 255),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(10))),
                                                    hintText: 'Email address\n',
                                                    hintStyle:
                                                        const TextStyle(fontWeight: FontWeight.w600, ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(10))),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
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
                                              ],
                                            ),
                                          ), 
                                          // 08129825492
                                          Container(
                                            margin: const EdgeInsets.symmetric(vertical: 1),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                  
                                          //       Container(
                                          //   margin: const EdgeInsets.only(bottom: 10),
                                          //   child: const Text(
                                          //     'Phone number',
                                          //     style: TextStyle(
                                          //         fontWeight: FontWeight.w600, fontSize: 15),
                                          //   ),
                                          // ),
                                                TextFormField(
                                                  maxLength: 11,
                                                  cursorColor: Colors.grey,
                                                  minLines: null,
                                                  maxLines: null,
                                                  
                                                  keyboardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  decoration: const InputDecoration(
                                                    fillColor: Color.fromARGB(30, 255, 255, 255),
                                                    filled: true,
                                                    counter: SizedBox(),
                                                    hintMaxLines: 2,
                                                    helperMaxLines: 2,
                                                    errorMaxLines: 2,
                                                    focusedBorder: OutlineInputBorder(
                                                      
                                                        borderSide: BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(10))),
                                                    hintText: 'Phone number\n',
                                                    hintStyle:
                                                    const TextStyle(fontWeight: FontWeight.w600),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(10))),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                  ),
                                                  onChanged: (text) {
                                                    phoneNumber = text.trim();
                                                  },
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty || value.trim().length < 11) {
                                                      return 'Enter a valid Phone number';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(height: 10,),
                                          Container(
                                            // margin: const EdgeInsets.symmetric(vertical: 1),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                  
                                                Container(
                                            margin: const EdgeInsets.only(bottom: 10),
                                            child: const Text(
                                              'Enter your NIN or BVN',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white),
                                            ),
                                          ),
                                                TextFormField(
                                                  maxLength: 11,
                                                  cursorColor: Colors.grey,
                                                    keyboardType: TextInputType.number,
                                                    maxLines: null,
                                                    minLines: null,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  decoration: const InputDecoration(
                                                    fillColor: Color.fromARGB(30, 255, 255, 255),
                                                    filled: true,
                                                    hintMaxLines: 2,
                                                    helperMaxLines: 2,
                                                    errorMaxLines: 2,
                                                    counter: SizedBox(),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(10))),
                                                    hintText: 'XXXXXXXXXXX\n',
                                                    hintStyle:
                                                    const TextStyle(fontWeight: FontWeight.w600),
                                                    // helperText: 'Leave empty to continue without NIN or BVN',
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(10))),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                  ),
                                                  onChanged: (text) {
                                                    bvn = text.trim();
                                                  },
                                                  validator: (value) {
                                                    if ( value == null || value.isEmpty && value.trim().length < 11) {
                                                      return 'This field is required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          const SizedBox(height:20),
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              child: RoundedLoadingButton(
                                                  borderRadius: 10,
                                                  color: Theme.of(context).primaryColor,
                                                  elevation: 6,
                                                  controller: _loginButtonController,
                                                  onPressed: () async {
                                                    // int i = 0;

                                                    // if (i==0){
                                                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(email: email, payload: {'firstname':" .", "lastname":" .", "middle_name":" ", "phone_number":"", "birthdate":"2001/11/24"}, phone: phoneNumber.startsWith('234') ? phoneNumber : '234'+int.parse("234").toString(),)));
                                                    //   _loginButtonController.reset();

                                                    //     return;
                                                    // }
                                                    // try{
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    if (_formKey.currentState!.validate()) {
                                                    
                                                      Map a = await sendOTP(
                                                        email,
                                                        bvn,
                                                        bvn == '' ? 'verify email' : 'verify bvn_nin_before_signup',
                                                      phoneNumber.startsWith('234') ? phoneNumber : '234'+int.parse(phoneNumber).toString()
                                                      );
                                                    //   print(a);
                                                      if (a.containsKey('Status') || a.containsKey('response')) {
                                                        if (a['Status'] == 'successfull' || a['Status'] == 'successful' || a['Response Code'] == 404 || a['Response Code'] == 422 || a['Response Code'] == 406 || (a.containsKey('response') && a['response']['Status'] == 'successfull')) {
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
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(email: email, payload: bvn == '' ? {} : a['Payload']??a['response']['Payload'], phone: phoneNumber.startsWith('234') ? phoneNumber : '234'+int.parse(phoneNumber).toString(),)));
                                                                
                                                                            // Navigator.of(context)
                                                                            //     .pop();
                                                                            // Navigator.of(context)
                                                                            //     .pop();
                                                                          },
                                                                        )
                                                                      ],
                                                                      title: Text(
                                                                          "OTP sent to $email"),
                                                                      content: Text(toTitleCase(a['Message']??a['response']['Message']))),
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
                                                                    content: Text(toTitleCase(a['Message']??toTitleCase(a['response']['Message']??''))));
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
                                                                    content: Text(toTitleCase(a['Message']??'No Internet access')));
                                                              });
                                                          // }
                                                    
                                                        }
                                                    } else {
                                                      _loginButtonController.reset();
                                                    }
                                                  },
                                                  child: const Text('Send OTP'))),
                                           Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Already have an Account?',
                                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.7)),
                                                  
                                                  ),
                                                TextButton(
                                                  onPressed: () {
                                                    Get.close(1);
                                                    Get.to(()=>UserLogin());
                                                  }, child: Text('Login',
                                                  style: TextStyle(color: Color.fromARGB(255, 222, 220, 225), fontWeight: FontWeight.w600),
                                                  )
                                                  ),
                                                ],
                                              ),
                                          // const SizedBox(height:20),
                                          //         Center(
                                          //           child: Row(
                                          //             mainAxisAlignment: MainAxisAlignment.center,
                                          //             children: const [
                                          //               Icon(Icons.shield, color: Colors.grey, size:15),
                                          //               SizedBox(width: 5),
                                          //               Text('Braket is CBN KYC Compliant', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                          //             ],
                                          //           ),
                                          //         ),
                                        ],
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
            ),
          ],
        ),
      ),
    );
}

}
// Future<dynamic> askBVN(
//   context,
//   // username,
//   // password,
//   // email,
//   // phone,
// ) {
//   final _formKey = GlobalKey<FormState>();
//   final RoundedLoadingButtonController _loginButtonController =
//       RoundedLoadingButtonController();
//   String pin = '';
//   String bvn = '';
//   String email = '';
//   String addr = '';
//   final Brakey brakey = Get.find();
//   return showModalBottomSheet(
//       context: context,
//       isDismissible: false,
//       // enableDrag: false,
//       backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
//       isScrollControlled: true,
//       builder: (context) {
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: Form(
//             key: _formKey,
//             child: Container(
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(20))),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//               child: ListView(
//                 children: [
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Sign up',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.symmetric(vertical: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         child: const Text(
//                           'Email address',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 15),
//                         ),
//                       ),
//                             TextFormField(
//                               autofillHints: const [AutofillHints.email],
//                               cursorColor: Colors.grey,
//                               decoration: const InputDecoration(
//                                 fillColor: Color.fromARGB(24, 158, 158, 158),
//                                 filled: true,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10))),
//                                 hintText: 'Eg, yourname@gmail.com',
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10))),
//                                 contentPadding:
//                                     EdgeInsets.symmetric(horizontal: 10),
//                               ),
//                               onChanged: (text) {
//                                 email = text.trim();
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Enter your email address';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.symmetric(vertical: 1),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [

//                             Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         child: const Text(
//                           'Enter your NIN or BVN (optional)',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 15),
//                         ),
//                       ),
//                             TextFormField(
//                               maxLength: 11,
//                               cursorColor: Colors.grey,
//                                 keyboardType: TextInputType.number,
//                                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                               decoration: const InputDecoration(
//                                 fillColor: Color.fromARGB(24, 158, 158, 158),
//                                 filled: true,
//                                 hintMaxLines: 2,
//                                 helperMaxLines: 2,
//                                 errorMaxLines: 2,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10))),
//                                 hintText: 'XXXXXXXXXXX',
//                                 helperText: 'Leave empty to signup without NIN or BVN',
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10))),
//                                 contentPadding:
//                                     EdgeInsets.symmetric(horizontal: 10),
//                               ),
//                               onChanged: (text) {
//                                 bvn = text.trim();
//                               },
//                               validator: (value) {
//                                 if ( value != null && value.isNotEmpty && value.trim().length < 11) {
//                                   return 'Leave empty to signup without NIN or BVN';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height:10),
//                       Container(
//                           margin: const EdgeInsets.all(10),
//                           child: RoundedLoadingButton(
//                               borderRadius: 10,
//                               color: Theme.of(context).primaryColor,
//                               elevation: 0,
//                               controller: _loginButtonController,
//                               onPressed: () async {
//                                 // try{
//                                 FocusManager.instance.primaryFocus?.unfocus();
//                                 if (_formKey.currentState!.validate()) {
        
//                                   Map a = await sendOTP(
//                                     email,
//                                     bvn,
//                                     bvn == '' ? 'verify email' : 'verify bvn_nin_before_signup',
//                                   ''
//                                   );
//                                 //   print(a);
//                                   if (a.containsKey('Status')) {
//                                     if (a['Status'] == 'successfull' || a['Status'] == 'successful' || a['Response Code'] == 202 || a['Response Code'] == 422 || a['Response Code'] == 406 ) {
//                                       _loginButtonController.success();
//                                       showDialog(
//                                           context: context,
//                                           barrierDismissible: false,
//                                           builder: (context) {
//                                             return WillPopScope(
//                                               onWillPop: (() async => false),
//                                               child: AlertDialog(
//                                                   actions: [
//                                                     TextButton(
//                                                       child: const Text('Verify OTP'),
//                                                       onPressed: () {
//                                                         Navigator.of(context)
//                                                             .pop();
//                                                         _loginButtonController
//                                                             .reset();
//                                                         Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(email: email, payload: bvn == '' ? {} : a['Payload'])));
                                            
//                                                         // Navigator.of(context)
//                                                         //     .pop();
//                                                         // Navigator.of(context)
//                                                         //     .pop();
//                                                       },
//                                                     )
//                                                   ],
//                                                   title: Text(
//                                                       "OTP sent to $email"),
//                                                   content: Text(toTitleCase(a['Message']))),
//                                             );
//                                           });
//                                     } else {
//                                       showDialog(
//                                           context: context,
//                                           barrierDismissible: false,
//                                           builder: (context) {
//                                             return AlertDialog(
//                                                 actions: [
//                                                   TextButton(
//                                                     child: const Text('Okay'),
//                                                     onPressed: () {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                           _loginButtonController.reset();
//                                                     },
//                                                   )
//                                                 ],
//                                                 title: const Text(
//                                                     "OTP request failed"),
//                                                 content: Text(toTitleCase(a['Message'])));
//                                           });
//                                     }
//                                   } else {
//                                       showDialog(
//                                           context: context,
//                                           barrierDismissible: false,
//                                           builder: (context) {
//                                             return AlertDialog(
//                                                 actions: [
//                                                   TextButton(
//                                                     child: const Text('Okay'),
//                                                     onPressed: () {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                           _loginButtonController.reset();
//                                                       // Navigator.of(context)
//                                                       //     .pop();
//                                                       // Navigator.of(context)
//                                                       //     .pop();
//                                                     },
//                                                   )
//                                                 ],
//                                                 title: const Text(
//                                                     "Failed"),
//                                                 content: Text(toTitleCase(a['Message']??'No Internet access')));
//                                           });
//                                       // }
        
//                                     }
//                                 } else {
//                                   _loginButtonController.reset();
//                                 }
//                               },
//                               child: const Text('Send OTP'))),
//                               Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: const [
//                                     Icon(Icons.shield, color: Colors.blueGrey, size:15),
//                                     SizedBox(width: 5),
//                                     Text('Braket is CBN KYC Compliant', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
//                                   ],
//                                 ),
//                               )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
       
//         );
//       });
// }
