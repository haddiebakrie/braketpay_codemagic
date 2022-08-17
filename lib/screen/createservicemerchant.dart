import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productprocess.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/merchant.dart';
import '../brakey.dart';
import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class MerchantCreateService extends StatefulWidget {
  MerchantCreateService({Key? key, required this.merchantID, required this.pin,required this.user, this.fromMerchant=false})
      : super(key: key);

  String merchantID;
  final User user;
  final String pin;
  final bool fromMerchant;


  @override
  State<MerchantCreateService> createState() => _MerchantCreateServiceState();
}

class _MerchantCreateServiceState extends State<MerchantCreateService> {
  bool isUsername = true;
    bool hasImage = false;
  Brakey brakey = Get.put(Brakey());
  late String username;
  late String receiverName = 'Unknown';
  late String receiveraddr;
  late String contractTitle;
  int mainImage = 0;
  int lastPhase = 0;
  late String logisticLoc;
  late int downPayment;
  List image = [];
  String category = '';
  List locations = [];
  late String imageByte;
  late int days;
  String deliveryDate = 'YYYY-MM-DD';
  final _formKey = GlobalKey<FormState>();
  final _stageFormKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();

  List<ServicePhaseField> stages = [];
  String dummyPhaseTitle='';
  String dummyPhaseCost='';
  final ImagePicker _picker = ImagePicker();
  final _dummyController = TextEditingController();
  final _dummyCController = TextEditingController();
  final TextEditingController downPaymentController = TextEditingController();
  final TextEditingController _priceFieldController = TextEditingController();
  final TextEditingController _locFieldController = TextEditingController();
  final TextEditingController _titleFieldController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    _loginButtonController.reset();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          title: Column(
            children: [
              Text('Register your Service'),
              // Text(
              //       // 'You are creating this contract as a ${widget.creatorType}',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 18,
              //       )),
            ],
          ), centerTitle: true, elevation: 0),
      body: Container(
        child: ListView(
          children: [
            // Container(
            //         // margin: Ed,
            
            //         // height: 200,
            //         child: Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: Container(
            //         decoration: ContainerDecoration(),
            //         clipBehavior: Clip.antiAliasWithSaveLayer,
            //         child: Image.asset('assets/secure_your_payments.png'))),
                    
            //         ),
            Container(
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              decoration: ContainerBackgroundDecoration(),
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(children: [
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
                          if (image.length > 0) {
                            return;
                          }
                              if (image.length == 1) {
                                setState(() {
                                  image = [];
                                });
                              }
                              XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
                              if (_image==null) {
                                return;
                              }
                              setState(() {
                                image.add(_image);
                              });
                            },
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(5),
                              decoration: ContainerDecoration(),
                                  child: image.isEmpty ? Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.image, size: 90),
                                        Text('+ Add Service Image', style: TextStyle(fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ) : Stack(
                                    children: [
                                      image.isEmpty ? Container(color: Colors.white,) : Image.file(File(image[mainImage].path), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                    
                                    // Container(
                                    //   color: Colors.black.withOpacity(.2),
                                    //   width: double.infinity, height: double.infinity,
                                    //   child: Column(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: const [
                                    //       Icon(Icons.image, size: 50, color: Colors.white),
                                    //     Text('+ Change Product Image', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                    //     ],
                                    //   ),
                                    // ),
                                    ], 
                                  )
                                  ),
                        ),      
                        SizedBox(height:10),
                        Text('You can add up to 5 images (only png, jpg and jpeg are accepted)', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),         
                        SizedBox(height:10),    
                        Visibility(
                          visible: image.isNotEmpty,
                          child: Container(
                            height: 80,
                            child: Expanded(
                              child: ListView.builder(
                                // shrinkWrap: true,
                                itemCount: image.length.clamp(1, 5)+1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                print(index);
                                if (index < image.length) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          mainImage = index;
                                        });
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 70,
                                        margin: EdgeInsets.all(3).copyWith(right:9),
                                        decoration: ContainerDecoration().copyWith(
                                          border: Border.all(color: index == mainImage ? Colors.blue : Colors.transparent, width: 3)
                                        ),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Stack(
                                                      
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              // padding: EdgeInsets.all(10),
                                              child: Image.file(File(image[index].path), height: 60, width: 70),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (mainImage==index) {
                                                    mainImage = (index - 1).clamp(0, 5);
                                                  }
                                                image.removeAt(index);
                                                  
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  
                                                  borderRadius: BorderRadius.circular(20)),
                                                child: Icon(Icons.delete, color: Colors.red, size: 14)),
                                            ),
                                          ],
                                        ),
                                                              ),
                                    );
                        
                                } else {
                                    return InkWell(
                                      onTap: () async {
                                          XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
                                          if (_image==null) {
                                            return;
                                          }
                                          setState(() {
                                            image.add(_image);
                                          });
                                        },
                                      child: Container(
                                        height: 60,
                                        width: 70,
                                      margin: EdgeInsets.all(3),
                                        decoration: ContainerDecoration(),
                                        child: Center(child: Text('+ Add Image', textAlign: TextAlign.center, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.grey))),),
                                    );
                                }
                              } 
                              
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:20),    
                        Visibility(
                          visible: image.length > 1,
                          child: Text('* The highlighted image is your main Service image, click on a different image to change.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 11))),         

                        SizedBox(height:20),
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
                              cursorColor: Colors.grey,
                              maxLines: null,
                              minLines: null,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Eg. Ecommerce website design\n',
                                hintStyle: TextStyle(
                                            fontWeight: FontWeight.w600),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
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
                      margin: const EdgeInsets.symmetric(vertical: 10),
                     child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      
                                  child: const Text(
                                    'Service Category',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
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
                                            category = e;
                                          },
                                        dropdownSearchDecoration: InputDecoration(
                                          hintText: 'Select Category',
                                          border: InputBorder.none,
                                          // filled: true,
                                        ),
                                        dropdownBuilder: (context, widget) {
                                            return Text(
                                              widget + '\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            );
                                          },
                                          mode: Mode.BOTTOM_SHEET,
                                          searchDelay: Duration.zero,
                                        items: serviceCategories,
                                        selectedItem: category != '' ? category : 'Select Category'
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                   ), 
                      
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Form(
                          key: _stageFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Service rendering phases (minimum of 3 phase)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 15),
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey,
                                  margin: EdgeInsets.symmetric(vertical: 10)),
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                    itemCount: stages.length,
                                    itemBuilder: (context, index) {
                                      print("${index}, ${stages.length}");
                                      if (index+1 == stages.length) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                          stages[index],
                                          TextButton(child: Text('Delete'),onPressed: (){

                                            setState(() {
                                              stages.removeLast();
                                              lastPhase--;
                                            });

                                          })
                                        ],);
                                      }
                                      return stages[index];
                                    },),
                              ),

                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Rendering Phase ${lastPhase + 1}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 15),
                                ),
                              ),
                        
                              TextFormField(
                                controller: _dummyController,
                                cursorColor: Colors.grey,
                                maxLines: null,
                                minLines: null,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: 'Puchasing a domain\n',
                                  hintStyle: TextStyle(
                                            fontWeight: FontWeight.w600),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.all(10),
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    dummyPhaseTitle = text.trim();
                                    
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field can't be empty";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _dummyCController,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                maxLines: null,
                                minLines: null,
                                inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: 'Cost of phase\n',
                                  hintStyle: const TextStyle(
                                              color: Colors.grey, fontWeight: FontWeight.w600),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.all(10),
                                ),
                                onChanged: (text) {
                                  setState(() {
                                  dummyPhaseCost = text.trim();
                                    
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field can't be empty";
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: Text('Add Phase'),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          Color.fromARGB(255, 255, 30, 0)
                                      ),
                                    foregroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 255,255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (!_stageFormKey.currentState!.validate()) {

                                      } else {
                                        setState(() {
                                        stages.add(ServicePhaseField(index:lastPhase, phaseTitle:dummyPhaseTitle, phaseCost:dummyPhaseCost));
                                        lastPhase++;
                                        _dummyController.clear();
                                        _dummyCController.clear();
                                        });
                                      }


                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                                'Location',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              controller: _locFieldController,
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.streetAddress,
                              maxLines: null,
                              minLines: null,
                              decoration: const InputDecoration(
                                // prefixIcon: Icon(IconlyBold.location),
                                // prefixStyle: TextStyle(color: Colors.grey),
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Eg. Lagos\n',
                                hintStyle:
                                            const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                                          contentPadding: EdgeInsets.all(10),

                              ),
                              onChanged: (text) {
                                logisticLoc = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'The service location is required';
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
                                'Advance payment',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              controller: downPaymentController,
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                              maxLines: null,
                              minLines: null,
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: nairaSign() + ' 0.00\n',
                                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                                          contentPadding: EdgeInsets.all(10),

                              ),
                              onChanged: (text) {
                                downPayment = int.parse(text.trim());
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Advance payment is required';
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
                                'How many days does delivery take (minimum of 3 days)',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              controller: _priceFieldController,
                              cursorColor: Colors.grey,
                              minLines: null,
                              maxLines: null,
                              inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                prefixStyle: TextStyle(color: Colors.grey),
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: '4\n',
                                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
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
                      SizedBox(height: 20),
                      RoundedLoadingButton(
                        borderRadius: 10,
                        color: Theme.of(context).primaryColor,
                        elevation: 0,
                        controller: _loginButtonController,
                        child: Text('Create'),
                        onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();

                          if (!_formKey.currentState!.validate()) {
                            _loginButtonController.reset();
                          }else if (stages.length < 3) {
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
                                                  const Text("Minimum stages not met!"),
                                              content: const Text(
                                                  'Please add at least 3 stages'));
                                        });

                          }

                          else {
                            Map _stages = {};
                            stages.forEach((ServicePhaseField element) {
                              _stages.addAll({'Stage_${element.index+1}':{"about_stage":element.phaseTitle, "cost_of_stage":double.parse(element.phaseCost)}});
                            },); 

                          StreamController<ErrorAnimationType> _pinErrorController =
                          StreamController<ErrorAnimationType>();
                          final _pinEditController = TextEditingController();
                          Map? pin =
                              await askPin(_pinEditController, _pinErrorController);
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
                                      'Verifying merchant',
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
                          Future<Map> merchant = getMerchant(widget.user.payload!.walletAddress??'', pin['pin'], widget.user.payload!.password??'');
                          // print(brakey.pin);
                          merchant.then(
                            (value) async {

                          print(value);
                          if (value['Status']=='successful') {
                            setState(() {
                            widget.merchantID = value['Payload']['merchant_id'];

                            });
                            print(widget.merchantID);
                          } else {
                            if (value['Response code'] == 500) {
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
                                      title: const Text("Setup your Business!"),
                                      content:  Text('You need to setup a business account to register template'));
                                });
                                return;
                            }
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
                                      title: const Text("Couldn't Fetch Merchant!"),
                                      content:  Text(toTitleCase(value['Message']??value['Messagee'])));
                                });
                                return;
                          }
                          // image.forEach((element) { })
                          Future<List> imageLink = uploadToFireStore('merchant-service/${widget.merchantID}', image);
                          imageLink.whenComplete((){
                        imageLink.then((value) async {
                          print('$value asdflkj');
                         
                          if (value.isEmpty) {
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
                                      title: const Text("Couldn't Add Service Image!"),
                                      content:  Text(toTitleCase('')));
                                });
                          }
                          Get.close(1);

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                    title: const Text(
                                      'Registering Service',
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
                          Map loc = {};
                          for (int i=0; i < locations.length; i++) {
                            Map n = {'state_${i+1}':locations[i].values.first};
                            loc.addAll(n);
                            // print(n);

                          }
                          Map links = {};
                          for (int i=0; i < value.length; i++) {
                            Map n = {'link_${i+1}':value[i]};
                            links.addAll(n);
                            print(n);

                          }
                          Map a = await createMerchantServiceContract(
                              widget.merchantID,
                             widget.user.payload!.accountNumber ?? '',
                              '$days Days',
                              _stages.toString(),
                              downPayment.toString(),
                              contractTitle,
                              links,
                              pin['pin'],
                              category);
                  
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
                                            brakey.refreshUserDetail();
                                          },
                                        )
                                      ],
                                      title: const Text("Service Registered!"),
                                      content:  Text('Your Service has been created.'));
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
                                      title: const Text("Can't register Service!"),
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
                          }
                          );});
                     
                          }
                          
                          );
                     
                          }
                        },
                      ),
                      SizedBox(height: 50)

                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
class ServicePhaseField extends StatelessWidget {
  ServicePhaseField({Key? key, required this.index, required this.phaseTitle, required this.phaseCost}) : super(key: key);

  int index;
  String phaseTitle;
  String phaseCost;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Rendering Phase ${index + 1}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            TextFormField(
              initialValue: phaseTitle,
              maxLines: null,
              minLines: null,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(24, 158, 158, 158),
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                hintText: 'Purchasing a domain\n',
                hintStyle: const TextStyle(
                                              color: Colors.grey, fontWeight: FontWeight.w600),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                contentPadding:
                    EdgeInsets.all(10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "This field can't be empty";
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: phaseCost,
              cursorColor: Colors.grey,
              keyboardType: TextInputType.number,
              inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
              minLines: null,
              maxLines: null,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(24, 158, 158, 158),
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                hintText: 'Cost of phase\n',
                hintStyle: const TextStyle(
                                              color: Colors.grey, fontWeight: FontWeight.w600),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                contentPadding:
                    EdgeInsets.all(10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "This field can't be empty";
                }
                return null;
              })]),
    );
  }
}