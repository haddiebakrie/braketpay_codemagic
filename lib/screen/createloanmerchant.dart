import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productprocess.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:image_picker/image_picker.dart';

import '../api_callers/loan.dart';
import '../api_callers/merchant.dart';
import '../brakey.dart';
import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';
import 'manager.dart';



class MerchantCreateLoan extends StatefulWidget {
  const MerchantCreateLoan({Key? key, required this.merchantID, required this.pin,required this.user})
      : super(key: key);

  final String merchantID;
  final User user;
  final String pin;
  

  @override
  State<MerchantCreateLoan> createState() => _MerchantCreateLoanState();
}

class _MerchantCreateLoanState extends State<MerchantCreateLoan> {
  Brakey brakey = Get.put(Brakey());
  bool isUsername = true;
  int mainImage = 0;
  bool hasImage = false;
  List loanTypes = [
    // 'Philantropic Loan',
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
  int repay = 1;
  late String interest = '0';
  late String contractTitle;
  late String receiverName = 'Unknown';
  late String receiveraddr;
  List image = [];
  late String imageByte;
  final ImagePicker _picker = ImagePicker();
  String loanCategory = 'non philantropic';
  late String loanDetail;
  late double price;
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
    _loginButtonController.reset();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          title: const Text('Register Loan'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
               
            Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Container(
                          decoration: ContainerDecoration(),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child:
                              Image.asset('assets/avoid_loan_default.png')),
                    ),
            Container(
              width: double.infinity,
              decoration: ContainerBackgroundDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
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
                                  Text('+ Add Image', style: TextStyle(fontWeight: FontWeight.bold))
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
                                  child: Center(child: Flexible(child: Text('+ Add Image', textAlign: TextAlign.center, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.grey)))),),
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
                    child: Text('* The highlighted image is your main Image, click on a different image to change.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 11))),         

                  SizedBox(height:20),
                      const SizedBox(height:10),
                      
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Loan title',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              controller: _titleFieldController,
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.multiline,
                                minLines: null,
                                maxLines: null,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: "Eg. Farmer's Loan\n",
                                hintStyle:
                                      TextStyle(fontWeight: FontWeight.w600),
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
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Loan Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              maxLines: null,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. A Flexible loan for farmers\n\n\n',
                                    hintStyle:
                                      TextStyle(fontWeight: FontWeight.w600),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              onChanged: (text) {
                                loanDetail = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'The Loan Description is required';
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
                                            fontWeight: FontWeight.w600, fontSize: 15),
                                      ),
                                    ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal:10),
                                          decoration: BoxDecoration(
                                          color: const Color.fromARGB(24, 158, 158, 158),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          margin: const EdgeInsets.symmetric(vertical:10),
                                          child: DropdownSearch<dynamic>(
                                              onChanged:(e) {
                                                loanType = e.toLowerCase();
                                              },
                                            dropdownSearchDecoration: const InputDecoration(
                                              hintText: 'Select Type',
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
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Loan Period (months)',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                            const Text('Enter the payment tenor ie How many months the borrower is expected to payback untill the loan is due', style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
                                          const SizedBox(height:10),
                            TextFormField(
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.number,
                                      minLines: null,
                                      maxLines: null,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. 2\n',
                                    hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
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
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Borrower starts repayment after (months)',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.grey,
                              minLines: null,
                                    maxLines: null,
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
                                    'Eg. 2\n',
                                    hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              onChanged: (text) {
                                repay = int.parse(text.trim());
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                if (int.parse(value) == 0) {
                                  return 'Grace period should be atleast 1 month';
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
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Loan Category',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                            const SizedBox(height:10),
                                                  
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal:10),
                                          decoration: BoxDecoration(
                                          color: const Color.fromARGB(24, 158, 158, 158),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          margin: const EdgeInsets.only(bottom:10),
                                          child: DropdownSearch<dynamic>(
                                              onChanged:(e) {
                                                interest = '0';
                                                setState(() {
                                                loanCategory = e.toLowerCase();
                                                  
                                                });
                                              },
                                              dropdownBuilder: (context, widget) {
                                            return Text(
                                              widget + '\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            );
                                          },
                                            dropdownSearchDecoration: const InputDecoration(
                                              hintText: 'Select Category',
                                              border: InputBorder.none,
                                              // filled: true,
                                            ),
                                            // showSearchBox: true,
                                            // showClearButton: true,
                                            mode: Mode.MENU,
                                            searchDelay: Duration.zero,
                                            items: const ['Philantropic Loan', 'Non Philantropic'],
                                            selectedItem: loanCategory.capitalize
                                          ),
                                        ),
                                      ],
                                    ),]),
                      
                            Visibility(
                              visible: loanCategory != 'philantropic loan',
                              child: TextFormField(
                                enabled: loanCategory == 'non philantropic',
                                cursorColor: Colors.grey,
                                maxLines: null,
                                minLines: null,
                                keyboardType: TextInputType.number,
                                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly, FilteringTextInputFormatter.allow('.')],
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText:
                                      'Enter your interest value\n',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w600),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                ),
                                onChanged: (text) {
                                  setState(() {
                                  interest = text.trim();
                                    
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'The Loan Interest is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height:20),
                            Container(height: 1, color: Colors.grey),
                            ListTile(enabled: false, contentPadding: EdgeInsets.zero, minVerticalPadding: 0,title: const Text('Braket Interest'), trailing: Text(loanCategory == 'philantropic loan' ? '7%' : '5%', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),),
                            ListTile(contentPadding: EdgeInsets.zero, minVerticalPadding: 0,title: const Text('Total Interest'), trailing: Text((double.parse(interest==''? '0':interest) + (loanCategory == 'philantropic loan' ? 7 : 5)).toString()+'%', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),)
                          ],
                        ),
                      ),
                      Container(height: 1, color: Colors.grey),
                      const SizedBox(height:20),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Minimum Lending amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                              TextFormField(
                                      cursorColor: Colors.grey,
                                      keyboardType: TextInputType.number,
                                        // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 35,
                                      ),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, ],
                                      decoration: InputDecoration(
                                        icon: Text(nairaSign(), style:const TextStyle(fontSize: 20, color: Colors.grey)),
                                        prefixStyle: const TextStyle(color: Colors.grey),
                                        fillColor: const Color.fromARGB(24, 158, 158, 158),
                                        // filled: true,
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                        hintText: '0.00',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey
                                        ),
                                        border: const OutlineInputBorder(
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
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Maximum Lending amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                              TextFormField(
                                      cursorColor: Colors.grey,
                                      keyboardType: TextInputType.number,
                                        // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 35,
                                      ),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, ],
                                        decoration: InputDecoration(
                                        icon: Text(nairaSign(), style:const TextStyle(fontSize: 20, color: Colors.grey)),
                                        prefixStyle: const TextStyle(color: Colors.grey),
                                        fillColor: const Color.fromARGB(24, 158, 158, 158),
                                        // filled: true,
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                        hintText: '0.00',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey
                                        ),
                                        border: const OutlineInputBorder(
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
                      const SizedBox(height: 90)
         
                      
                    ])),
              ),
            ),
          
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: 
                      Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                color: Get.isDarkMode ? const Color.fromARGB(255, 42, 42, 59) : Colors.white
                ),
                        child: RoundedLoadingButton(
                          borderRadius: 10,
                          color: Theme.of(context).primaryColor,
                          elevation: 0,
                          controller: _loginButtonController,
                          child: const Text('Create'),
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
                                            TextButton(child: 
                                            const Text('Cancel'),
                                            onPressed: () {
                                              Get.close(1);
                                            },
                                            ),
                                            TextButton(
                                              child: const Text('Okay'),
                                              onPressed: () {
                                                Get.offUntil(MaterialPageRoute(
                                            builder: (_) => 
                                            Manager(user: widget.user, pin: widget.pin)), (route) => false);
                                            brakey.changeManagerIndex(3);
      
                                              },
                                            ),
                                            

                                          ],
                                          title: const Text("Failed"),
                                          content:  const Text('Create Lender Contract from Business Page.'));
                                    });
                                        return;
                            }
      
                            if (image.isEmpty) {
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
                                          content:  const Text('Please select loan image!.'));
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
                                          content:  const Text('Please select Loan type!.'));
                                    });
                                        return;
                            }
                            if (loanCategory == '') {
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
                                          title: const Text("Invalid Loan Category"),
                                          content:  const Text('Please select Loan Category!.'));
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
                                          content:  const Text('Loan minimum amount must be less than maximum amount!.'));
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
                              // _loginButtonController.reset();
                              Future<List> imageLink = uploadToFireStore('merchant-loan/${widget.merchantID}', image);
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
                                      title: const Text("Couldn't Add Product Image!"),
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
                                  Map links = {};
                          for (int i=0; i < value.length; i++) {
                            Map n = {'link_${i+1}':value[i]};
                            links.addAll(n);
                            print(n);};
                              Map a = await createLoanContract(
                                  widget.merchantID,
                                 widget.user.payload!.accountNumber ?? '',
                                 widget.user.payload!.password??'',
                                  {"max":maxPrice, "min":minPrice},
                                  contractTitle,
                                  loanDetail,
                                 ( double.parse(interest==''? '0':interest) + (loanCategory == 'philantropic loan' ? 7 : 5)).toString(),
                                  loanPeriod,
                                  links,
                                  loanVisibility,
                                  loanType,
                                  pin['pin'],
                                  loanCategory,
                                  repay
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
                                                brakey.refreshUserDetail();
                                                
                                              },
                                            )
                                          ],
                                          title: const Text("Loan Registered!"),
                                          content:   Text(toTitleCase(a['Message'])));
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
                                          content:  Text(toTitleCase(a['Message'])));
                                    });
      
                              }
                          });});};
  }),
                      
    ));
  }
}
