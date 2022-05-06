import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/login.dart';
import 'package:braketpay/screen/manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      home: Login(),
    );
  }
}

