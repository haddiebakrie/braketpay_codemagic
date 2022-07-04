import 'package:braketpay/screen/bvn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/userinfo.dart';
import '../brakey.dart';
import '../classes/user.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';
import 'changepassword.dart';
import 'login.dart';
import 'manager.dart';

class UserLogin extends StatefulWidget {
  UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();

}

class _UserLoginState extends State<UserLogin> {
  final Brakey brakey = Get.find();

  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  // String _errorMessage = '';
  String username = '';
  String password = '';
  String pin = '';
  late String _errorMessage = '';
  bool passwordVisible = true;
  final Icon _passwordIcon = const Icon(Icons.visibility_off);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              // height: 400,
              // width: double.infinity,
                
              
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                Image.asset('assets/braket-bg_grad-01.png', width: double.infinity, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Hello', style: TextStyle(fontSize: 40, fontFamily: 'Impact', color: Colors.white),),
                  SizedBox(height: 10,),
                  Text('Welcome back to safety from the online payment world', style: TextStyle(fontFamily: 'Impact', color: Colors.white, fontSize: 19),),
                    ],
                  ),
                ),
                
                ])),
          ),
          Container(
                    decoration: ContainerBackgroundDecoration(),
                          // padding: MediaQuery.of(context).viewInsets,
                    child: Form(
                      key: _formKey,
                child: Container(
                  // padding: MediaQuery.of(context).viewInsets,
                  decoration: ContainerBackgroundDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AutofillGroup(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Enter your Details to Login',
                            style:
                                TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              autofillHints: const [AutofillHints.username],
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Username',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                username = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your username';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              obscureText: passwordVisible,
                              cursorColor: Colors.grey,
                              autofillHints: const [AutofillHints.password],
                    
                              // controller: _userPasswordController,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(onPressed: () {
                                  print(passwordVisible);
                                 setState(() {
                                   passwordVisible = !passwordVisible;
                                 });
                                  // print(passwordVisible);
                                },
                                 icon: passwordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                                ),
                                hintText: 'Password',
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
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                password = text;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your Password';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(child: Text('Forgot password?') 
                                    ,
                                    onPressed: () {
                                      forgotPasswordPrompt();
                                    },
                                    ),
                                  ],
                                ),
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
                                    // print('$username, $pin, $password');
                                    try {
                                      User a =
                                          await loginUser(username, password, pin);
                                          print(a.payload?.pin??"");
                                      _loginButtonController.success();
                                      brakey.setUser(Rxn(a), pin);
                                      Get.offUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Manager(user: a, pin: ''),
                                            maintainState: true),
                                        (route) => false);
                                      promptSaveBiometric();
                                      
                                      // Navigator.pushAndRemoveUntil(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             Manager(user: a, pin: "")), Manager(user:a, pin:''));
                                    } catch (e) {
                                      print(e);
                                      _loginButtonController.reset();
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Okay'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                                title: const Text("Can't Login!"),
                                                content: Text(toTitleCase(e.toString())));
                                          });
                                    }
                                  } else {
                                    _loginButtonController.reset();

                                  }
                                },
                                child: const Text('Login')),
                          ),
                          Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('New User?', style: TextStyle(color: adaptiveColor)),
                                  TextButton(onPressed: () {
                                      Get.close(1);
                                      Get.to(()=>AskBVN());
                                    }, child: Text('Sign up'),)
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
             
                    ),),
        ],
      )
    );
  }
}


  promptSaveBiometric() {
  final Brakey brakey = Get.find();

    return Get.bottomSheet(
  
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
        Icon(Icons.fingerprint_rounded, color: Colors.green, size: 40),
        SizedBox(height: 10,),
          const Text(
          'Enable Fingerprint Login',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 10,),
        const Text(
          'This can be changed in your profile setting',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),
        ),
        const SizedBox(height:15),
        const SizedBox(height:10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();

            }, child: const Text('Skip')),
        TextButton(onPressed: () {
          brakey.toggleBiometric(true);
          Get.close(1);

        }, child: const Text('Enable')),
          ],
        ),
                  ],
                )

            );
}));
  
  }
