import 'dart:convert';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/login.dart';
import 'package:braketpay/screen/manager.dart';
import 'package:braketpay/screen/userlogin.dart';
import 'package:braketpay/screen/welcome.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'firebase_options.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('savedUsers');
  var prefs = await Hive.openBox('preferences');
  if (!prefs.containsKey('darkMode')) {
    prefs.put('showWalletBalance', true);
    prefs.put('darkMode', false);
    prefs.put('showSavingsBalance', true);
    prefs.put('showRefBalance', true);
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final bool darkMode = await prefs.get('darkMode');
  runApp(MyApp(box:box, pref: prefs, darkMode:darkMode));
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.box, this.pref, this.darkMode}) : super(key: key);
  // final SharedPreferences prefs;
  final Box? box;
  final bool? darkMode;
  final Box? pref;
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

    print('$darkMode'+'sldkfjasldkj');
    return GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'BrakeyPay',
      theme: ThemeData.light().copyWith(
        primaryColor: const Color.fromARGB(255, 0, 13, 194),
        primaryColorLight: const Color.fromARGB(255, 0, 13, 194),
        primaryColorDark: const Color.fromARGB(255, 0, 13, 194),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 0, 13, 194)
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF000DC2)
        ),
        // textTheme: GoogleFonts.rubikTextTheme(
        //   Theme.of(context).textTheme,
        // )
      ),
      darkTheme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 0, 13, 194),
        primaryColorLight: const Color.fromARGB(255, 0, 13, 194),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 0, 13, 194)
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF000DC2)
        ),
      ),
      themeMode: darkMode!=null && darkMode! ?ThemeMode.dark:ThemeMode.light,
      // home: Manager(user: User(message: '', payload: Payload(), responseCode: 00, status: ''), pin: '1222'),
      // List<String> 0=username, 1=password, 3=pin,
      // home: box?.get('loggedStatus') == false ? Login(showOnboarding:true) : a == null ? Login() : Manager(user: User.fromJson(Map.from(a)), pin:"")
      // home: box?.get('loggedStatus') == false ? const Login(showOnboarding:true) : a == null ? const Login() : TestAPIAccess()
      home: box?.get('loggedStatus') == false && a != null ? const Login(showOnboarding:true) : a == null ? UserLogin() : WelcomeBack()
    );
  }
}

class TestAPIAccess extends StatefulWidget {
  const TestAPIAccess({Key? key}) : super(key: key);

  @override
  State<TestAPIAccess> createState() => _TestAPIAccessState();
}

class _TestAPIAccessState extends State<TestAPIAccess> {
  String response = 'This is a response';
  final RoundedLoadingButtonController _ = RoundedLoadingButtonController();
  final RoundedLoadingButtonController __ = RoundedLoadingButtonController();
  final RoundedLoadingButtonController ___ = RoundedLoadingButtonController();
  final RoundedLoadingButtonController ____ = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

                children: [
                  RoundButton(
                    text: 'Cancel',
                    onTap: () {
                      Get.to(const Login());
                    },
                  ),
                  RoundedLoadingButton(
                    controller: _,
                    child: const Text('Braket - HTTP'), onPressed: () async {
                      var a = await braketHttp();

                      setState(() {
                        response = a.toString();
                      }); 

                      _.reset();

                    }),  const SizedBox(height: 30,),
                  RoundedLoadingButton(
                    controller: __,
                    child: const Text('Braket - DIO'), onPressed: () async {
                      
                      var a = await braketDIO();

                      setState(() {
                        response = a.toString();
                      }); 

                      __.reset();

                    }), const SizedBox(height: 30,),
                  RoundedLoadingButton(
                    controller: ___,
                    child: const Text('Typicode - HTTP'), onPressed: () async {
                       
                      var a = await typicodeHTTP();
                      setState(() {
                        response = a.toString();
                      }); 

                      ___.reset();
                      
                    }), const SizedBox(height: 30,),
                  RoundedLoadingButton(
                    controller: ____,
                    child: const Text('Typicode - DIO'), onPressed: () async {
                       
                      var a = await typicodeDIO();

                      setState(() {
                        response = a.toString();
                      }); 

                      ____.reset();
                      
                    }), const SizedBox(height: 30,),
                ]
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: const Color.fromARGB(255, 222, 222, 222),
                child: Text(response, style: const TextStyle(color: Colors.black))
              ),
            )
          ],
        ),
      )
    );
  }
}

// API calls

braketHttp()  async {
  String param = Uri(queryParameters: {
      "caller_email" :"classichaddy@gmail.com",
      "caller_password": "love4haddy",
      "id_type": 'username',
      "second_party_id": 'haddy'
    }).query;
    try {
    final response = await get(
      Uri.parse('https://api.braketpay.com/fetch_second_party_credentials?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    // print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      var payloads = jsonDecode(response.body);
    return payloads;
  } else {
    return {'Message':'Sent but no return'};
  }

    } catch (e) {
    return {'Message':e.toString()};
    }
}

braketDIO() async {
  String param = Uri(queryParameters: {
      "caller_email" :"classichaddy@gmail.com",
      "caller_password": "love4haddy",
      "id_type": 'username',
      "second_party_id": 'haddy'
    }).query;


    try {
      final response = await Dio().get(
        'https://api.braketpay.com/fetch_second_party_credentials?$param',
        options: Options(
          headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
        )
        );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      var payloads = response.data;
    return payloads;
  } else {
    return {'Message':'Sent but no return'};
  }

    } catch (e) {
    return {'Message':e.toString()};
    }
      
}

typicodeHTTP() async {
    try {
    final response = await get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos/1'),
      );
    // print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      var payloads = jsonDecode(response.body);
    return payloads;
  } else {
    return {'Message':'Sent but no return'};
  }

    } catch (e) {
    return {'Message':e.toString()};
    }
}

typicodeDIO() async {
    try {
      final response = await Dio().get(
        'https://jsonplaceholder.typicode.com/todos/1',
        );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      var payloads = response.data;
    return payloads;
  } else {
    return {'Message':'Sent but no return'};
  }

    } catch (e) {
    return {'Message':e.toString()};
    }
      
}