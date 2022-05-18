import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productprocess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:iconly/iconly.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:image_picker/image_picker.dart';

import '../api_callers/merchant.dart';



class MerchantCreateProduct extends StatefulWidget {
  MerchantCreateProduct({Key? key, required this.merchantID, required this.pin,required this.user})
      : super(key: key);

  final String merchantID;
  final User user;
  final String pin;
  

  @override
  State<MerchantCreateProduct> createState() => _MerchantCreateProductState();
}

class _MerchantCreateProductState extends State<MerchantCreateProduct> {
  bool isUsername = true;
  bool hasImage = false;
  late String username;
  late String productName;
  late String contractTitle;
  late String receiverName = 'Unknown';
  late String receiveraddr;
  String image= '';
  late String imageByte;
  late String productDetail;
  late double price;
  final ImagePicker _picker = ImagePicker();
  late String logisticFrom;
  late String logisticTo;
  late int days;
  final TextEditingController _usernameFieldController = TextEditingController();
  final TextEditingController _priceFieldController = TextEditingController();
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _logToFieldController = TextEditingController();
  final TextEditingController _logFromFieldController = TextEditingController();
  bool _lastIndex = false;
  String deliveryDate = 'YYYY-MM-DD';
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepOrange,
      appBar: AppBar(
          title: Text('Product Template'), centerTitle: true, elevation: 0),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(29), topRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
              key: _formKey,
              child: ListView(children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                // ],
                // );
                GestureDetector(
                  onTap: () async {
                    XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
                    final _imageByte = await File(_image?.path ?? '').readAsBytes();
                    // final byte = base64.encode(_imageByte);
                    setState(() {
                      image = _image?.path ?? '';
                      imageByte = jsonEncode(_imageByte);
                      hasImage = _image!.path == '' ? false : true;
                      print(_imageByte);
                      print(_imageByte.length);
                    });
                  },
                  child: Container(
                    height: 200,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          )
                        ]),
                        child: image == '' ? Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image, size: 20),
                              Text('Select Product Image')
                            ],
                          ),
                        ) : Stack(
                          children: [
                            Image.file(File(image), fit: BoxFit.fill, width: double.infinity, height: double.infinity),
                          Container(
                            color: Colors.black.withOpacity(.2),
                            width: double.infinity, height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.image, size: 20, color: Colors.white),
                              Text('Select Product Image', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          ], 
                        )
                        ),
                ),
                
                
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Contract title',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _titleFieldController,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Ex Contract for Hilion Tourchlight',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onChanged: (text) {
                          contractTitle = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The contract title is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Product Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Ex Hilion Tourchlight',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onChanged: (text) {
                          productName = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The product name is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Product Detail',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: null,
                        maxLines: null,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText:
                              'Ex Color: Black\n Material: Plastic\n Lasts for 24 hours with a single charge',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                        ),
                        onChanged: (text) {
                          productDetail = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The Product detail is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Product Price',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: 'NGN',
                          prefixStyle: TextStyle(color: Colors.grey),
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: '0.00',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                        ),
                        onChanged: (text) {
                          price = double.parse(text.trim());
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The Product price is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Shipping Location',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _logFromFieldController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(IconlyBold.location),
                          prefixStyle: TextStyle(color: Colors.grey),
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Ex Lagos',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                        ),
                        onChanged: (text) {
                          logisticFrom = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The delivery location is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5),
                      
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'How many days does delivery take (minimum of 3 days)',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _priceFieldController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixStyle: TextStyle(color: Colors.grey),
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: '4',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                        ),
                        onChanged: (text) {
                          days = int.parse(text.trim());
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || days < 3) {
                            return 'Please set atleast 3 days for delivery';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                
                RoundedLoadingButton(
                  borderRadius: 10,
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  controller: _loginButtonController,
                  child: Text('Create'),
                  onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();

                    if (!hasImage) {
                      showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: const Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("No Image selected"),
                                  content:  Text('Please select product image!.'));
                            });
                                return;
                    }
                    if (!_formKey.currentState!.validate()) {
                      _loginButtonController.reset();
                    } 
                    else {
                      setState(() {
                        _lastIndex = false;
                      });
                      _loginButtonController.reset();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return AlertDialog(
                                title: const Text(
                                  'Creating contract template',
                                  textAlign: TextAlign.center,
                                ),
                                // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                                content: Row(children: const [
                                  Padding(
                                    padding:  EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                  Text('Please wait....', style: TextStyle(fontWeight: FontWeight.w500))
                                ]));
                          });
                      Map a = await createMerchantProductContract(
                          widget.merchantID,
                         widget.user.payload!.accountNumber ?? '',
                          '$days Days',
                          productName,
                          contractTitle,
                          productDetail,
                          imageByte,
                          price.toString(),
                          logisticFrom,
                          widget.pin);
                
                if (a.containsKey('Payload')) {
                        _loginButtonController.success();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: const Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("Template created!"),
                                  content:  Text('Your Product template has been created.'));
                            });
                      } else {
                        _loginButtonController.reset();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: const Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        // Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                  title: const Text("Can't create Template!"),
                                  content:  Text(a['Message']));
                            });

                      }
                    // a.onError((error, stackTrace) {
                    //   print('$error ppppppppppppppppppppppppp');
                    //   _loginButtonController.reset();
                    //   showDialog(
                    //       context: context,
                    //       barrierDismissible: false,
                    //       builder: (context) {
                    //         return AlertDialog(
                    //             actions: [
                    //               TextButton(
                    //                 child: const Text('Okay'),
                    //                 onPressed: () {
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               )
                    //             ],
                    //             title: const Text("Can't Make transfer!"),
                    //             content: Text(error.toString()));
                    //       });
                    //   throw Exception(error);
                    // });
                  }}),
                SizedBox(height: 20)
              ])),
        ),
      ),
    );
  }
}
