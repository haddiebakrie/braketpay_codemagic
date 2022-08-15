import 'package:braketpay/screen/bvn.dart';
import 'package:braketpay/screen/changepassword.dart';
import 'package:braketpay/screen/forgot_password.dart';
import 'package:braketpay/screen/userlogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
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
import 'new_device_auth.dart';

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
    // Get.to(() => NewDeviceAuth(email: brakey.user.value!.payload!.username??'', password: password));

    checkForUpdate();
    return Scaffold(
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
                  height: 350,
                  width: double.infinity,
                    
                  
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hello, \n${brakey.user.value!.payload!.fullname!.split(' ')[0]}', style: TextStyle(fontSize: 40, fontFamily: 'Impact', color: Colors.white, fontWeight: FontWeight.w600)),
                    SizedBox(height: 10,),
                    Text('Welcome back to safety from the online payment world', style: TextStyle(fontFamily: 'Impact', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                      ],
                    ),
                  )),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'userLoginContainer',
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
                                // crossAxisAlignment: CrossAxisAlignment.start,
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
                                  // SizedBox(height:10),
                                  Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        width: 60,
                                        height: 5,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                  SizedBox(
                                  width: double.infinity,
                                    child: Text(
                                      'Enter your Password to Login',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height:20),
                                  // Text(
                                  //   '@${brakey.user.value!.payload!.username}',
                                  //   style: const TextStyle(
                                  //       color: Colors.grey,
                                  //       fontSize: 15,),
                                  // ),
                                  
                                  Container(
                                    // height: 50,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      obscureText: passwordVisible,
                                      cursorColor: Colors.grey,
                                      autofillHints: const [AutofillHints.password],
                            
                                      // controller: _userPasswordController,
                                          obscuringCharacter: '●',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17),

                                      decoration: InputDecoration(
                                        suffixIcon: password == '' ? Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    // color: Colors.teal,
                                                    // gradient: tealGradient,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: TextButton(
                                                    child: Text(
                                                      'Forgot?',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      Get.to(() => ForgotPassword());
                                                    })) : IconButton(onPressed: () {
                                              print(passwordVisible);
                                             setState(() {
                                               passwordVisible = !passwordVisible;
                                             });
                                              // print(passwordVisible);
                                            },
                                             icon: passwordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                                            ),
                                            
                                            hintText: 'Password\n',
                                        fillColor: Color.fromARGB(
                                                30, 255, 255, 255),
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
                                        setState(() {
                                        password = text;
                                          
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter your Password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height:20),
                                  // Row(
                                  //   // mainAxisSize: MainAxisSize.max,
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //     TextButton(child: Text('Forgot password?') 
                                  //     ,
                                  //     onPressed: () {
                                  //       forgotPasswordPrompt();
                                  //     },
                                  //     ),
                                  //   ],
                                  // ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: RoundedLoadingButton(
                                        borderRadius: 10,
                                        color: Theme.of(context).primaryColor,
                                        elevation: 6,
                                        controller: _loginButtonController,
                                        onPressed: () async {
                                          // return;
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          if (_formKey.currentState!.validate()) {
                                            print('$username, $pin, $password');
                                            try {
                                              User a =
                                                  await loginUser(brakey.user.value!.payload!.email??'', password, pin);
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
                                                                        } catch (a) {
                                                  dynamic e;
                                                  if (a is Map) {
                                                    Map e = a;
                                                  

                                                  if (e['Message']=='new device detected') {
                                                    Map a = await getLoginOtp(username, password);
                                                    print(a);
                                                    _loginButtonController.reset();
                                                    print(e['user_email']);
                                                    Get.to(() => NewDeviceAuth(email: e['user_email']??'', password: password));
                                                    return;
                                                } else {
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
                                                                toTitleCase(e['Message'].toString())));
                                                      });
                                                }}
                                                else {
                                                    dynamic e = a;
                                              
                                                  // print(e);
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
                                                                toTitleCase(e.toString())));
                                                      });
                                                  };
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
                                            'Not @${brakey.user.value?.payload?.username}?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white54),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Get.close(1);
                                                Get.to(() => UserLogin());
                                              },
                                              child: Text(
                                                'Login with Username',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        ],
                                      ),
                                  SizedBox(height:15),
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
                                            valueColor: Colors.white,
                                            successColor: Colors.white,
                                            width: 50,
                                            child: Icon(Icons.fingerprint_rounded, color: Colors.tealAccent, size: 50, ),
                                            
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
                      ),
                    ),
                  ),
                ),
            )],
            ),
          ],
        ),
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
