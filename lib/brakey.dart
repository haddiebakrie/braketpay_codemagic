import 'dart:convert';
import 'dart:io';

import 'package:braketpay/api_callers/savings.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:braketpay/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  var savedBalance = '0'.obs;
  late Box prefs;
  Rx<bool> showSavingsBalance = true.obs;
  Rx<bool> useBiometric = false.obs;
  Rx<bool> darkMode = false.obs;
  Rx<bool> showWalletBalance = true.obs;
  Function? refreshApp;
  Rx<bool> showRefBalance = true.obs;
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
  
  initStorage() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    prefs = await Hive.openBox('preferences');
    showWalletBalance.value = prefs.get('showWalletBalance');
    showRefBalance.value = prefs.get('showRefBalance');
    darkMode.value = prefs.get('darkMode');
    showSavingsBalance.value = prefs.get('showSavingsBalance');
    useBiometric.value = await getBiometric();
  }

  Future<bool> getBiometric() async {
  var box = await Hive.openBox('isBioEnabled');
  if (box.containsKey(user.value!.payload!.username)) {
    return box.get(user.value!.payload!.username);
  } else {
    box.put(user.value!.payload!.username, false);
    return false;
  }
    
  }

  toggleDarkMode() async {
    prefs = await Hive.openBox('preferences');
    prefs.put('darkMode', !darkMode.value);
    darkMode.value = !darkMode.value;
    print("$darkMode ggggggggggggggggggggggggggggg");
  }

  toggleBiometric(bool? value) async {
    
    var box = await Hive.openBox('isBioEnabled');
    bool _ = await getBiometric();
    if (value != null) {
      _ = !value;
    }
    box.put(user.value!.payload!.username, !_);
    useBiometric.value = !_;


  }

  setUser(Rxn<User> _user, String _pin) {
    initStorage();
    user = _user;
    pin = _user.value?.payload?.pin?.obs ?? ''.obs;

    saveUser();
    // refreshAll.value!.currentState!.show();
  }

  toggleSavingsBalance(){
    bool cmode = showSavingsBalance.value;
    showSavingsBalance.value = !cmode;
    prefs.put('showSavingsBalance', !cmode);
  }

  toggleWalletBalance(){
    bool cmode = showWalletBalance.value;
    showWalletBalance.value = !cmode;
    prefs.put('showWalletBalance', !cmode);
  }

  toggleRefBalance(){
    bool cmode = showRefBalance.value;
    showRefBalance.value = !cmode;
    prefs.put('showRefBalance', !cmode);
  }

  smartToggleBalance(String title) {
    if (title.contains('Refferal')) {
      toggleRefBalance();
    } else if (title.contains('Wallet')) {
      toggleWalletBalance();
    } else if (title.contains('Savings')) {
      toggleSavingsBalance();
    }
  }

  toggleBalance() {
    toggleRefBalance();
    toggleSavingsBalance();
    toggleWalletBalance();
  }

  bool showBalance(String title) {
    if (title.contains('Refferal')) {
      return showRefBalance.value;
    } else if (title.contains('Wallet')) {
      return showWalletBalance.value;
    } else if (title.contains('Savings')) {
      return showSavingsBalance.value;
    } else {
      return false;
    }
  }

  setContracts(List<ProductContract> _contracts) {
    contracts.value = _contracts;
  }

  setTransactions(List<Transaction> _transactions) {
    transactions.value = _transactions;
  }

  reloadUser(_pin) async {
    User _user = await fetchUserAccount(user.value!.payload!.accountNumber??'', user.value!.payload!.password??'', _pin);
    setUser(Rxn(_user), _pin);

  }

  clearNotiCount() {
    // print(notiCount);
    notiCount.value = 0;
    // print(notiCount);
  }

  refreshUserDetail() async {
    refreshAll.value?.currentState?.show();
    refreshSavings.value?.currentState?.show();
    refreshSavingsDetail.value?.currentState?.show();
    refreshMerchant.value?.currentState?.show();
    refreshNotifications.value?.currentState?.show();
    refreshTransactions.value?.currentState?.show();
    refreshContracts.value?.currentState?.show();
    refreshSavedBalance();
    
  }

  changeManagerIndex(index) async {
    managerIndex.value = index;
    // clearNotiCount();
    // managerIndex.refresh();
    // print("User ${box.get('user')}");
    // print(index);
    // print()
    // incrementNotification();
    // listenToAccountChanges();
  }

  saveUser() async {
  // final Brakey brakey = Get.put(Brakey());
  var box = await Hive.openBox('savedUsers');
  Map notifications = jsonDecode(user.value!.payload!.checkNotifications??null.toString());
  Map userdata = {user.value?.payload?.email:[user.value?.toJson(), pin.value, '']};
    // Map? userdata;
  // if (box.containsKey('users')) {
  //   Map _user = box.get('users');
  //   if (_user.values.toList().length == 3) {
  //   String lastNoti = _user.values.toList()[0][2]??'null';
  //     if (lastNoti != notifications.keys.last) {

  //       // notiCount++;
        
  //     } else {
  //       userdata = {user.value?.payload?.email:[user.value?.toJson(), pin.value, lastNoti]};
  //     }
              
  //   } else {
  //   }

  // }
  
      box.put('users', userdata);
      refreshSavedBalance();
      box.put('loggedStatus', true);
  // box.put
  }

  refreshSavedBalance() async {
    Map savingsBalance = await getSavings(user.value!.payload!.accountNumber??'', user.value!.payload!.pin??'', user.value!.payload!.password??'', 'all_savings_amount', '');
  if (savingsBalance.containsKey('total_money_saved')) {
    savedBalance = RxString(savingsBalance['total_money_saved'].toString());
  }
  }

  logoutUser() async {
  var box = await Hive.openBox('savedUsers');
  box.put('loggedStatus', false);

  }

  incrementNotification() {
    notiCount++;
  }
      Map sliceMap(Map map, offset, limit) {
  return Map.fromIterable(map.keys.skip(offset).take(limit),
      value: (k) => map[k]);
      }

  listenToAccountChanges() async {
  var box = await Hive.openBox('savedUsers');

  


  // print(box.get('loggedStatus'));
  if (box.get('loggedStatus') != true) {
    return;
  }

    try {
      

    DateTime timestamp =  HttpDate.parse(user.value!.payload!.datetimeLastChangesMade?? '');

    User newUser = await fetchUserAccount(user.value!.payload!.accountNumber??'', user.value!.payload!.password??'', pin.value);
    DateTime newTimestamp = HttpDate.parse(newUser.payload!.datetimeLastChangesMade??"");

    if (timestamp.isAtSameMomentAs(newTimestamp)) {
      return;
    } else {
    Map? n = jsonDecode(user.value!.payload!.checkNotifications??null.toString());
    Map? nn = jsonDecode(newUser.payload!.checkNotifications??null.toString());

    if (n!=null && nn != null) {
      if (n.length < nn.length) {
        int a = nn.length - n.length;
        notiCount.value = nn.length - n.length;

        sliceMap(nn, nn.length - a, nn.length).forEach((key, value) {
       Map noti = jsonDecode(value);
       if (noti['type'] == 'transfer') {

       }
       sendNotification('You have a new notification', toTitleCase(noti['message']));
          
      });
      }
    }

    refreshUserDetail();

    }
    } catch (e) {
    User a = await loginUser(user.value!.payload!.username??'', user.value!.payload!.password??'', '');
    setUser(Rxn(a), '');
    refreshUserDetail();
    }

    saveUser();
  }

  sendNotification(title, message) {
      // refreshAll();
    AwesomeNotifications().initialize(
  // set the icon to null if you want to use the default app icon
  null,
  [
    NotificationChannel(
        channelGroupKey: 'braket_channel_group',
        channelKey: 'braket_channel',
        channelName: 'Braket notifications',
        channelDescription: 'Notification channel for Brakets',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white)
  ],
  // Channel groups are only visual and are not required
  channelGroups: [
    NotificationChannelGroup(
        channelGroupkey: 'braket_channel_group',
        channelGroupName: 'Braket group')
  ],
  debug: true
);

AwesomeNotifications().createNotification(
  content: NotificationContent(
      id: 0,
      channelKey: 'braket_channel',
      title: title,
      displayOnBackground: true,
      displayOnForeground: true,
      notificationLayout: NotificationLayout.BigText,
      body: message,
      criticalAlert: true,
      category: NotificationCategory.Social,
  )
);
  }
}