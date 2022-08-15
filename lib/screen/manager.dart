import 'dart:async';
import 'dart:convert';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/history.dart';
import 'package:braketpay/screen/marketplace.dart';
import 'package:braketpay/screen/merchant.dart';
import 'package:braketpay/screen/home.dart';
import 'package:braketpay/screen/userlogin.dart';
import 'package:braketpay/screen/wallet.dart';
import 'package:braketpay/uix/walletcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_app_update/in_app_update.dart';

import '../uix/contractlistcard.dart';
import 'contracts.dart';

class Manager extends StatefulWidget {
  const Manager({Key? key, required this.user, required this.pin, this.mcurrentIndex = 0, this.askSaveBiometric=false}) : super(key: key);
  final User user;
  final String pin;
  final int mcurrentIndex;
  final bool askSaveBiometric;


  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  

  Brakey brakey = Get.put(Brakey());
  late final List<Widget> screenList;
  List<int> _navigationRoutes = [0];

  @override
  void initState() { 
    super.initState();
    // checkForUpdate();
    screenList = [
      Home(user: widget.user, pin: brakey.user.value?.payload?.pin??'', gotoWallet: gotoWallet),
      MarketPlace(),
      // Contracts(user: widget.user, pin:brakey.user.value?.payload?.pin??''),
      History(user: widget.user, pin: brakey.user.value?.payload?.pin??''),
      Merchant(user: widget.user, pin: brakey.user.value?.payload?.pin??''),
    ];
    // promptSaveBiometric();
  }

  int currentIndex = 0;

  gotoWallet() {
      setState(() {brakey.changeManagerIndex(3);});
  }
  @override
  Widget build(BuildContext context) {

    Timer.periodic(Duration(seconds: 5), (timer) async {
      brakey.listenToAccountChanges();
      var box = await Hive.openBox('savedUsers');
      bool isLoggedIn = box.get('loggedStatus');
      // print('7777777777777777777777777777777 $isLoggedIn');
      if (!isLoggedIn) {
        timer.cancel();
        Get.offUntil(MaterialPageRoute(builder: (context) => UserLogin()), (route) => false);
      }
     });

    return WillPopScope(
      onWillPop: () async {
        if (_navigationRoutes.last == 0) {
          return true;
        }
        if (_navigationRoutes.length > 1) {
          _navigationRoutes.removeLast();
          brakey.changeManagerIndex(_navigationRoutes.last);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Obx( () => IndexedStack(
            children: screenList,
            index: brakey.managerIndex.toInt(),
          ),
        ),
        //         ])),
        bottomNavigationBar: Obx(() => (BottomNavigationBar(
          
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(IconlyBold.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.extension), label: 'Contracts'),
              // BottomNavigationBarItem(
              //     icon: Icon(IconlyBold.paper), label: 'Contracts'),
              BottomNavigationBarItem(
                  icon: Icon(IconlyBold.time_square), label: 'History'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.work), label: 'My Business')
            ],
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            showUnselectedLabels: true,
            // backgroundColor: Color.fromARGB(255, 5, 1, 18),
            currentIndex: brakey.managerIndex.value,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              print(_navigationRoutes);
              brakey.changeManagerIndex(index);
              _navigationRoutes.remove(index);
              _navigationRoutes.add(index);
            }
            // onTap: _selectTab,
            // currentIndex: _currentTab,
        )))
            
        
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

}