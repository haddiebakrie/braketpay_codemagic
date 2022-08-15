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

import '../modified_packages/modified_numerickeyboard.dart';
import '../utils.dart';

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
