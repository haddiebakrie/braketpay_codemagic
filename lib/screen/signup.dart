import 'package:braketpay/api_callers/registration.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';
import 'manager.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key, required this.email, required this.payload}) : super(key: key);

  String email;
  Map? payload;

  @override
  State<StatefulWidget> createState()  => _SignupState();
  
}

class _SignupState extends State<SignUp> {
  Brakey brakey = Get.put(Brakey());
  String password = '';
  String pin = '';
  String phoneConfirm = '';
  String otp = '';
  late String fullname = "${widget.payload?['lastname']??''} ${widget.payload?['firstname']??''} ${widget.payload?['middlename']??''}";
  late String dob = "${widget.payload?['birthdate']??''}";
  String helperText = '';
  int index = 0;
  PageController pageController = PageController();
  String username = '';
  bool isAuth = false;
  String phone = '';
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    setState(() {
      // dob = 
      // fullname = ;
      
    });
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        // leading: Container(),
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: IconStepper(
          onStepReached: (e) {
            setState(() {
              
              index = e;
            });
          },
          activeStep: index,
          lineColor: Colors.white,
          lineLength: 70,
          enableNextPreviousButtons: false,
          enableStepTapping: false,
          activeStepColor: Colors.white,
          stepColor:  Colors.grey,
          icons: [
            Icon(Icons.key, color: Theme.of(context).primaryColor),
            Icon(IconlyBold.profile, color: Theme.of(context).primaryColor),
            Icon(Icons.lock, color: Theme.of(context).primaryColor),
          ],
        ),
        centerTitle: true,
        elevation: 0      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: ContainerBackgroundDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (e) {
              setState(() {
                index = e;
              });
            },
                children: [
                  Column(
                    children: [

                   const Text(
                          'Verify OTP',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Visibility(
                          visible: widget.payload!.containsKey('firstname'),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            child: TextFormField(
                                autofillHints: const [AutofillHints.telephoneNumber],
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                fillColor: const Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Phone Confirmation',
                                helperText: 'Enter the phone number sent to ${widget.email}',
                                helperMaxLines: 2,
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                phoneConfirm = text.trim();
                                _loginButtonController.reset();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            autofillHints: const [AutofillHints.oneTimeCode],
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                            decoration: InputDecoration(
                              // suffixIcon: otp.length == 6 ? Container(height: 10, width: 10, padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth:2)) : Container(width:0, height:0),
                              fillColor: const Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'OTP Confirmation',
                              helperText: helperText,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onChanged: (text) async {
                              otp = text.trim();
                              print(widget.payload);
                              // if (otp.length == 6) {
                  
                              // }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
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
                                Map a = !widget.payload!.containsKey('firstname') ? await verifyBVN(widget.email, otp, 'email otp') : await verifyBVN(phoneConfirm, otp, 'bvn_nin otp');
                                        print('ppp$a');
                                    if (a.containsKey('Payload') || a['Status'] == 'success') {
                                        
                                        setState(() {
                                          index = 1;
                                          pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.ease);
                                        });
                                        
                                        _loginButtonController.reset();
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
                                                      Navigator.of(context).pop();
                                                      _loginButtonController
                                                          .reset();
                                
                                                      // Navigator.of(context)
                                                      //     .pop();
                                                      // Navigator.of(context)
                                                      //     .pop();
                                                    },
                                                  )
                                                ],
                                                title: const Text(
                                                    "OTP verification failed"),
                                                content: Text(toTitleCase(a['Message'])));
                                          });
                                      }
                                    
                                  } else {
                                    _loginButtonController.reset();
                                  }
                                },
                                child: const Text('Confirm')))
                    ]
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                  
                              Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Fullname',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),
                              TextFormField(
                                initialValue: fullname.trim() == '' ? null : fullname,
                                cursorColor: Colors.grey,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: "Surname Firstname" ,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (text) {
                                  fullname = text.trim();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter your Fullname';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                  
                              Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Phone number',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),
                              TextFormField(
                                cursorColor: Colors.grey,
                                initialValue: phoneConfirm,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: 'Phone number',
                                  helperMaxLines: 2,
                                  helperText:
                                      'Enter your a Phone number without country code Ex. 09011001100',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (text) {
                                  phone = text.trim();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter your a Phone number without country code Ex. 09011001100';
                                  }
                                  if (value.length < 11 || !value.startsWith('0')) {
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
                                              title:
                                                  const Text("Invalid phone number!"),
                                              content: const Text(
                                                  'Phone number must be in the format 09011001100'));
                                        });
                                    return 'Enter your a Phone number without country code Ex. 09011001100';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                  
                              Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Date of Birth',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),
                          
                          InkWell(
                            onTap: () {
                              _loginButtonController.reset();
                              FocusManager.instance.primaryFocus?.unfocus();
                              DatePicker.showDatePicker(context,
                                  minTime: DateTime(1888),
                                  currentTime: dob == '' ? DateTime.now() : DateTime.parse(dob),
                                  maxTime: DateTime(2101), onConfirm: (date) {
                                print(dob+'p');
                                setState(() {
                                  dob = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                });
                                print(fullname);
                                  dob = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                              });
                  
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                              color: const Color.fromARGB(24, 158, 158, 158),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(dob,
                                  style: const TextStyle(fontSize: 20)),
                            ),
                          )
                        ],
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
                                  if (dob.trim()=='' || dob==null) {
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
                                                        Navigator.of(context)
                                                            .pop();
                                                            _loginButtonController.reset();
                                                      },
                                                    )
                                                  ],
                                                  title: const Text(
                                                      "Invalid Date of birth"),
                                                  content: Text('Enter your Date of Birth'));
                                            });
                                            return;
                                }
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState!.validate()) {
                                 setState(() {
                                   index = 2;
                                 });   
                                  pageController.animateToPage(2, duration: Duration(seconds: 1), curve: Curves.ease);
                                } 
                                
                                
                                else {
                                  _loginButtonController.reset();
                                }},
                                child: const Text('Confirm')))
                      ],
                    ),
                  ),
                  Column(children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          autofillHints: [AutofillHints.newUsername],
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Username',
                            helperText: 'Enter your unique username',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            username = text.trim();
                          },
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().contains(' ')) {
                              return 'Enter a username (empty spaces are not allowed)';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          autofillHints: [AutofillHints.newPassword],
                          obscureText: true,
                          cursorColor: Colors.grey,
                          // controller: _userPasswordController,
                          decoration: const InputDecoration(
                            // suffixIcon: IconButton(onPressed: () {
                            //   setState(() {
                            //     _passwordVisible = !_passwordVisible;
                            //   });
                            // }, icon: Icon(_passwordVisible ?
                            // Icons.visibility :
                            // Icons.visibility_off

                            // )),
                            hintText: 'Password',
                            helperText: 'Password must be at least 8 characters',
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            password = text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your Password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.payload!.containsKey('firstname'),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            obscureText: true,
                            maxLength: 4,
                            cursorColor: Colors.grey,
                            // controller: _userPasswordController,
                            decoration: const InputDecoration(
                              // suffixIcon: IconButton(onPressed: () {
                              //   setState(() {
                              //     _passwordVisible = !_passwordVisible;
                              //   });
                              // }, icon: Icon(_passwordVisible ?
                              // Icons.visibility :
                              // Icons.visibility_off
                      
                              // )),
                              hintText: 'Transaction PIN',
                              helperText: 'Set a 4 digits transaction PIN',
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
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onChanged: (text) {
                              pin = text;
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
                                  Map a = await createUserAccount(
                                    fullname,
                                    phone != '' ? phone : phoneConfirm,
                                    dob,
                                    widget.email,
                                    password,
                                    phoneConfirm,
                                    pin,
                                    username,
                                    otp,
                                    widget.payload!.containsKey('firstname') ? "with_bvn" : "without_bvn"
                                  );
                                  print(a);
                                  if (a.containsKey('Status')) {
                                    if (a['Status'] == 'successful') {
                                      _loginButtonController.reset();
                                      // setBVN()
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (loading) {
                                            return AlertDialog(
                                                title: const Text("Account creation successful"),
                                                content: Row(
                                                  children: const [
                                                    Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                    Text('Logging you in...'),
                                                  ],
                                                ));
                                          });
                                          try {
                                            User a = await loginUser(username, password, pin);
                                            brakey.setUser(Rxn(a), pin);
                                            Get.offUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Manager(user: a, pin: ''),
                                                maintainState: true),
                                            (route) => false);

                                          } catch (e) {
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
                                                      Navigator.of(context)
                                                          .pop();
                                                          _loginButtonController.reset();
                                                    },
                                                  )
                                                ],
                                                title: const Text(
                                                    "Failed"),
                                                content: Text(a['Message']??'Something went wrong, Please try again.'));
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
                                                    },
                                                  )
                                                ],
                                                title: const Text(
                                                    "Account creation failed"),
                                                content: Text(a['Message']));
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
                                                    "Account creation failed"),
                                                content: Text(toTitleCase(a['Message'])));
                                          });
                                      // }

                                    }
                                } else {
                                  _loginButtonController.reset();
                                  return; 
                                }
                              },
                              child: const Text('Signup')))
                  ],)
                  
                ],

          ),
        ),
      ),
    );
  }

}

