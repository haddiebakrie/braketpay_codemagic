import 'dart:io';

import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './classes/user.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import './classes/product_contract.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Brakey extends GetxController{
  Rxn<User> user = Rxn<User>();
  RxInt managerIndex = 0.obs;
  RxInt notiCount = 0.obs;
  var pin = ''.obs;
  Rxn<List<ProductContract>> contracts = Rxn<List<ProductContract>>();
  Rxn<List<Transaction>> transactions = Rxn<List<Transaction>>();
  final refreshAll = Rxn(GlobalKey<RefreshIndicatorState>());
  final refreshContracts = Rxn(GlobalKey<RefreshIndicatorState>());
  final refreshHistory = Rxn(GlobalKey<RefreshIndicatorState>());
  final refreshTransactions = Rxn(GlobalKey<RefreshIndicatorState>());
  final refreshNotifications = Rxn(GlobalKey<RefreshIndicatorState>());
  final refreshMerchant = Rxn(GlobalKey<RefreshIndicatorState>());
  final refreshSavings = Rxn(GlobalKey<RefreshIndicatorState>());
  final refreshSavingsDetail = Rxn(GlobalKey<RefreshIndicatorState>());


  setUser(Rxn<User> _user, String _pin) {
    user = _user;
    pin = _pin.obs;
    saveUser();
    // refreshAll.value!.currentState!.show();
  }

  setContracts(List<ProductContract> _contracts) {
    contracts = Rxn(_contracts);
  }

  setTransactions(List<Transaction> _transactions) {
    transactions = Rxn(_transactions);
  }

  reloadUser(_pin) async {
    User _user = await fetchUserAccount(user.value!.payload!.accountNumber??'', user.value!.payload!.password??'', _pin);
    if (_user!=null) {
      setUser(Rxn(_user), _pin);
      // refreshAll.value!.currentState!.show();
    }

  }

  refreshUserDetail() async {
    refreshAll.value?.currentState?.show();
    refreshSavings.value?.currentState?.show();
    refreshSavingsDetail.value?.currentState?.show();
    refreshMerchant.value?.currentState?.show();
    refreshNotifications.value?.currentState?.show();
    refreshTransactions.value?.currentState?.show();
    refreshContracts.value?.currentState?.show();
  }

  changeManagerIndex(index) async {
    managerIndex = RxInt(index);
    managerIndex.refresh();
    var box = await Hive.openBox('savedUsers');
    // print("User ${box.get('user')}");
    // print(index);
    listenToAccountChanges();
  }

  saveUser() async {
  final Brakey brakey = Get.put(Brakey());
  var box = await Hive.openBox('savedUsers');
  print(user.value!.toJson().runtimeType);
  Map? userdata = {user.value?.payload?.email:[user.value?.toJson(), pin.value]};
  box.put('users', userdata);
  box.put('loggedStatus', true);
  }

  logoutUser() async {
  var box = await Hive.openBox('savedUsers');
  box.put('loggedStatus', false);

  }

  listenToAccountChanges() async {

    DateTime timestamp =  HttpDate.parse(user.value!.payload!.datetimeLastChangesMade?? '');

    User new_user = await fetchUserAccount(user.value!.payload!.accountNumber??'', user.value!.payload!.password??'', pin.value);
    DateTime new_timestamp = HttpDate.parse(new_user.payload!.datetimeLastChangesMade??"");

    if (timestamp.isAtSameMomentAs(new_timestamp)) {
      print('same');
      return;
    };
    print('refreshing...');
    // refreshAll();
//     AwesomeNotifications().initialize(
//   // set the icon to null if you want to use the default app icon
//   null,
//   [
//     NotificationChannel(
//         channelGroupKey: 'basic_channel_group',
//         channelKey: 'basic_channel',
//         channelName: 'Basic notifications',
//         channelDescription: 'Notification channel for basic tests',
//         defaultColor: Color(0xFF9D50DD),
//         ledColor: Colors.white)
//   ],
//   // Channel groups are only visual and are not required
//   channelGroups: [
//     NotificationChannelGroup(
//         channelGroupkey: 'basic_channel_group',
//         channelGroupName: 'Basic group')
//   ],
//   debug: true
// );

// AwesomeNotifications().createNotification(
//   content: NotificationContent(
//       id: 10,
//       channelKey: 'basic_channel',
//       title: 'Simple Notification',
//       body: 'Simple body',
//       category: NotificationCategory.Message,
//   )
// );
  }
}