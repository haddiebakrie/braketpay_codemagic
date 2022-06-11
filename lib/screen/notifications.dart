import 'dart:convert';

import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/profile.dart';
import 'package:braketpay/uix/contractmodeselect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../api_callers/contracts.dart';
import '../api_callers/notifications.dart';
import '../uix/notificationcard.dart';
import '../utils.dart';
import '../classes/user.dart';
import '../uix/contractlistcard.dart';
import '../uix/roundbutton.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Brakey brakey = Get.put(Brakey());
  late Future<Map> _transactions = fetchNotifications(
      widget.user.payload!.walletAddress ?? "",
      widget.user.payload!.password ?? "",
      widget.pin);
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late Map? notifications = jsonDecode(brakey.user.value!.payload!.checkNotifications??null.toString());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 5,
        toolbarHeight: 65,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.bell_solid))
        ],
        title: const Text('Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        
      ),
      body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.zero),
            color: Colors.white,
          ),
          child: RefreshIndicator(
            key: brakey.refreshNotifications.value,
            onRefresh: () async {
              final transactions = await fetchNotifications(
                  widget.user.payload!.walletAddress ?? "",
                  widget.user.payload!.password ?? "",
                  widget.pin);
              setState(() {
                _transactions = Future.value(transactions);
              });
            },
            child: notifications != null ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: notifications?.length,
                      itemBuilder: (context, index) {
                        // product = snapshot.data![index];
                        return NotificationCard(notifications: jsonDecode(notifications?[notifications?.keys.toList()[index]]), pin:widget.pin);
                }) : Container()
    
    )));
  }
  Future<dynamic> contractMode() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (context) {
          return ContractModeSelect(user: widget.user, pin: widget.pin);
        });
  }
}

