import 'dart:async';

import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/bvnprompt.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utils.dart';

Future<Map?> askPin(TextEditingController _pinEditController, StreamController<ErrorAnimationType> _pinErrorController)  async {
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
    enableDrag: false,
    onClosing: () {}, 
    builder: (pinContext) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ContainerBackgroundDecoration(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Braket Transaction PIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height:20),
            SizedBox(
              width: 200,
              height: 50,
              child: PinCodeTextField(
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  activeFillColor: Colors.white,
                  // borderWidth: 0,
                  inactiveColor: Colors.grey,
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                controller: _pinEditController,
                errorAnimationController: _pinErrorController,
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
            NumericKeyboard(
              textColor: Get.isDarkMode ? Colors.white : Colors.black,
            rightIcon: const Icon(CupertinoIcons.delete_left_fill),
            rightButtonFn: () {
              _pinEditController.text = _pinEditController.text.substring(0, _pinEditController.text.length - 1);
      
            },
            onKeyboardTap: 
            (text) {
              _pinEditController.text = _pinEditController.text + text;
            }
            )
          ]
      
        ),
      )
    );}
    )
  );
  }
