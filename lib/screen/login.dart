import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/screen/bvn.dart';
import 'package:braketpay/screen/manager.dart';
import 'package:braketpay/screen/signup.dart';
import 'package:braketpay/screen/userlogin.dart';
import 'package:braketpay/screen/welcome.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:braketpay/brakey.dart';
import 'package:iconly/iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key, this.showOnboarding=false, this.hasUser=false}) : super(key: key);

  final bool showOnboarding;
  final bool? hasUser;

  @override
  State<Login> createState() => _LoginState(
  );
}

class _LoginState extends State<Login> {
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
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
          if (widget.hasUser==true) {
      Get.to(() => WelcomeBack());
    }
  }



  askLogin() {
    Get.to(UserLogin());

    // bool _passwordVisibility = true;
    // return showModalBottomSheet(
    //     context: context,
    //     isDismissible: false,
    //     // enableDrag: false,
    //     useRootNavigator: true,
    //     backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
    //     isScrollControlled: true,
    //     builder: (context) {
    //       return StatefulBuilder(
    //         builder: (context, StateSetter changeState) {
    //           return Form(
    //             key: _formKey,
    //             child: Container(
    //               padding: MediaQuery.of(context).viewInsets,
    //               decoration: ContainerBackgroundDecoration(),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(20.0),
    //                 child: AutofillGroup(
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       const Text(
    //                         'Enter your Details to Login',
    //                         style:
    //                             TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    //                       ),
    //                       Text(
    //                         _errorMessage,
    //                         style: const TextStyle(
    //                             color: Colors.red,
    //                             fontSize: 15,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       Container(
    //                         margin: const EdgeInsets.symmetric(vertical: 15),
    //                         child: TextFormField(
    //                           autofillHints: const [AutofillHints.username],
    //                           cursorColor: Colors.grey,
    //                           decoration: const InputDecoration(
    //                             fillColor: Color.fromARGB(24, 158, 158, 158),
    //                             filled: true,
    //                             focusedBorder: OutlineInputBorder(
    //                                 borderSide: BorderSide.none,
    //                                 borderRadius:
    //                                     BorderRadius.all(Radius.circular(10))),
    //                             hintText: 'Username',
    //                             border: OutlineInputBorder(
    //                                 borderSide: BorderSide.none,
    //                                 borderRadius:
    //                                     BorderRadius.all(Radius.circular(10))),
    //                             contentPadding: EdgeInsets.symmetric(horizontal: 10),
    //                           ),
    //                           onChanged: (text) {
    //                             username = text.trim();
    //                           },
    //                           validator: (value) {
    //                             if (value == null || value.isEmpty) {
    //                               return 'Enter your username';
    //                             }
    //                             return null;
    //                           },
    //                         ),
    //                       ),
    //                       Container(
    //                         height: 50,
    //                         margin: const EdgeInsets.symmetric(vertical: 10),
    //                         child: TextFormField(
    //                           obscureText: passwordVisible,
    //                           cursorColor: Colors.grey,
    //                           autofillHints: const [AutofillHints.password],
                    
    //                           // controller: _userPasswordController,
    //                           decoration: InputDecoration(
    //                             suffixIcon: IconButton(onPressed: () {
    //                               print(passwordVisible);
    //                              changeState(() {
    //                                passwordVisible = !passwordVisible;
    //                              });
    //                               // print(passwordVisible);
    //                             },
    //                              icon: passwordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
    //                             ),
    //                             hintText: 'Password',
    //                             fillColor: const Color.fromARGB(24, 158, 158, 158),
    //                             filled: true,
    //                             focusedBorder: const OutlineInputBorder(
    //                                 borderSide: BorderSide.none,
    //                                 borderRadius:
    //                                     BorderRadius.all(Radius.circular(10))),
    //                             border: const OutlineInputBorder(
    //                                 borderSide: BorderSide.none,
    //                                 borderRadius:
    //                                     BorderRadius.all(Radius.circular(10))),
    //                             contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    //                           ),
    //                           onChanged: (text) {
    //                             password = text;
    //                           },
    //                           validator: (value) {
    //                             if (value == null || value.isEmpty) {
    //                               return 'Enter your Password';
    //                             }
    //                             return null;
    //                           },
    //                         ),
    //                       ),
    //                       Container(
    //                         margin: const EdgeInsets.all(10),
    //                         child: RoundedLoadingButton(
    //                             borderRadius: 10,
    //                             color: Theme.of(context).primaryColor,
    //                             elevation: 0,
    //                             controller: _loginButtonController,
    //                             onPressed: () async {
    //                               FocusManager.instance.primaryFocus?.unfocus();
    //                               if (_formKey.currentState!.validate()) {
    //                                 // print('$username, $pin, $password');
    //                                 try {
    //                                   User a =
    //                                       await loginUser(username, password, pin);
    //                                       print(a.payload?.pin??"");
    //                                   _loginButtonController.success();
    //                                   brakey.setUser(Rxn(a), pin);
    //                                   Get.offUntil(
    //                                     MaterialPageRoute(
    //                                         builder: (context) =>
    //                                             Manager(user: a, pin: ''),
    //                                         maintainState: true),
    //                                     (route) => false);
    //                                   // Navigator.pushAndRemoveUntil(
    //                                   //     context,
    //                                   //     MaterialPageRoute(
    //                                   //         builder: (context) =>
    //                                   //             Manager(user: a, pin: "")), Manager(user:a, pin:''));
    //                                 } catch (e) {
    //                                   print(e);
    //                                   _loginButtonController.reset();
    //                                   showDialog(
    //                                       context: context,
    //                                       barrierDismissible: false,
    //                                       builder: (context) {
    //                                         return AlertDialog(
    //                                             actions: [
    //                                               TextButton(
    //                                                 child: const Text('Okay'),
    //                                                 onPressed: () {
    //                                                   Navigator.of(context).pop();
    //                                                 },
    //                                               )
    //                                             ],
    //                                             title: const Text("Can't Login!"),
    //                                             content: Text(toTitleCase(e.toString())));
    //                                       });
    //                                 }
    //                               } else {
    //                                 setState(() {
    //                                   passwordVisible = !passwordVisible;
    //                                 });
    //                                 _loginButtonController.reset();
    //                               }
    //                             },
    //                             child: const Text('Login')),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
             
    //           );
    //         }
    //       );
    //     });
  }

  @override
  Widget build(BuildContext context) {
    _errorMessage = _errorMessage;
    final _controller = PageController(
      initialPage: widget.showOnboarding ? 4 : 0
    );
      // print(widget.showOnboarding);
    return Scaffold(
      backgroundColor: Colors.white,
      
      extendBody: false,
      // backgroundColor: _controller.page!.toInt() == 0 ? Color.fromARGB(255, 201, 233, 249) : _controller.page!.toInt() == 1 ? Color.fromARGB(255, 255, 187, 187) : Color.fromARGB(255, 255, 255, 255),
      bottomSheet: !isLastPage && !widget.showOnboarding
          ? Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // RoundButton(text: 'Prev', onTap: () {_controller.previousPage(duration: Duration(microseconds: 10000), curve: Curves.ease);} ,color1: Colors.transparent, color2: Colors.transparent, textColor:Colors.black ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 5,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.black,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                  RoundButton(
                      text: 'Next',
                      onTap: () {
                        _controller.animateToPage(_controller.page!.toInt() + 1,
                            duration: const Duration(microseconds: 10000),
                            curve: Curves.ease);
                      },
                      color1: Colors.black,
                      color2: Colors.black),
                ],
              ))
          : Container(
              height: 90,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RoundButton(
                                text: 'Login',
                                color1: Colors.black,
                                color2: Colors.black,
                                textColor: Colors.white,
                                radius: 10,
                                onTap: () {
                                  askLogin();
                                }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RoundButton(
                                text: 'Sign up',
                                color1: Theme.of(context).primaryColor,
                                color2: Theme.of(context).primaryColor,
                                radius: 10.0,
                                textColor: Colors.white,
                                onTap: () {
                                  Get.to(() => AskBVN());
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            isLastPage = index == 4;
          });
        },
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/sammy_contract.png'),
                      Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'TRUST',
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                  children: const [
                                    TextSpan(
                                      text:
                                          ' is not enough, BraketPay smart contract is all you need!',
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )
                                  ]),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          const Text(
                              'Do not pay for anything online without BraketPay The most secured payment platform in the world.',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      const SizedBox(height: 50)
                    ],
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                children: [
                  // PageIndicator
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/sammy-delivers.png'),
                      Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'SECURE',
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                  children: const [
                                    TextSpan(
                                      text:
                                          ' your order.',
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )
                                  ]),
                              textAlign: TextAlign.center),
                          const SizedBox(height:30),
                          const Text(
                              'Use BraketPay to pay for products you purchase online to avoid \n"What I ordered VS What I got" situation.',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                children: [
                  // PageIndicator
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/payment.png'),
                      Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'Receive your payment without ',
                                  style: const TextStyle(
                                      height: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' STORY.',
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor),
                                    )
                                  ]),
                              textAlign: TextAlign.center),
                          
                          const SizedBox(height: 20),
                          const Text(
                              'Sell online with BraketPay to avoid \nCANCELLED ORDER, FAKE ALERT, TRANSFER REVERSAL\n and also prevent buyers from scamming YOU.',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // SingleChildScrollView(
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //     child: Stack(
          //       children: [
          //         // PageIndicator
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             const SizedBox(height: 10),
          //             Image.asset('assets/sammy_savings.png'),
          //             Column(
          //               children: [
          //                 RichText(
          //                     text: TextSpan(
          //                         text: 'EARN',
          //                         style: TextStyle(
          //                             height: 1.5,
          //                             fontSize: 22,
          //                             fontWeight: FontWeight.bold,
          //                             color: Theme.of(context).primaryColor),
          //                         children: const [
          //                           TextSpan(
          //                             text:
          //                                 '  while you save.',
          //                             style: TextStyle(
          //                                 height: 1.5,
          //                                 fontSize: 22,
          //                                 fontWeight: FontWeight.bold,
          //                                 color: Colors.black),
          //                           )
          //                         ]),
          //                     textAlign: TextAlign.center),
                          
          //                 const SizedBox(height: 20),
          //                 const Text(
          //                     'Earn up to 20% of your savings with BraketSavings. All you have to do is JUST SAVE .',
          //                     style: TextStyle(fontSize: 16, color: Colors.black),
          //                     textAlign: TextAlign.center),
          //               ],
          //             ),
          //             const SizedBox(height: 20),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                children: [
                  // PageIndicator
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/sammy_transfer.png'),
                      Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'SAVE',
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                  children: [
                                    const TextSpan(
                                      text:
                                          ' and ',
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color:Colors.black),
                                    ),
                                   TextSpan(
                                      text:
                                          'SPEND.',
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor),
                                    )
                                  ]),
                              textAlign: TextAlign.center),
                          
                          const SizedBox(height: 20),
                          const Text(
                              'Enjoy high return of investment when you use BraketSavings and Send money to your friends and family without delay.',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                children: [
                  // PageIndicator
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/sammy_pro.png'),
                      Column(
                        children: [
                          Text('Get Started',
                              style: TextStyle(
                                  height: 1.5,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          const Text('Sign up now to become a star in our UNIVERSE',
                              style: TextStyle(fontSize: 20, color: Colors.black),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [!isLastPage && !widget.showOnboarding ? TextButton(child: const Text('Skip'), onPressed: () {
          _controller.animateToPage(4, duration: const Duration(seconds:1), curve: Curves.ease);
        },) : Container()],
      ),
    );
  }
}
