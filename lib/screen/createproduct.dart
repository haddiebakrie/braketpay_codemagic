import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productprocess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:iconly/iconly.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreateProduct extends StatefulWidget {
  CreateProduct({Key? key, required this.creatorType, required this.pin,required this.user})
      : super(key: key);

  final String creatorType;
  final User user;
  final String pin;
  

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  bool isUsername = true;
  late String username;
  late String contractTitle;
  late String receiverName = 'Unknown';
  late String receiveraddr;
  late String productDetail;
  late double price;
  late String logisticFrom;
  late String logisticTo;
  late double shipFee;
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
          title: Text('Product Contract'), centerTitle: true, elevation: 0),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(29), topRight: Radius.circular(20))),
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                Text(
                    'You are creating this contract as a ${widget.creatorType}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    )),
                Container(
                    color: Colors.grey.withAlpha(20),
                    height: 40,
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: isUsername
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 30, 0))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(0, 255, 255, 255)),
                            ),
                            child: Text(
                              'Username',
                              style: TextStyle(
                                color: isUsername
                                    ? Colors.white
                                    : Colors.deepOrange,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isUsername = true;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: !isUsername
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 255, 30, 0))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(0, 255, 255, 255)),
                            ),
                            child: Text(
                              'Wallet Address',
                              style: TextStyle(
                                color: !isUsername
                                    ? Colors.white
                                    : Colors.deepOrange,
                              ),
                            ),
                            onPressed: () {
                              // setState(() {
                              // isUsername = false;
                              // }
                              // );
                            },
                          ),
                        ),
                      ],
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _usernameFieldController,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          prefixText: '@',
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'username',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onChanged: (text) {
                          username = text.trim();
                          Future<Map<String, dynamic>> fullname =
                              getUserInfo(text);
                          fullname.then((value) {
                            if (value.containsKey('Payload')) {
                              if (value['Payload']['wallet_address'] ==
                                  widget.user.payload!.walletAddress) {
                                setState(() {
                                  receiverName =
                                      "You can't create a contract with yourself";
                                });
                              } else {
                                setState(() {
                                  receiverName = value['Payload']['fullname'];
                                  receiveraddr =
                                      value['Payload']['wallet_address'];

                                  // print(value);
                                });
                              }
                            } else {
                              setState(() {
                                receiverName =
                                    'This username does not match any user';
                              });
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The second party is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text('Receiver: $receiverName'),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
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
                  margin: const EdgeInsets.symmetric(vertical: 15),
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
                  margin: const EdgeInsets.symmetric(vertical: 15),
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
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Logistic Detail',
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
                          hintText: 'Shipping from: Ex Lagos',
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
                      TextFormField(
                        controller: _logToFieldController,
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
                          hintText: 'Shipping to: Ex Ogun',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                        ),
                        onChanged: (text) {
                          logisticTo = text.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The delivery destination is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Cost of Shipping',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _priceFieldController,
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
                          shipFee = double.parse(text.trim());
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The cost of shipping is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Choose delivery date',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _loginButtonController.reset();
                          FocusManager.instance.primaryFocus?.unfocus();
                          DatePicker.showDatePicker(context,
                              minTime: DateTime.now(),
                              currentTime: deliveryDate == 'YYYY-MM-DD'
                                  ? DateTime.now()
                                  : DateTime.tryParse(deliveryDate),
                              maxTime: DateTime(2101), onConfirm: (date) {
                            setState(() {
                              deliveryDate =
                                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            });
                          });

                          print(deliveryDate);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          color: Color.fromARGB(24, 158, 158, 158),
                          child: Text(deliveryDate,
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ),
                RoundedLoadingButton(
                  borderRadius: 10,
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  controller: _loginButtonController,
                  child: Text('Create'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      _loginButtonController.reset();
                    } else if (receiverName == 'This username does not match any user' || receiverName == "You can't create a contract with yourself" || receiverName == 'Unknown') {
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
                                        title:
                                            const Text("Invalid Receiver username!"),
                                        content: const Text(
                                            'Enter a valid username'));
                                  });
                    } else if (deliveryDate == 'YYYY-MM-DD') {
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
                                        title:
                                            const Text("Delivery date not set!"),
                                        content: const Text(
                                            'Please choose a delivery date'));
                                  });
                    } 
                    else {
                      setState(() {
                        _lastIndex = false;
                      });
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return AlertDialog(
                                title: Text(
                                  'A PRODUCT CONTRACT \nWITH\n ${receiverName.toUpperCase()}',
                                  textAlign: TextAlign.center,
                                ),
                                // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                                content: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                  Text('Creating Contract....', style: TextStyle(fontWeight: FontWeight.w500))
                                ]));
                          });
                      Future<bool> a = createProductContract(
                          widget.creatorType.toLowerCase(),
                          widget.creatorType.toLowerCase() == 'buyer'
                              ? widget.user.payload!.walletAddress ?? ''
                              : receiveraddr,
                          widget.creatorType.toLowerCase() == 'seller'
                              ? widget.user.payload!.walletAddress ?? ''
                              : receiveraddr,
                          widget.user.payload!.bvn ?? '',
                          contractTitle,
                          productDetail,
                          price.toString(),
                          shipFee.toString(),
                          logisticFrom,
                          logisticTo,
                          deliveryDate,
                          widget.pin);
                      a.then((value) {
                        if (value) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      });
                      a.onError((error, stackTrace) =>
                          // print(error),
                          throw Exception('$error'));
                      _loginButtonController.reset();

                    }
                  },
                ),
                SizedBox(height: 20)
              ]),
            )),
      ),
    );
  }
}
