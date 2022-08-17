import 'dart:async';

import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/bvnprompt.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../modified_packages/modified_numerickeyboard.dart';
import '../utils.dart';

class SmartTransfer extends StatefulWidget {
  SmartTransfer({Key? key}) : super(key: key);

  @override
  State<SmartTransfer> createState() => _SmartTransferState();
}

class _SmartTransferState extends State<SmartTransfer> {
  Brakey brakey = Get.put(Brakey());
  double amount = 0;
    final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final TextEditingController _pinEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Cash'),
        elevation: 0,
      ),
      body: Stack(
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
          SingleChildScrollView(
            child: GlassContainer(
            borderRadius: BorderRadius.zero,
            child: Container(
              padding: const EdgeInsets.all(20),
              // decoration: ContainerBackgroundDecoration(),
              child: Column(
                children: [
                  const SizedBox(height:20),
                  // Visibility(child: topWidget==null? Container() : topWidget),
                  const SizedBox(height:20),
                  const Text('Available Balance', style: TextStyle(fontSize: 20, color: Colors.white)),
                  const SizedBox(height:10),
                  Text('${nairaSign()}${brakey.user.value?.payload?.accountBalance.toString()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, 
                   color: double.parse(brakey.user.value?.payload?.accountBalance.toString()??'0') >= amount ? Colors.white : Colors.redAccent)),
                  const SizedBox(height:20),
                  TextFormField(
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 90, color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00',
                      hintStyle: TextStyle(color: Color.fromARGB(140, 255, 255, 255))
                    ),
                    controller: _pinEditController,
                    onChanged: (value) async {
                        print('amount');
                      setState(() {
                      });
                    },
                    readOnly: true,
                    autofocus: true,

                  ),
                  SizedBox(height: 20,),
                  // Expanded(child: Container()),
                  CustomNumericKeyboard(
                    textColor: Colors.white,
                  rightIcon: const Icon(CupertinoIcons.delete_left_fill, color: Colors.white,),
                  rightButtonFn: () {
                    setState(() {
                    amount = double.tryParse(_pinEditController.text.substring(0, _pinEditController.text.length - 1))??0;
                    _pinEditController.text = _pinEditController.text.substring(0, _pinEditController.text.length - 1);
                      
                    });
              
                  },
                  onKeyboardTap: 
                  (text) {
                    if (text == '0' && _pinEditController.text == '') {
                      return;
                    }
                    setState(() {
                    amount = double.tryParse(_pinEditController.text + text)??0;
                    _pinEditController.text = _pinEditController.text + text;
                      
                    });
                  }
                  ),
                  SizedBox(height: 90,)
                ]
              
              )
            ),
              ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: Colors.transparent,
        child: RoundedLoadingButton(
          
          borderRadius: 20,
          color: Colors.teal,
          elevation: 0,
          controller: _loginButtonController,
          onPressed: () async {
                        print(amount);

          },
          child: Text('Send')
        ),
      ),
    );
  }
}

Future<Map?> askPin(TextEditingController _pinEditController, StreamController<ErrorAnimationType> _pinErrorController, {Widget? topWidget=null})  async {
    Brakey brakey = Get.put(Brakey());
    
    if (brakey.user.value!.payload!.bvn == 'Not added') {
      Get.defaultDialog(
        title: 'Transaction PIN no set',
        content: Text('You need to set your Transaction PIN, to continue'),
        // textCancel: 'Cancel',
        // cancel: TextButton(child: Text('Cancel'), onPressed: () {
        // }),
        radius: 0,
        actions: [

          TextButton(child: Text('Okay'), onPressed: () {
      Get.to(() => BVNPrompt());

                  }),
        ],

        contentPadding: EdgeInsets.all(20),
      );

      return {'status':false};
    }
    return await Get.bottomSheet<Map>(
      
    BottomSheet(
    backgroundColor: Colors.transparent,
    enableDrag: true,
    onClosing: () {}, 
    builder: (pinContext) {
    return GlassContainer(
      blur: 12,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        // decoration: ContainerBackgroundDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height:20),
              Visibility(child: topWidget==null? Container() : topWidget),
              const SizedBox(height:20),
              const Text('Braket Transaction PIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height:20),
              SizedBox(
                width: 200,
                height: 50,
                child: PinCodeTextField(
                  textStyle: TextStyle(color: Colors.white, fontSize: 30),
                  pinTheme: PinTheme(
                    // fieldHeight: 20,
                    // fieldWidth: 20,
                    shape: PinCodeFieldShape.underline,
                    borderRadius: BorderRadius.circular(10),
                    activeFillColor: Colors.transparent,
                    borderWidth: 0,
                    inactiveColor: Colors.transparent,
                    activeColor: Colors.transparent,
                    inactiveFillColor: Colors.transparent,
                    selectedFillColor: Colors.transparent,
                    selectedColor: Colors.transparent,
                    fieldOuterPadding: EdgeInsets.zero
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  controller: _pinEditController,
                  errorAnimationController: _pinErrorController,
                  animationType: AnimationType.scale,
                  hintCharacter: '●',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  appContext: pinContext, length: 4, 
                  onCompleted: (text) {
                    // print(brakey.pin.value);
                    // if (text != brakey.pin.value) {
                    //   _pinErrorController.add(ErrorAnimationType.shake);
                    //   _pinEditController.clear();
                      
                    // }
    
                    // else {
                      return Navigator.of(pinContext).pop({'status':true, 'pin':text});
                    // }
        
                  },
                  onChanged: (text) {
                  }),
              ),
              SizedBox(height: 20,),
              CustomNumericKeyboard(
                textColor: Colors.white,
              rightIcon: const Icon(CupertinoIcons.delete_left_fill, color: Colors.white,),
              rightButtonFn: () {
                _pinEditController.text = _pinEditController.text.substring(0, _pinEditController.text.length - 1);
        
              },
              onKeyboardTap: 
              (text) {
                _pinEditController.text = _pinEditController.text + text;
              }
              ),
              SizedBox(height: 20,)
            ]
        
          ),
        )
      ),
    );},
    
    ),
    isScrollControlled: true
  );
  }
