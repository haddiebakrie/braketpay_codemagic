import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:intl/src/intl/number_format.dart";

final wallets = [{
    "name": "Referral",
    "balance": 1000
  },
  {
    "name": "Braket Wallet",
    "balance": 1000
  },
  {
    "name": "Savings",
    "balance": 1000
  },];

final format_currency = new NumberFormat('#,##0.00');

String formatAmount(String amount) {

    var currency = NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return currency.format(double.parse(amount));
  }


Future<PermissionStatus> getCameraPermission() async {
    var status = await Permission.camera.status;
    print(status.isGranted);
    if (!status.isGranted) {
        final result = await Permission.camera.request();
        return result;
    } else {
      return status;
    }
}

String nairaSign() {
  return '\u20A6';
}

String toTitleCase(String str) {
  return str.length > 0 ? '${str[0].toUpperCase()}${str.substring(1)}':'';
}

String toAdvanceDate(DateTime datetime) {
  DateTime now =  DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final aDate = DateTime(datetime.year, datetime.month, datetime.day);
  if(aDate == today) {
    return '${datetime.hour}:${datetime.minute.toString().padLeft(2, '0')} ';
  } else if(aDate == yesterday) {
    return 'Yesterday';
  }
  return '${DateFormat('MMM dd').format(DateTime(0, aDate.month, aDate.day))}';
}

String formatDate(DateTime date) => 
  DateFormat('MMM, dd yyyy').format(date);


Future<void> checkForUpdate() async {
    AppUpdateInfo? _updateInfo;
    bool _flexibleUpdateAvailable = false;
  
    InAppUpdate.checkForUpdate().then((value) => {
    // setState(() {
    // }),
    _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable ? InAppUpdate.startFlexibleUpdate().catchError((e){}) 
    : null
    }
    
    ).catchError((e) {
      // print(e);
    });
  }

List productCategories = ["Gadgets","Fashion","Phones & Tablets","Health","Home & Office","Computers & Accesories", "Electronics & Accesories","Gaming","Construction Materials", "Art Works & Paintings","Beauty & Cosmetics", "Others"];
List serviceCategories = ["Web & App Developement","Construction Works","Tailouring","Painting","Computer & Electronics Repairs","Air Dressing & Makeups","Event plannings","Car & Mechanical Repairs","Others"];

Future<List> uploadToFireStore(dir, List path) async {
  print(path);
  if (path.isEmpty) {
    return [];
  }
  List urls = [];
  // await Firebase.initializeApp();
  for (var element in path) {
  try {
    final file = File(element!.path);

    final ref = FirebaseStorage.instance;
    final fireRef = ref.ref('images').child('$dir/${element.name}');
    final saveImageToStorage = await fireRef.putFile(file);
    String url =  await saveImageToStorage.ref.getDownloadURL();
    urls.add(url);
    print(url);
      
    

  } catch (e) {
    print(e);
    // return [];
  }
    
  }
  print('object');
  return urls;
}