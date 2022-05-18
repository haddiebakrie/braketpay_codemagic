import 'dart:convert';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/classes/product_contract.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/history.dart';
import 'package:braketpay/screen/merchant.dart';
import 'package:braketpay/screen/home.dart';
import 'package:braketpay/screen/wallet.dart';
import 'package:braketpay/uix/walletcard.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../uix/contractlistcard.dart';
import 'contracts.dart';

class Manager extends StatefulWidget {
  Manager({Key? key, required this.user, required this.pin, this.mcurrentIndex = 0}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final User user;
  final String pin;
  int mcurrentIndex;


  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {


  @override
  void initState() { 
    super.initState();
    
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    List<Widget> screenList = [
      Home(user: widget.user, pin: widget.pin),
      Contracts(user: widget.user, pin: widget.pin),
      History(user: widget.user, pin: widget.pin),
      Wallet(user: widget.user, pin: widget.pin),
      Merchant(user: widget.user, pin: widget.pin),
      // Text('HI'),
      // Contracts(),
      // Contracts(),
      // CalendarPage(),
      // ProfilePage(),
    ];
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        
        // appBar: AppBar(
        //     elevation: 0,
        //     titleSpacing: 5,
        //     toolbarHeight: 65,
        //     leading: Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        //       child: Container(
        //         decoration: BoxDecoration(
        //             color: Colors.white,
        //             border: Border.all(color: Colors.white),
        //             borderRadius: BorderRadius.circular(20)),
        //         child: IconButton(
        //             icon: const Icon(IconlyBold.profile),
        //             color: Theme.of(context).primaryColor,
        //             iconSize: 20,
        //             onPressed: () {}),
        //       ),
        //     ),
        //     actions: [
        //       IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        //     ],
        //     title: Column(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text('Hi, ' + widget.title,
        //               style: const TextStyle(fontWeight: FontWeight.bold)),
        //           Text('@' + widget.title, style: const TextStyle(fontSize: 14))
        body: IndexedStack(
          children: screenList,
          index: currentIndex,
        ),
        //         ])),
        bottomNavigationBar: BottomNavigationBar(
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
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => setState(() {currentIndex = index;})
            // onTap: _selectTab,
            // currentIndex: _currentTab,
            ),
            
        
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

}