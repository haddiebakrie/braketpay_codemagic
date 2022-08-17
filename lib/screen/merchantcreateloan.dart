import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:braketpay/api_callers/merchant.dart';
import 'package:braketpay/screen/viewmerchant.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:convert/convert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/loan.dart';
import '../brakey.dart';
import '../classes/user.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../ngstates.dart';
import '../uix/askpin.dart';
import '../uix/listitemseparated.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class MerchantCreateLoanFromScan extends StatefulWidget {
  const MerchantCreateLoanFromScan(
      {Key? key, required this.loan, required this.user, required this.pin})
      : super(key: key);

  final Map loan;
  final User user;
  final String pin;

  @override
  State<MerchantCreateLoanFromScan> createState() =>
      _MerchantCreateLoanFromScanState();
}

class _MerchantCreateLoanFromScanState extends State<MerchantCreateLoanFromScan> {
  Brakey brakey = Get.put(Brakey());
  double loanAmount = 0;
  late String nokName;
  late String nokNIN;
  final imageController = PageController();
  late String useOfFunds;
  late String nokPhone;
  late String pOne;
  bool hasLoadError = false;
  String loadErrorMsg = '';
  late String bvn;
  late String phone;
  late String pTwo;
  late String marital='';
  late String imageByte = '';
  late bool hasImage = false;
  late String address ='';
  late String paybackStatement ='';
  late String dependant ='';
  late String lga='';
  late String state='';
  late String employment='';
  late String eduLevel='';
  late String pThree;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final TextEditingController _nokNINFieldController = TextEditingController();
  final TextEditingController _nokUseOfFundsFieldController = TextEditingController();
  final TextEditingController _nokPhoneFieldController = TextEditingController();
  final TextEditingController _shipDestFieldController =
      TextEditingController();
  String statementPDF= '';

  @override
  Widget build(BuildContext context) {
    _loginButtonController.reset();
    // List<dynamic> ld =
    //     jsonDecode(utf8.decode(hex.decode(widget.loan['Payload']['loan_picture'])));
    // List<int> image = ld.map((s) => s as int).toList();
    // print(
    //     // decode(hex.decode(widget.loan['Payload']['Payload']['loan_picture']))
    //     (image.length));
        List<Widget> images = [];
    if (widget.loan['Payload']['loan_picture_links'] == null) {
      widget.loan['Payload']['loan_picture_links'] = {'link_1': brokenImageUrl};
    }
    if (widget.loan['Payload']['categories'] == null) {
      widget.loan['Payload']['categories'] = {'category_1': 'others'};
    }
    for (int i=0; i < widget.loan['Payload']['loan_picture_links'].length; i++) {
      setState(() {
        images.add(Image.network(
          widget.loan['Payload']['loan_picture_links']['link_${i+1}']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, 
          errorBuilder: (_, __, ___) {
              return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
            },
          ));
        
      });
      };
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(elevation: 0),
        body: SingleChildScrollView(
          child: Container(
            decoration: ContainerBackgroundDecoration(),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          Get.to(() => 
                          
                          PhotoView(
                          imageProvider: NetworkImage(widget.loan['Payload']['loan_picture_links']['link_${(imageController.page! + 1).toInt()}']??brokenImageUrl,
                          
                          ))
                          );
                        },
                        child: Container(
                          height: 300,
                          decoration: ContainerDecoration().copyWith(
                          // color: Colors.red,
            
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: PageView(
                            controller: imageController,
                            onPageChanged: (current) {
                              setState(() {
                                
                              });
                            },
                            children: images
                              // Image.network(widget.loan['loan_picture_links']['link_2']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, ),
                              // Image.network(widget.loan['loan_picture_links']['link_3']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, ),
                            
                            // options: CarouselOptions(
                            //     enlargeCenterPage: true,
                            //     initialPage: 1,
                            //     enableInfiniteScroll: false,
                            //     height: double.infinity,
                            //     viewportFraction: 1.5,
                            //     // padEnds: false,
                                
                            //     enlargeStrategy: CenterPageEnlargeStrategy.scale),
                          )
                          ),
                      ),
                      Visibility(
                        visible: images.length > 1,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PageIndicator(
                                color: Colors.grey,
                                activeColor: Colors.teal,
                                activeSize: 15,
                                size: 15,
                                count: images.length, controller: imageController),
                            ),
                      SizedBox(height: 10,),
                        Container(
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.loan['Payload']['loan_picture_links'].length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    print(imageController.page);
                                  return InkWell(
                                    onTap: () {
                                          imageController.animateToPage(
                                            index,
                                            duration: Duration(milliseconds: 1),
                                            curve: Curves.linear
                                          );
            
                                      
                                        
                                        // PhotoView(
                                        // imageProvider: NetworkImage(widget.loan['loan_picture_links'][widget.loan['loan_picture_links'].keys.toList()[index]]??'',))
                                        // );
                                      },
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: ContainerDecoration().copyWith(
                                        // border: Border.all(width: 3, color: imageController.page!.toInt()+1 == index ? Colors.blue : Colors.transparent)
                                      ),
                                      margin: EdgeInsets.all(5),
                                      // padding: EdgeInsets.all(5),
                                      child: Image.network(widget.loan['Payload']['loan_picture_links'][widget.loan['loan_picture_links'].keys.toList()[index]], height: double.infinity, width: double.infinity, fit: BoxFit.cover),
                                    ),
                                  );
                                } 
                                
                                ),
                              ),
                            ],
                          ),
                        ),
                          ],
                        ),
                      ),
                        SizedBox(height:20),
                         Container(
                          decoration: ContainerDecoration(),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              // Text(
                              //   'Contract Details',
                              //   style: TextStyle(
                              //       fontSize: 20, fontWeight: FontWeight.bold),
                              // ),
                              InkWell(
                                onTap: () async {
                                              // widget.loan.forEach((k, v) => print('$k => $v'));

                                              Get.bottomSheet(
                                                  
                                                BottomSheet(
                                                  onClosing: () {
                                                    setState(() {
                                                      hasLoadError = false;
                                                      loadErrorMsg = '';
                                                    });
                                                  },
                                                  builder: (_) {
                                                    return Container(
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            hasLoadError ? Icon(Icons.close, color: Colors.redAccent, size: 25,) : CircularProgressIndicator(),
                                                            SizedBox(height:20),
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(widget.loan['Payload']['merchant_name']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                ),
                                                isDismissible: false
                                              );
                                              Map a =
                                                            await fetchMerchantContract(
                                                                '',
                                                                'loan',
                                                                widget.loan['merchant_id'],
                                                                brakey
                                                                        .user
                                                                        .value!
                                                                        .payload!
                                                                        .walletAddress ??
                                                                    '',
                                                                brakey.user.value?.payload?.pin??'',
                                                                'all',
                                                                brakey.user.value?.payload?.password??'',
                                                                
                                                                );
                                              if (a
                                                            .containsKey('Merchant')) {
                                                              print(a['Merchant']);
                                                  Get.close(1);
                                                  Get.to(() => ViewMerchant(user: widget.user, merchant: a));
                                                          // a.addEntries({
                                                          //   'merchant_id': '',
                                                          //   'loan_id': _templates[index]['loan_id']
                                                          // }.entries);
                                                          // Navigator.of(context).pop();
                                                          // hasLoadError = false;
                                                          // Navigator.of(context).push(
                                                          //     MaterialPageRoute(
                                                          //         builder: ((context) =>
                                                          //             MerchantCreateLoanFromScan(
                                                          //                 loan: a,
                                                          //                 user: brakey
                                                          //                     .user
                                                          //                     .value!,
                                                          //                 pin: brakey.user.value?.payload?.pin??''))));
                                            } else {
                                              Get.close(1);
                                              Get.bottomSheet(
                                                  
                                                BottomSheet(
                                                  onClosing: () {
                                                    setState(() {
                                                      hasLoadError = false;
                                                      loadErrorMsg = '';
                                                    });
                                                  },
                                                  builder: (_) {
                                                    return Container(
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            hasLoadError ? Icon(Icons.close, color: Colors.redAccent, size: 25,) : CircularProgressIndicator(),
                                                            SizedBox(height:20),
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(widget.loan['merchant_name']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                ),
                                                isDismissible: false
                                              );
                                              setState(() {
                                                hasLoadError = true;
                                                loadErrorMsg = a['Message'] ?? 'Failed, Please check your Internet and Try again.';
                                              });
                                            }
                                            
                                            },
                                child: Row(
                                  children: [
                                    Container(
                                      
                                      // width: 30,
                                      // height: 30,
                                      // decoration: ContainerDecoration(),
                                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                                      // margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(5),
                                      
                                      // child: Image.asset('assets/merchant_placeholder.png', fit: BoxFit.cover,)),
                                      child: CircleAvatar(backgroundImage: NetworkImage(widget.loan["merchant_logo_link"]??''), radius: 10,)),
                                    Text("Lender: ${widget.loan['Payload']["merchant_name"]}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo, decoration: TextDecoration.underline)),
                                  ],
                                ),
                              ),
                              SizedBox(height:10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(widget.loan['Payload']['loan_title'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    
                                  ),
                                  SizedBox(width: 5,),
                                  FittedBox(child: Text('min: ${nairaSign()}${widget.loan['Payload']['loan_amount_range']['min']}\nmax: ${nairaSign()}${widget.loan['Payload']['loan_amount_range']['max']}', textAlign: TextAlign.left,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey))),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Text(widget.loan['Payload']["loan_category"].replaceAll('loan', ''), style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),)
                              ),
                              SizedBox(height:25),
                              // Container(height: 1.5, color: Colors.grey),
                              // SizedBox(height:10),
                              Text('Interest', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              SizedBox(height:5),
                              MarkdownBody(
                                data: '${widget.loan['Payload']["interest_rate"]}%'),
                              SizedBox(height:20),
                              Text('Loan type', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              SizedBox(height:5),
                              MarkdownBody(
                                data: '${widget.loan['Payload']["loan_type"]}'.capitalizeFirst!),
                              SizedBox(height:20),
                              Text('Loan Detail', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              SizedBox(height:5),
                              MarkdownBody(
                                data: '${widget.loan['Payload']["loan_description"]}'),
                              SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                              Text('Period', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              SizedBox(height:5),
                              MarkdownBody(
                                data: toTitleCase(jsonDecode(widget.loan['Payload']['loan_period'])['loan period'].toString())),
                              SizedBox(height:20),

                                    ]
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                              Text('Repayment starts after', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              SizedBox(height:5),
                              MarkdownBody(
                                data: toTitleCase(jsonDecode(widget.loan['Payload']['loan_period'])['borrower repayment start time'].toString())),
                              SizedBox(height:10),

                                    ]
                                  ),
                              //     Column(
                              //       children: [
                              // Text('Period', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              // SizedBox(height:5),
                              // MarkdownBody(
                              //   data: '${widget.loan['Payload']["interest_rate"]}%'),
                              // SizedBox(height:10),

                                  //   ]
                                  // ),
            

                                ]
                              ),
                            ],
                          )),
                      SizedBox(height:20),
                    // Container(
                    //     decoration: ContainerDecoration(),
                    //     child: Column(
                    //       children: [
                    //         const SizedBox(height: 10),
                    //         Text(
                    //           widget.loan['Payload']['loan_title'],
                    //           style: TextStyle(
                    //               fontSize: 20, fontWeight: FontWeight.bold),
                    //         ),
                    //         ListSeparated(
                    //             text: widget.loan['Payload']['merchant_name'],
                    //             title: 'Lender'),
                    //         ListSeparated(
                    //             text: 'LOAN CONTRACT',
                    //             title: 'Contract Type'),
                    //         ListTile(
                    //           contentPadding: EdgeInsets.symmetric(horizontal:20),
                    //       subtitle: Text(widget.loan['Payload']['loan_description']),
                    //       title: Text('Loan Description', style: TextStyle(fontWeight: FontWeight.bold)),
                          
                    //     ),
                    //     // Container(
                    //     //       color:Colors.grey.withOpacity(.5),
                    //     //       height: 1,
                    //     //       width: double.infinity),
                         
                    //         ListSeparated(
                    //             text: toTitleCase(widget.loan['Payload']['interest_rate'].toInt().toString()+'%'),
                    //             title: 'Interest Rate'),
                    //         ListSeparated(
                    //             text: toTitleCase(widget.loan['Payload']['loan_type']),
                    //             title: 'Loan Type'),
                    //         ListSeparated(
                    //             text: toTitleCase(jsonDecode(widget.loan['Payload']['loan_period'])['loan period'].toString()),
                    //             title: 'Loan Peroid'),
                    //          ListSeparated(
                    //             text: toTitleCase(jsonDecode(widget.loan['Payload']['loan_period'])['borrower repayment start time'].toString()+' months'),
                    //             title: 'Repayment starts after'),
                    //         ListSeparated(
                    //             text: formatAmount(widget.loan['Payload']['loan_amount_range']['min'].toString()),
                    //             title: 'Minimum Lending Amount'),
                    //         ListSeparated(
                    //             text: formatAmount(widget.loan['Payload']['loan_amount_range']['max'].toString()),
                    //             title: 'Maximum Lending Amount'),
                    //             ],
                    //           )),
                    //           // 72388217643
                    // Container(
                    //       decoration: ContainerDecoration(),
                    //       padding: EdgeInsets.all(20),
                    //       child: Column(children: [
                    //         Text('Braket Smart contract ensures secure payment and product delivery on every sale in 3 steps.',
                    //         style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)
                    //         ),
                    //         SizedBox(height:10),
                    //         Row(children: [
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(right: 10),
                    //             child: Icon(Icons.check_circle, color: Colors.teal, size: 18),
                    //           ),
                    //           Flexible(child: Text('${widget.loan['Payload']["merchant_name"]} accepts the terms of the contract', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
                    //         ],),
                    //         Row(children: [
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(right: 10),
                    //             child: Icon(Icons.lock_sharp, color: Colors.teal, size: 18),
                    //           ),
                    //           Flexible(child: Text('Braket reviews your eligibility and ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
                    //         ],),
                    //         Row(children: [
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(right: 10),
                    //             child: Icon(IconlyBold.buy, color: Colors.teal, size: 18),
                    //           ),
                    //           Flexible(child: Text('Money is only sent to ${widget.loan['Payload']["merchant_name"]} after you confirm the product is delivered to you', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
                    //         ],),
                    //         // Text('Prevent what I ordered VS what I got.',
                    //         // style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)
                    //         // ),
                    //       ]),
                    //       ),
                    //   SizedBox(height:20),
                    // const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: ContainerDecoration(),
                        child: Column(
                          children: [
                            Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                            const Text(
                              'Borrowing Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height:10),
                            Text('Please provide a detailed use of the money'),
                            const SizedBox(height:20),
                            
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Phase One',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. Buying of farm equipment\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                              onChanged: (text) {
                                pOne = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phase one detail is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                                           
                                            Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Phase Two',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. Paying Labourers\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                              onChanged: (text) {
                                pTwo = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phase two detail is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                                           Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Phase Three',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. Transporting farm product for sales\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                              onChanged: (text) {
                                pThree = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phase three detail is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                                 Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'How do you intend to payback',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. Revenue from selling my farm products\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                              onChanged: (text) {
                                paybackStatement = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    widget.user.payload!.bvn!.toString().startsWith('2') ? 'NIN' : 'BVN',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ),    TextFormField(
                              maxLength: 11,
                              cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                hintMaxLines: 2,
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'XXXXXXXXXXX',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                bvn = text.trim();
                              },
                              validator: (value) {
                                if ( value == null || value.isEmpty || value.trim().length < 11) {
                                  return widget.user.payload!.bvn!.toString().startsWith('2') ? 'Invalid NIN' : 'Invalid BVN';
                                }
                                return null;
                              },
                            ),
                      
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Your Active Phone number',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ),    TextFormField(
                              maxLength: 11,
                              cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                hintMaxLines: 2,
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'XXXXXXXXXXX',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                phone = text.trim();
                              },
                              validator: (value) {
                                if ( value == null || value.isEmpty || value.trim().length < 11) {
                                  return widget.user.payload!.bvn!.toString().startsWith('2') ? 'Invalid NIN' : 'Invalid BVN';
                                }
                                return null;
                              },
                            ),
                      
                        ],
                      ),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Marital Status',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ), 
                          Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    margin: EdgeInsets.symmetric(vertical:10),

                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    // margin: EdgeInsets.symmetric(vertical:10),
                                    child: DropdownSearch<dynamic>(
                                        onChanged:(e) {
                                          marital = e;
                                        },
                                      dropdownSearchDecoration: InputDecoration(
                                        hintText: 'Select State',
                                        border: InputBorder.none,
                                        // filled: true,
                                      ),
                                      // showSearchBox: true,
                                      // showClearButton: true,
                                      mode: Mode.MENU,
                                      searchDelay: Duration.zero,
                                      items: ['Single', 'Married'],
                                      selectedItem: marital != '' ? marital : '--------'
                                    ),
                                  ),

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'How many people depend on your Income',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ),    TextFormField(
                              cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                hintMaxLines: 2,
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Eg. 3',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10,),
                              ),
                              onChanged: (text) {
                                dependant = text.trim();
                              },
                              validator: (value) {
                                if ( value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                      
                        ],
                      ),
                      SizedBox(height:15),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Education Level',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ), 
                          Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    margin: EdgeInsets.symmetric(vertical:10),
                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    // margin: EdgeInsets.symmetric(vertical:10),
                                    child: DropdownSearch<dynamic>(
                                        onChanged:(e) {
                                      setState(() {
                                          eduLevel = e;
                                          if (e == 'No Education') {
                                            eduLevel = 'None';
                                          }

                                      });
                                        },
                                      dropdownSearchDecoration: InputDecoration(
                                        hintText: 'Select Education Level',
                                        border: InputBorder.none,
                                        // filled: true,
                                      ),
                                      // showSearchBox: true,
                                      // showClearButton: true,
                                      mode: Mode.BOTTOM_SHEET,
                                      searchDelay: Duration.zero,
                                      items: ['No Education', 'Primary', 'Secondary', 'College of education', 'Polytechnique', 'University', 'Masters', 'PHD' ],
                                      selectedItem: eduLevel != '' ? eduLevel == 'None' ? 'No Education' : eduLevel : '--------'
                                    ),
                                  ),
                                  

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Employment Status',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ), 
                          Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    margin: EdgeInsets.symmetric(vertical:10),
                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    // margin: EdgeInsets.symmetric(vertical:10),
                                    child: DropdownSearch<dynamic>(
                                        onChanged:(e) {
                                          employment = e;
                                          if (e == 'Unemployed') {
                                            e = 'None';
                                          }
                                        },
                                      dropdownSearchDecoration: InputDecoration(
                                        hintText: 'Select Employment status',
                                        border: InputBorder.none,
                                        // filled: true,
                                      ),
                                      // showSearchBox: true,
                                      // showClearButton: true,
                                      mode: Mode.MENU,
                                      searchDelay: Duration.zero,
                                      items: ['Unemployed', 'Employed', 'Self Employed', ],
                                      selectedItem: employment != '' ? employment : '--------'
                                    ),
                                  ),
                                  

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Bank Statement',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ), 
                          Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    margin: EdgeInsets.symmetric(vertical:10),
                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    // margin: EdgeInsets.symmetric(vertical:10),
                                    child: TextButton(onPressed: () async {
                                      
                                      FilePickerResult? _image = await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf'],
                                      );
                                      if (_image == null) {
                                        return;
                                      }
                                      final _imageByte = await File(_image.paths.first ?? '').readAsBytes();
                                      print(_image.paths.first);
                                      setState(() {
                                        statementPDF = _image.names.first ?? '';
                                        imageByte = jsonEncode(_imageByte);
                                        hasImage = _image.paths.first == '' ? false : true;
                                        print(_imageByte);
                                        print(_imageByte.length);
                                      });
                                    }, child: 
                                    Row(
                                      children: [
                                    Icon(IconlyBold.paper_plus, ),
                                    SizedBox(width:10),
                                        Text(imageByte == '' ? 'Upload Bank statement' : statementPDF),
                                      ],
                                    ))
                                  ),
                          Text('Only PDF format is accepted', style: TextStyle(color: Colors.grey))
                                  

                        ],
                      ),
                      
                      
                      ])),
                      const SizedBox(height: 10),
                  const Text(
                    'Home address',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height:20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'State',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                  ), 
                            Container(
                                      padding: EdgeInsets.symmetric(horizontal:10),
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(24, 158, 158, 158),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      margin: EdgeInsets.symmetric(vertical:10),
                                      child: DropdownSearch<dynamic>(
                                          onChanged:(e) {
                                            setState(() {
                                            state = e;
                                            lga = '';
                                              
                                            });
                                          },
                                        dropdownSearchDecoration: InputDecoration(
                                          hintText: 'Select State',
                                          border: InputBorder.none,
                                          // filled: true,
                                        ),
                                        // showSearchBox: true,
                                        // showClearButton: true,
                                        mode: Mode.BOTTOM_SHEET,
                                        searchDelay: Duration.zero,
                                        items: ngStates.map((e) => e['name']).toList(),
                                        selectedItem: state != '' ? state : 'Select State'
                                      ),
                                    ),
                                    

                          ],
                        ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'LGA',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                  ), 
                            Container(
                                      padding: EdgeInsets.symmetric(horizontal:10),
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(24, 158, 158, 158),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      margin: EdgeInsets.symmetric(vertical:10),
                                      child: DropdownSearch<dynamic>(
                                          onChanged:(e) {
                                            setState(() {
                                            lga = e;
                                              
                                            });
                                          },
                                        dropdownSearchDecoration: InputDecoration(
                                          hintText: 'Select LGA',
                                          border: InputBorder.none,
                                          // filled: true,
                                        ),
                                        // showSearchBox: true,
                                        // showClearButton: true,
                                        mode: Mode.BOTTOM_SHEET,
                                        searchDelay: Duration.zero,
                                        items: state == '' ? [] : ngStates.where((element) => element['name'] == state).first['lgas'],
                                        selectedItem: lga != '' ? lga : 'Select LGA'
                                      ),
                                    ),
                                    Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Address',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Your home address\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              onChanged: (text) {
                                address = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Home address is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                             

                          ],
                        ),
                      
                  const SizedBox(height: 10),
                  const Text(
                    'Next of Kin Details',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height:20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Next of KIN Name',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                          TextFormField(
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: "Firstname Surname",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            nokName = text.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Next of Kin name is required';
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
                            'Next of KIN NIN',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                          TextFormField(
                            controller: _nokNINFieldController,
                                maxLength: 11,
                                cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  hintMaxLines: 2,
                                  helperMaxLines: 2,
                                  errorMaxLines: 2,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: 'XXXXXXXXXXX',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (text) {
                                  nokNIN = text.trim();
                                },
                                validator: (value) {
                                  print(value);
                                  if ( value != null && value.isNotEmpty && value.trim().length < 11 || value!.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                              ),
                      ])),
                      Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Next of KIN Phone',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                          TextFormField(
                            controller: _nokPhoneFieldController,

                                cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  hintMaxLines: 2,
                                  helperMaxLines: 2,
                                  errorMaxLines: 2,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: '09012345678',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (text) {
                                  nokPhone = text.trim();
                                },
                                validator: (value) {
                                  print(value);
                                  if ( value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                              ),
                      ])),
                            
                            const SizedBox(height: 10),
                            const Text(
                              'Borrowing Amount',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height:20),
                            Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'You can borrow between\n ${formatAmount(widget.loan['Payload']['loan_amount_range']['min'].toString())} - ${formatAmount(widget.loan['Payload']['loan_amount_range']['max'].toString())}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                          TextFormField(
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                    // textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 60,
                                  ),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: InputDecoration(
                                    errorMaxLines: 2,
                                    icon: Text(nairaSign(), style:const TextStyle(fontSize: 40, color: Colors.grey)),
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
                                    loanAmount = text == '' ? 0 : double.parse(text.trim());
                                    // setState(() {                                    
                                    //   _priceTextController.text = price.toString();
                                    // });
                                  
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || 
                                    int.parse(value) < widget.loan['Payload']['loan_amount_range']['min'] || 
                                    int.parse(value) > widget.loan['Payload']['loan_amount_range']['max']
                                    ) {
                                      return 'The Loan amount must between the minimum and maximum amount';
                                    }
                                    return null;
                                  },
                                ),
                      ],
                    ),
                  ),
                  const SizedBox(height:30),

                            RoundedLoadingButton(
                                borderRadius: 10,
                                color: Theme.of(context).primaryColor,
                                elevation: 0,
                                controller: _loginButtonController,
                                child: const Text('Apply'),
                                onPressed: () async {
                                  employment = employment.replaceAll('Unemployed', 'None');
                                      
                              FocusManager.instance.primaryFocus?.unfocus();

                                  if (!_formKey.currentState!.validate()) {
                                    _loginButtonController.reset();
                                  } else {
                                    if (!hasImage) {
                            _loginButtonController.reset();
                            
                            showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
      
                                            },
                                          )
                                        ],
                                        title: const Text("Error"),
                                        content:  Text('Please upload Bank Statement!.'));
                                  });
                                      return;
                          }
                          if (lga == '') {
                            _loginButtonController.reset();
                            
                            showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
      
                                            },
                                          )
                                        ],
                                        title: const Text("Error"),
                                        content:  Text('Please Select your LGA!.'));
                                  });
                                      return;
                          }
                          if (marital=='') {
                            _loginButtonController.reset();
                            
                            showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
      
                                            },
                                          )
                                        ],
                                        title: const Text("Error"),
                                        content:  Text('Please select your Marital status!.'));
                                  });
                                      return;
                          }
                          if (eduLevel==''){
                            _loginButtonController.reset();
                            
                            showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
      
                                            },
                                          )
                                        ],
                                        title: const Text("Error"),
                                        content:  Text('Please select your Education Level!.'));
                                  });
                                      return;
                          }
                                    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                                  final _pinEditController = TextEditingController();
                                    Map? pin = await askPin(_pinEditController, _pinErrorController);
                                                          
                                    if (pin == null || !pin.containsKey('pin')) {
                                      return;
                                    };
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                  title: const Text(
                                    'Creating loan contract',
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
                        _loginButtonController.reset();
                        print(widget.user.payload!.bvn);
                        Map a = await activateLoanContract(
                          widget.loan['Payload']['loan_id'],
                           widget.user.payload!.walletAddress ?? '',
                           pin['pin'],
                           bvn,
                           loanAmount.toString(),
                           {'phase_1':{'use_of_funds':pOne},'phase_2':{'use_of_funds':pTwo},'phase_3':{'use_of_funds':pThree}},
                           nokName,
                           nokNIN,
                           '234' + int.parse(nokPhone).toString(),
                           phone,
                           marital == 'Single',
                           eduLevel,
                           imageByte,
                           state,
                           lga,
                           address,
                           paybackStatement,
                           int.parse(dependant),
                           employment
                           );
                  
                  if (a.containsKey('Payload')) {
                          _loginButtonController.success();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop(true);
                                        },
                                      )
                                    ],
                                    title: const Text("Contract created!"),
                                    content:  const Text('Your Loan Contract has been created.'));
                              });
                        } else {
                          _loginButtonController.reset();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                                    title: const Text("Can't activate Loan!"),
                                    content:  Text(toTitleCase(a['Message']??"")));
                              });

                        }
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
