import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../utils.dart';

class ChangePin extends StatefulWidget {

  ChangePin({Key? key, required this.email}) : super(key: key);

  String email;
  
  @override
  State<ChangePin> createState() => _ChangePinState();

}

class _ChangePinState extends State<ChangePin> {
  String pin = '';
  bool passwordVisible = true;
  String otp = '';
    final _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
      elevation: 0,
      title: const Text('Change Transaction PIN')

      ),
      body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            child: Column(children: [
                            const SizedBox(height:10),
              Container(
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height:15),
                        Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Enter the OTP sent to ${widget.email}',
                                      style: const TextStyle(),
                                    ),
                                  ),
                                TextFormField(
                                  autofillHints: const [AutofillHints.oneTimeCode],
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                                  decoration: const InputDecoration(
                                    // suffixIcon: otp.length == 6 ? Container(height: 10, width: 10, padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth:2)) : Container(width:0, height:0),
                                    fillColor: Color.fromARGB(24, 158, 158, 158),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    hintText: '******',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onChanged: (text) async {
                                    setState(() {
                                    otp = text.trim();

                                    });
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
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: const Text(
                                      'New Transaction PIN',
                                      style: TextStyle(),
                                    ),
                                  ),
                                TextFormField(
                                  obscureText: passwordVisible,
                                  autofillHints: const [AutofillHints.oneTimeCode],
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                          // print(passwordVisible);
                                        },
                                        icon: passwordVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)
                                        ),
                                    // suffixIcon: otp.length == 6 ? Container(height: 10, width: 10, padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth:2)) : Container(width:0, height:0),
                                    fillColor: const Color.fromARGB(24, 158, 158, 158),
                                    filled: true,
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    hintText: '****',
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onChanged: (text) async {
                                    setState(() {
                                    pin = text.trim();
                                      
                                    });
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
                              ],
                            ),
                          ),
                          const SizedBox(height:20),
                      RoundedLoadingButton(
                                    borderRadius: 10,
                                    color: pin.length == 4 && otp.length > 3 ? Theme.of(context).primaryColor : Colors.grey.withAlpha(100),
                                    elevation: 0,
                                    controller: _loginButtonController,
                                    onPressed: () async {
                                      if (pin == '') {
                                        return;
                                      }
                                      if (_formKey.currentState!.validate()) {
                  
                                        Map a = await Future(() => {});
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
                                                        actions: [
                                                          TextButton(
                                                            child: const Text('Okay'),
                                                            onPressed: () {
                                                              Navigator.of(context)
                                                                  .pop();
                                                                Navigator.of(context)
                                                                  .pop();
                                                                Navigator.of(context)
                                                                  .pop();
                                                              _loginButtonController
                                                                  .reset();
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
          
          
            ],),
          )
          
          )

    );
  }
}