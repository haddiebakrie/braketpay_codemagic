import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/login.dart';
import 'package:braketpay/screen/manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('savedUsers');
  var prefs = await Hive.openBox('preferences');
  if (!prefs.containsKey('showWalletBalance')) {
    prefs.put('showWalletBalance', false);
    prefs.put('showSavingsBalance', false);
    prefs.put('showRefBalance', false);
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final SharedPreferences _prefs = await SharedPreferences.getInstance();
  runApp(MyApp(box:box));
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.box}) : super(key: key);
  // final SharedPreferences prefs;
  final Box? box;
  @override
  Widget build(BuildContext context) {

        // List<String> users = prefs.getStringList('user')??[];
    // List<String> user = prefs.getStringList(users[0])??[];
    final Brakey brakey = Get.put(Brakey());
    Map? users = box?.get('users');
    var user = users?[users.keys.toList()[0]];
    print('users $user');
    var userdata = user?[0];
    var pin = user?[1];
    var a = userdata == null ? null : jsonDecode(jsonEncode(userdata)) as Map<String, dynamic>;
    if (a!=null) {
    brakey.setUser(Rxn(User.fromJson(Map.from(a))), '');
    }
    print(box?.get('loggedStatus'));
    return GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'BrakeyPay',
      theme: ThemeData.light().copyWith(
        primaryColor: const Color.fromARGB(255, 0, 13, 194),
        // primaryColorLight: const Color.fromARGB(255, 0, 13, 194),
        // primaryColorDark: const Color.fromARGB(255, 0, 13, 194),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 0, 13, 194)
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF000DC2)
        ),
        // textTheme: GoogleFonts.rugeBoogieTextTheme(
        //   Theme.of(context).textTheme,
        // )
      ),
      darkTheme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        // primaryColor: const Color.fromARGB(255, 0, 13, 194),
        // primaryColorLight: const Color.fromARGB(255, 0, 13, 194),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 0, 13, 194)
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF000DC2)
        ),
      ),
      themeMode: ThemeMode.light,
      // home: Manager(user: User(message: '', payload: Payload(), responseCode: 00, status: ''), pin: '1222'),
      // List<String> 0=username, 1=password, 3=pin,
      // home: box?.get('loggedStatus') == false ? Login(showOnboarding:true) : a == null ? Login() : Manager(user: User.fromJson(Map.from(a)), pin:"")
      home: box?.get('loggedStatus') == false && a != null ? const Login(showOnboarding:true) : a == null ? const Login() : const Login(hasUser: true, showOnboarding: true,)
    );
  }
}

