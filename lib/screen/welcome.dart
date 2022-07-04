import 'package:braketpay/screen/bvn.dart';
import 'package:braketpay/screen/changepassword.dart';
import 'package:braketpay/screen/userlogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';
import 'package:local_auth_android/types/auth_messages_android.dart';
import '../api_callers/userinfo.dart';
import '../brakey.dart';
import '../classes/user.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';
import 'login.dart';
import 'manager.dart';

class WelcomeBack extends StatefulWidget {
  WelcomeBack({Key? key}) : super(key: key);

  @override
  State<WelcomeBack> createState() => _WelcomeBackState();

}

class _WelcomeBackState extends State<WelcomeBack> {
    final Brakey brakey = Get.find();

  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
    final RoundedLoadingButtonController _bioButtonController =
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
    print(brakey.useBiometric.value);
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
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Hello, \n${brakey.user.value!.payload!.fullname!.split(' ')[0]}', style: TextStyle(fontSize: 40, fontFamily: 'Impact', color: Colors.white),),
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
                        decoration: ContainerBackgroundDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [  
                              // SizedBox(
                              //   width: double.infinity,
                              //   child: Text(
                              //       '👋',
                              //       textAlign: TextAlign.center,
                              //       style:
                              //           TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                              //     ),
                              // ),
                                SizedBox(height:10),
                                SizedBox(
                                width: double.infinity,
                                  child: Text(
                                    'Login',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height:30),
                                Text(
                                  '@${brakey.user.value!.payload!.username}',
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,),
                                ),
                                
                                Container(
                                  // height: 50,
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
                                  // mainAxisSize: MainAxisSize.max,
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
                                                await loginUser(brakey.user.value!.payload!.username??'', password, pin);
                                                print(a.payload?.pin??"");
                                            _loginButtonController.success();
                                            brakey.setUser(Rxn(a), pin);
                                            Get.offUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Manager(user: a, pin: ''),
                                                  maintainState: true),
                                              (route) => false);
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
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                          _loginButtonController.reset();
                                        }
                                      },
                                      child: const Text('Login')),
                                      
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(onPressed: () {
                                      Get.close(1);
                                      Get.to(UserLogin());
                                    }, 
                                    style: ButtonStyle(alignment: Alignment.center),
                                    child: Text('Not @${brakey.user.value!.payload!.username}? Login with Username')),
                                  ],
                                ),
                                
                                Center(
                                  child: Obx(() =>
                                  Visibility(
                                      visible: brakey.useBiometric.value,
                                      child: SizedBox(
                                        width: 50,
                                        child: RoundedLoadingButton(
                                          onPressed: () async {
                                            // _bioButtonController.stop();
                                            authenticateWithFingerPrint().then((isAuth) async {
                                    
                                            if (isAuth) {
                                              String password = brakey.user.value!.payload!.password??"";
                                              // _bioButtonController.start();
                                              try {
                                                        User a =
                                                            await loginUser(brakey.user.value!.payload!.username??'', password, pin);
                                                            print(a.payload?.pin??"");
                                                        _loginButtonController.success();
                                                        brakey.setUser(Rxn(a), pin);
                                                        Get.offUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Manager(user: a, pin: ''),
                                                              maintainState: true),
                                                          (route) => false);
                                                        // Navigator.pushAndRemoveUntil(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) =>
                                                        //             Manager(user: a, pin: "")), Manager(user:a, pin:''));
                                                      } catch (e) {
                                                        print(e);
                                                        _bioButtonController.reset();
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
                                                      setState(() {
                                                        passwordVisible = !passwordVisible;
                                                      });
                                                      _bioButtonController.reset();
                                                    }
                                    
                                            });
                                          
                                        
                                          },
                                          controller: _bioButtonController,
                                          color: Colors.transparent,
                                          elevation: 0,
                                          valueColor: Colors.green,
                                          successColor: Colors.green,
                                          width: 50,
                                          child: Icon(Icons.fingerprint_rounded, color: Colors.green, size: 40, ),
                                          
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Text('New User?', style: TextStyle(color: NeutralButton)),
                                //   TextButton(onPressed: () {
                                //       Get.close(1);
                                //       Get.to(()=>AskBVN());
                                //     }, child: Text('Sign up'),)
                                //   ],
                                // ),
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


Future<bool> canCheckBio() async {
  LocalAuthentication auth = LocalAuthentication();

  bool _canCheckBio = false;
  String authorised = 'Not authorised';

  try {

    _canCheckBio = await auth.canCheckBiometrics;

  } on PlatformException catch (e) {
    print(e);
  }

  return _canCheckBio;  
}

Future<List> getAvailableBio() async {
  LocalAuthentication auth = LocalAuthentication();

  List<BiometricType> _availableBio = [];

  try {

    _availableBio = await auth.getAvailableBiometrics();

  } on PlatformException catch (e) {
    print(e);
  }

  return _availableBio;  

}

Future<bool> authenticateWithFingerPrint() async {

  bool _canCheckBio = await canCheckBio();

  if (!_canCheckBio) {
    print('Cant check bio');
    return false;

  }
  
  getAvailableBio().then((value) {

    if (!value.contains(BiometricType.fingerprint)) {
      return;
    }
  } 
  );
 
  LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;

  try {
    authenticated = await auth.authenticate(localizedReason: " ",
    authMessages: [
      AndroidAuthMessages(
        signInTitle: 'Login to Braket',
      ),
    ],
    options: AuthenticationOptions(useErrorDialogs: true, sensitiveTransaction: true, biometricOnly: true)
    );
  } on PlatformException catch(e) {
    print(e);
  }

  return authenticated;


}
