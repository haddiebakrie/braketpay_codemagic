import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productprocess.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:image_picker/image_picker.dart';

import '../api_callers/loan.dart';
import '../api_callers/merchant.dart';
import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';



class MerchantCreateLoan extends StatefulWidget {
  MerchantCreateLoan({Key? key, required this.merchantID, required this.pin,required this.user})
      : super(key: key);

  final String merchantID;
  final User user;
  final String pin;
  

  @override
  State<MerchantCreateLoan> createState() => _MerchantCreateLoanState();
}

class _MerchantCreateLoanState extends State<MerchantCreateLoan> {
  bool isUsername = true;
  bool hasImage = false;
  List loanTypes = [
    'Philantropic Loan',
    'Business Loan',
    'Health Loan',
    'Academic Loan',
    'Mortgage Loan',
    'Personal Loan',
  ];
  late String loanName;
  late String loanPeriod;
  String loanType = '';
  bool loanVisibility = false;
  double minPrice = 0;
  double maxPrice = 0;
  late String interest;
  late String contractTitle;
  late String receiverName = 'Unknown';
  late String receiveraddr;
  String image= '';
  late String imageByte;
  late String loanDetail;
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
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          title: Text('Loan Template'), centerTitle: true, elevation: 0),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        decoration: ContainerBackgroundDecoration(),
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
                InkWell(
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
                          padding: EdgeInsets.all((30)),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image, size: 40, color: Colors.grey),
                              Text('Upload a Loan Picture that describes the organization', textAlign: TextAlign.center,)
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
                              Text('Select Loan Image', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          ], 
                        )
                        ),
                ),
                SizedBox(height:10),
                
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Loan title',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
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
                          hintText: "Ex Farmer's Loan",
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
                          'Loan Description',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
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
                              'Ex A flexible loan for farmers\n\n\n\n',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                        ),
                        onChanged: (text) {
                          loanDetail = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The Loan detail is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                
                Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    
                                child: const Text(
                                  'Loan type',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 15),
                                ),
                              ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    margin: EdgeInsets.symmetric(vertical:10),
                                    child: DropdownSearch<dynamic>(
                                        onChanged:(e) {
                                          loanType = e.toLowerCase();
                                        },
                                      dropdownSearchDecoration: InputDecoration(
                                        hintText: 'Select Type',
                                        border: InputBorder.none,
                                        // filled: true,
                                      ),
                                      // showSearchBox: true,
                                      // showClearButton: true,
                                      mode: Mode.BOTTOM_SHEET,
                                      searchDelay: Duration.zero,
                                      items: loanTypes,
                                      selectedItem: loanType != '' ? toTitleCase(loanType) : 'Select Type'
                                    ),
                                  ),
                                ],
                              ),]),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Loan Period (months)',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText:
                              '2',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        onChanged: (text) {
                          loanPeriod = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The Loan period is required';
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
                          'Loan Interest',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText:
                              'Ex 10',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        onChanged: (text) {
                          interest = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The Loan Interest is required';
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
                          'Minimum amount',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ),
                        TextFormField(
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                  // textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 60,
                                ),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  icon: Text(nairaSign(), style:TextStyle(fontSize: 40, color: Colors.grey)),
                                  prefixStyle: TextStyle(color: Colors.grey),
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  // filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                    color: Colors.grey
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding: EdgeInsets.zero
                                ),
                                onChanged: (text) {
                                  minPrice = text == '' ? 0 : double.parse(text.trim());
                                  // setState(() {                                    
                                  //   _priceTextController.text = price.toString();
                                  // });
                                
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'The Minimum Loan amount is required';
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
                          'Maximum amount',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ),
                        TextFormField(
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                  // textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 60,
                                ),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  icon: Text(nairaSign(), style:TextStyle(fontSize: 40, color: Colors.grey)),
                                  prefixStyle: TextStyle(color: Colors.grey),
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  // filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                    color: Colors.grey
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding: EdgeInsets.zero
                                ),
                                onChanged: (text) {
                                  maxPrice = text == '' ? 0 : double.parse(text.trim());
                                  // setState(() {                                    
                                  //   _priceTextController.text = price.toString();
                                  // });
                                
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'The Maximum Loan amount is required';
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
                    if (widget.merchantID == '') {
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

                                      },
                                    )
                                  ],
                                  title: const Text("Failed"),
                                  content:  Text('Create Lender Contract from Merchant Page!.'));
                            });
                                return;
                      return;
                    }

                    if (!hasImage) {
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

                                      },
                                    )
                                  ],
                                  title: const Text("No Image selected"),
                                  content:  Text('Please select loan image!.'));
                            });
                                return;
                    }
                    if (loanType == '') {
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

                                      },
                                    )
                                  ],
                                  title: const Text("Invalid Loan type"),
                                  content:  Text('Please select Loan type!.'));
                            });
                                return;
                    }
                    if (maxPrice < minPrice) {
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
                                      },
                                    )
                                  ],
                                  title: const Text("Invalid Loan range"),
                                  content:  Text('Loan minimum amount must be less than maximum amount!.'));
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
                      StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                                    final _pinEditController = TextEditingController();
                                      Map? pin = await askPin(_pinEditController, _pinErrorController);
                                print(pin);
                                if (pin == null || !pin.containsKey('pin')) {
                                  _loginButtonController.reset();
                                  return;
                                }
                      _loginButtonController.reset();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return AlertDialog(
                                title: const Text(
                                  'Creating Loan template',
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
                      Map a = await createLoanContract(
                          widget.merchantID,
                         widget.user.payload!.accountNumber ?? '',
                         widget.user.payload!.password??'',
                          {"max":maxPrice, "min":minPrice},
                          contractTitle,
                          loanDetail,
                          interest,
                          loanPeriod,
                          imageByte,
                          loanVisibility,
                          loanType,
                          pin['pin'],
                          );
                
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
                                  content:  Text('Your Loan template has been created.'));
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
