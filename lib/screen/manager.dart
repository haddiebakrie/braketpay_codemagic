import 'dart:async';
import 'dart:convert';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/history.dart';
import 'package:braketpay/screen/merchant.dart';
import 'package:braketpay/screen/home.dart';
import 'package:braketpay/screen/wallet.dart';
import 'package:braketpay/uix/walletcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_app_update/in_app_update.dart';

import '../uix/contractlistcard.dart';
import 'contracts.dart';

class Manager extends StatefulWidget {
  const Manager({Key? key, required this.user, required this.pin, this.mcurrentIndex = 0}) : super(key: key);
  final User user;
  final String pin;
  final int mcurrentIndex;


  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  Future<void> checkForUpdate() async {
    print('Checking for Update');
    InAppUpdate.checkForUpdate().then((value) => {
    setState(() {
      _updateInfo = value;
    }),
    _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable ? InAppUpdate.startFlexibleUpdate().catchError((e){}) 
    : null
    }
    
    ).catchError((e) {
      print(e);
    });
  }

  Brakey brakey = Get.put(Brakey());
  late final List<Widget> screenList;
  List<int> _navigationRoutes = [0];

  @override
  void initState() { 
    super.initState();
    checkForUpdate();
    screenList = [
      Home(user: widget.user, pin: brakey.user.value!.payload!.pin??'', gotoWallet: gotoWallet),
      Contracts(user: widget.user, pin:brakey.user.value!.payload!.pin??''),
      History(user: widget.user, pin: brakey.user.value!.payload!.pin??''),
      Wallet(user: widget.user, pin: brakey.user.value!.payload!.pin??''),
      Merchant(user: widget.user, pin: brakey.user.value!.payload!.pin??''),
    ];
    
  }

  int currentIndex = 0;

  gotoWallet() {
      setState(() {brakey.changeManagerIndex(3);});
  }

  
  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 10), (timer) {
      brakey.listenToAccountChanges();
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
                  icon: Icon(IconlyBold.paper), label: 'Contracts'),
              BottomNavigationBarItem(
                  icon: Icon(IconlyBold.time_circle), label: 'History'),
              BottomNavigationBarItem(
                  icon: Icon(IconlyBold.wallet), label: 'Wallet'),
              BottomNavigationBarItem(
                  icon: Icon(IconlyBold.work), label: 'Business')
            ],
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            showUnselectedLabels: true,
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