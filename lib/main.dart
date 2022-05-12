import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/login.dart';
import 'package:braketpay/screen/manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // final SharedPreferences _prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // final SharedPreferences prefs;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // List<String> users = prefs.getStringList('user')??[];
    // List<String> user = prefs.getStringList(users[0])??[];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      // home: Manager(user: User(message: '', payload: Payload(), responseCode: 00, status: ''), pin: '1222'),
      // List<String> 0=username, 1=password, 3=pin,
      home: Login() ,
    );
  }
}

