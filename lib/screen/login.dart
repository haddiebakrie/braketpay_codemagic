import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/screen/bvn.dart';
import 'package:braketpay/screen/manager.dart';
import 'package:braketpay/screen/signup.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:braketpay/brakey.dart';
import 'package:iconly/iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key, this.showOnboarding=false}) : super(key: key);

  final bool showOnboarding;

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
  bool passwordVisible = false;
  final Icon _passwordIcon = const Icon(Icons.visibility_off);
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   askLogin();
    // });
  }

  Future<dynamic> askLogin() {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        // enableDrag: false,
        useRootNavigator: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter changeState) {
              bool _passwordVisibility = false;
              return Form(
                key: _formKey,
                child: Container(
                  padding: MediaQuery.of(context).viewInsets,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
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
                              autofillHints: [AutofillHints.username],
                              cursorColor: Colors.black,
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
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              obscureText: true,
                              cursorColor: Colors.black,
                              autofillHints: [AutofillHints.password],
                    
                              // controller: _userPasswordController,
                              decoration: const InputDecoration(
                              //   icon: IconButton(onPressed: () {
                              //     print(passwordVisible);
                              //   //  setState(() {
                              //      passwordVisible = !passwordVisible;
                              //   //  });
                              //     print(passwordVisible);
                              //   },
                              //    icon: const Icon(Icons.visibility_off)
                                // ),
                                hintText: 'Password',
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              obscureText: true,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Transaction PIN',
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                pin = text;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your Transaction PIN';
                                }
                                return null;
                              },
                            ),
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
                                      _loginButtonController.success();
                                      brakey.setUser(Rxn(a), pin);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Manager(user: a, pin: pin)));
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
                                                content: Text(e.toString()));
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _errorMessage = _errorMessage;
    final _controller = PageController(
      initialPage: widget.showOnboarding ? 5 : 0
    );
      print(widget.showOnboarding);
    return Scaffold(
      
      extendBody: false,
      // backgroundColor: _controller.page!.toInt() == 0 ? Color.fromARGB(255, 201, 233, 249) : _controller.page!.toInt() == 1 ? Color.fromARGB(255, 255, 187, 187) : Color.fromARGB(255, 255, 255, 255),
      bottomSheet: !isLastPage && !widget.showOnboarding
          ? Container(
              padding: const EdgeInsets.all(20),
              // color: Color.fromARGB(255, 201, 233, 249),
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
                                  askBVN(context);
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
            isLastPage = index == 5;
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
                                  children: [
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
                      Image.asset('assets/sammy_service.png'),
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
                                  children: [
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
                                  style: TextStyle(
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
                      Image.asset('assets/sammy_savings.png'),
                      Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'EARN',
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                  children: [
                                    TextSpan(
                                      text:
                                          '  while you save.',
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
                              'Earn up to 20% of your savings with BraketSavings. All you have to do is JUST SAVE .',
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
                      Image.asset('assets/sammy_transfer.png'),
                      Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'Make',
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' SEAMLESS ',
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor),
                                    ),
                                    TextSpan(
                                      text:
                                          'cash tranfers.',
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
                              'Send money to your friends and family without delay.',
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
                          SizedBox(height: 20),
                          Text('Sign up now to become a star in our UNIVERSE',
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
        actions: [!isLastPage ? TextButton(child: const Text('Skip'), onPressed: () {
          _controller.animateToPage(5, duration: const Duration(seconds:1), curve: Curves.ease);
        },) : Container()],
      ),
    );
  }
}
