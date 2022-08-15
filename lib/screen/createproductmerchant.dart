import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productprocess.dart';
import 'package:braketpay/screen/productprompt.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:image_picker/image_picker.dart';

import '../api_callers/merchant.dart';
import '../brakey.dart';
import '../ngstates.dart';
import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';



class MerchantCreateProduct extends StatefulWidget {
  MerchantCreateProduct({Key? key, required this.merchantID, required this.pin,required this.user, this.fromMerchant=false})
      : super(key: key);

  String merchantID;
  final User user;
  final String pin;
  final bool fromMerchant;
  

  @override
  State<MerchantCreateProduct> createState() => _MerchantCreateProductState();
}

class _MerchantCreateProductState extends State<MerchantCreateProduct> {
  Brakey brakey = Get.put(Brakey());
  bool isUsername = true;
  bool hasImage = false;
  late String username = '';
  late String productName = '';
  late String contractTitle = '';
  late String receiverName = 'Unknown';
  late String receiveraddr = '';
  String category = '';
  List locations = [];
  List image = [];
  late String imageByte;
  final ImagePicker _picker = ImagePicker();
  late String productDetail = '';
  late double price;
  late String logisticFrom = '';
  late String logisticTo = '';
  late int days = 0;
  int mainImage = 0;
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
  final RoundedLoadingButtonController _logisticBtnController =
  RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Theme.of(context).primaryColor),
                Image.asset('assets/braket-bg_grad-01.png', height: 300, fit: BoxFit.cover, width: double.infinity,),

        Scaffold(
          extendBody: true,
backgroundColor: Colors.transparent,
          appBar: AppBar(
backgroundColor: Colors.transparent,
          
              title: Text('Register your Product'), elevation: 0),
          body: Container(
            child: Form(
                key: _formKey,
                child: ListView(children: [
                  Container(
                    // margin: Ed,
            
                    // height: 200,
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: ContainerDecoration(),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset('assets/secure_your_payments.png'))),
                    
                    ),
                  Container(
            decoration: ContainerBackgroundDecoration(),
            padding: EdgeInsets.only(top: 20),
            width: double.infinity,
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
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
                    Visibility(
                      visible: !widget.fromMerchant,
                      child: Container(
                          color: Colors.grey.withAlpha(50),
                          height: 40,
                          margin: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                            Color.fromARGB(0, 255, 255, 255))
                                       
                                  ),
                                  child: Text(
                                    'One-off',
                                    style: TextStyle(
                                      color: adaptiveColor,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(()=> ProductPrompt(creatorType: 'Seller', user: widget.user));
                                    
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                            Color.fromARGB(255, 255, 30, 0))

                                  ),
                                  child: Text(
                                    'Continuous',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600

                                    ),
                                  ),
                                  onPressed: () {
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                   
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
                                  Text('+ Add Product Image', style: TextStyle(fontWeight: FontWeight.bold))
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
                    child: Text('* The highlighted image is your main Product image, click on a different image to change.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 11))),         

                  SizedBox(height:20),    
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Contract title',
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
                              hintText: 'Eg. Contract for Iphone 13 Sale\n\n',
                              hintStyle: TextStyle(fontWeight: FontWeight.w500),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Product Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          TextFormField(
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
                              hintText: 'Eg. Apple IPhone 13 Retina XDR... \n\n',
                              hintStyle: TextStyle(fontWeight: FontWeight.w500),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
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
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Product Detail',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          // Markdo
                          MarkdownTextInput(
                            (text) {
                              productDetail = text.trim();
                            },
                            '',
                            actions: [
                              MarkdownType.bold,
                              MarkdownType.title, 
                              MarkdownType.strikethrough, 
                              MarkdownType.link, 
                              MarkdownType.list, 
                              MarkdownType.image, 
                               ],
                            // keyboardType: TextInputType.multiline,
                            // minLines: null,
                            maxLines: null,
                            // cursorColor: Colors.grey,
                            // decoration: const InputDecoration(
                            //   hintMaxLines: null,
                              
                            //   fillColor: Color.fromARGB(24, 158, 158, 158),
                            //   filled: true,
                            //   focusedBorder: OutlineInputBorder(
                            //       borderSide: BorderSide.none,
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(10))),
                                      
                            //   hintText:
                            //       'Eg. 12MP TrueDepth front camera \nwith Night mode, 4K Dolby Vision \nHDR recording\n',
                            //     hintStyle: TextStyle(fontWeight: FontWeight.w500),
                            //   border: OutlineInputBorder(
                            //       borderSide: BorderSide.none,
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(10))),
                            //   contentPadding: EdgeInsets.symmetric(
                            //       horizontal: 10, vertical: 10),
                            // ),
                            // 
                            validators: (value) {
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
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Product Price',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          TextFormField(
                            cursorColor: Colors.grey,
                            keyboardType: TextInputType.number,
                              // keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: null,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, ],

                              style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              prefixStyle: TextStyle(color: Colors.grey),
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: '${nairaSign()} 0.00\n',
                              hintStyle: TextStyle(fontWeight: FontWeight.w500),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
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
                      margin: const EdgeInsets.symmetric(vertical: 10),
                     child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      
                                  child: const Text(
                                    'Product Category',
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
                                        items: productCategories,
                                        selectedItem: category != '' ? category : 'Select Category'
                                      ),
                                    ),
                                  ],
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
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Where are you Shipping from',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          TextFormField(
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
                              hintText: 'Eg. Lagos\n',
                              hintStyle: TextStyle(fontWeight: FontWeight.w500),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            onChanged: (text) {
                              logisticFrom = text.trim();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'The field is required';
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
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Delivery Locations',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(children: [
                              Text('Choose the areas you deliver to and set the delivery fee for each area.',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              Visibility(
                                visible: locations.isEmpty,
                                child: Row(
                                  children: [
                                    Text('No delivery Area added.', style: TextStyle(fontStyle: FontStyle.italic))
                                  ]
                                ),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: locations.length,
                              itemBuilder: 
                              (builder, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical:5),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(locations[index].values.first['name']+" (in ${locations[index].values.first['delivery_days']}days)")),
                                      Text("${nairaSign()}${locations[index].values.first['amount']}"),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity(horizontal: -4),
                                        iconSize: 17
                                        ,onPressed: () {
                                        setState(() {
                                        locations.removeAt(index);
                                          
                                        });
                                      }, icon: Icon(Icons.delete, color: Colors.redAccent,))
                                    ],
                                  ),
                                );
                              }
                              ),
                              SizedBox(height:10),
                              Row(
                                children: [
                                  Expanded(child: SizedBox()),
                                  RoundButton(
                                    text:'Add Area',
                                    width: 100,
                                    color1: Colors.black,
                                    color2: Colors.black,
                                    onTap: () {
                                      Get.bottomSheet(
                                            BottomSheet(
                                              backgroundColor: Colors.transparent,
                                              onClosing: () {}, builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, changeState) {
                                                String state = '';
                                                String amount = '';
                                                String area = 'All';
                                                String delivery_time = 'All';
                                                final _formValidator = GlobalKey<FormState>();
                                                String deliveryTime = '';
                                                  return Container(
                                                    padding: const EdgeInsets.all(20),
                                                      decoration: ContainerBackgroundDecoration(),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                            width: 60,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10)),
                                          ),
                                          // const SizedBox(height:10),
                                          // Icon(Icons.pin_drop_rounded, color: Colors.blue, size: 40),
                                                                Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Form(
                        key: _formValidator,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // margin: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                'Select State',
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
                                        dropdownSearchDecoration: InputDecoration(
                                          hintText: 'Select State',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        onChanged: (e) {
                                          state = e;
                                        },
                                        // showSearchBox: true,
                                        // showClearButton: true,
                                        mode: Mode.BOTTOM_SHEET,
                                        searchDelay: Duration.zero,
                                        items: ngStates.map((e) => e['name']).toList(),
                                        // selectedItem: ngStates.map((e) => e['name']).toList()[0]
                                        selectedItem: state != '' ? state : 'Select State'
                      
                                      ),
                                    ),
                            // Container(
                            //   // margin: EdgeInsets.symmetric(vertical: 5),
                            //   child: Text(
                            //     'Area (optional)',
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.w600, fontSize: 15),
                            //   ),
                            // ),
                            // Container(
                            //           padding: EdgeInsets.symmetric(horizontal:10),
                            //           decoration: BoxDecoration(
                            //           color: const Color.fromARGB(24, 158, 158, 158),
                            //             borderRadius: BorderRadius.circular(10)
                            //           ),
                            //           margin: EdgeInsets.symmetric(vertical:10),
                            //           child: DropdownSearch<dynamic>(
                            //             dropdownSearchDecoration: InputDecoration(
                            //               hintText: 'Select State',
                            //               border: InputBorder.none,
                            //               hintStyle: TextStyle(fontWeight: FontWeight.w500),
                            //             ),
                            //             onChanged: (e) {
                            //               changeState() {
                            //               area = e;
                      
                            //               }
                            //             },
                            //             // showSearchBox: true,
                            //             // showClearButton: true,
                            //             mode: Mode.BOTTOM_SHEET,
                            //             searchDelay: Duration.zero,
                            //               items: state == '' ? [] : ngStates.where((element) => element['name'] == state).first['lgas'],
                            //             // selectedItem: ngStates.map((e) => e['name']).toList()[0]
                            //             selectedItem: area != 'All' ? area : 'All'
                      
                            //           ),
                            //         ),
                            
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                'Amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                                                     TextFormField(
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.number,
                                // keyboardType: TextInputType.multiline,
                              minLines: null,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                              maxLines: null,
                                style: TextStyle(fontSize: 17),
                              decoration: InputDecoration(
                                prefixStyle: TextStyle(color: Colors.grey),
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: '${nairaSign()} 0.00\n',
                                hintStyle: TextStyle(fontWeight: FontWeight.w500),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              onChanged: (text) {
                                print('gh');
                                amount = double.parse(text.trim()).toString();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter charges for this location';
                                }
                                return null;
                              },
                            ),
                                                        Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                'How long does delivery takes',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                                                     TextFormField(
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.number,
                                // keyboardType: TextInputType.multiline,
                              minLines: null,
                              maxLines: null,
                                style: TextStyle(fontSize: 17),
                              decoration: InputDecoration(
                                prefixStyle: TextStyle(color: Colors.grey),
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Eg. 7\n',
                                hintStyle: TextStyle(fontWeight: FontWeight.w500),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              onChanged: (text) {
                                delivery_time = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: 10,),
                          RoundedLoadingButton(
                            controller: _logisticBtnController,
                            // width: double.infinity,
                            child: Text('Add'),
                            color: Colors.black,
                            onPressed: () {
                              if (state=='') {
                                _logisticBtnController.reset();
                                return;
                              }
                              if (!_formValidator.currentState!.validate()) {
                                _logisticBtnController.reset();
                                return;
                              }
                              locations.add({
                                'state_${locations.length+1}':{'name':state, 'amount':amount, 'delivery_days': delivery_time}
                              });
                              Get.close(1);
                              setState(() {
                                
                              });
                      
                              // }
                            },
                          )
                          ],
                        ),
                      ),
                  
                  ),
                  
                                                        ]));
                                                }
                                              );}));
                                    }
                                  )

                                ],
                              )
                            ]),
                          ),
                          SizedBox(height: 5),
                          
                        ],
                      ),
                  ),
                  // Container(
                  //     margin: const EdgeInsets.symmetric(vertical: 5),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Container(
                  //           margin: EdgeInsets.only(bottom: 10),
                  //           child: Text(
                  //             'How many days does delivery take (minimum of 3 days)',
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.w600, fontSize: 15),
                  //           ),
                  //         ),
                  //         TextFormField(
                  //           controller: _priceFieldController,
                  //           cursorColor: Colors.grey,
                  //           keyboardType: TextInputType.number,
                  //           decoration: const InputDecoration(
                  //             prefixStyle: TextStyle(color: Colors.grey),
                  //             fillColor: Color.fromARGB(24, 158, 158, 158),
                  //             filled: true,
                  //             focusedBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide.none,
                  //                 borderRadius:
                  //                     BorderRadius.all(Radius.circular(10))),
                  //             hintText: '4',
                  //             border: OutlineInputBorder(
                  //                 borderSide: BorderSide.none,
                  //                 borderRadius:
                  //                     BorderRadius.all(Radius.circular(10))),
                  //             contentPadding: EdgeInsets.symmetric(
                  //                 horizontal: 10, vertical: 20),
                  //           ),
                  //           onChanged: (text) {
                  //             days = int.parse(text.trim());
                  //           },
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty || days < 3) {
                  //               return 'Please set atleast 3 days for delivery';
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  // ),                
                  
                  SizedBox(height: 20),
                  
                  RoundedLoadingButton(
                      borderRadius: 10,
                      color: Theme.of(context).primaryColor,
                      elevation: 0,
                      controller: _loginButtonController,
                      child: Text('Create'),
                      onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();

                        if (image.isEmpty) {
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
                                            _loginButtonController.reset();

                                          },
                                        )
                                      ],
                                      title: const Text("No Image selected"),
                                      content:  Text('Please add atleast one product image!.'));
                                });
                                    return;
                        }
                        if (locations.isEmpty) {
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
                                            _loginButtonController.reset();

                                          },
                                        )
                                      ],
                                      title: const Text("No Delivery location added"),
                                      content:  Text('Please add at least one delivery location!.'));
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
                          print(brakey.pin);
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
                          Future<List> imageLink = uploadToFireStore('merchant-product/${widget.merchantID}', image);
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
                                      'Registering Product',
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
                          Map a = await createMerchantProductContract(
                              widget.merchantID,
                             widget.user.payload!.accountNumber ?? '',
                              '$days Days',
                              productName,
                              contractTitle,
                              productDetail,
                              links,
                              price.toString(),
                              loc,
                              logisticFrom,
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
                                      title: const Text("Product Registered!"),
                                      content:  Text('Your Product has been created.'));
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
                                      title: const Text("Can't register Product!"),
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
                     
                      }}),
                  SizedBox(height: 20)
                
                
                        ],
                      ),
                    ),
                  ),
                ])),
          ),
        ),
      ],
    );
  }
}
