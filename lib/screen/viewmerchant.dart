import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/merchanttemplateproduct.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:convert/convert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:iconly/iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../api_callers/merchant.dart';
import '../constants.dart';
import '../uix/contractmodeselect.dart';
import '../uix/listitemseparated.dart';
import '../uix/merchantcontractmodeselect.dart';
import '../uix/themedcontainer.dart';
import 'merchanttemplateloan.dart';
import 'merchanttemplateservice.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../uix/askpin.dart';
import 'notifications.dart';


class ViewMerchant extends StatefulWidget {
  const ViewMerchant({Key? key, required this.user, required this.merchant}) : super(key: key);

  final User user;
  final Map merchant;
  @override
  State<ViewMerchant> createState() => _ViewMerchantState();
}

class _ViewMerchantState extends State<ViewMerchant> {
  Brakey brakey = Get.put(Brakey());
  final _formKey = GlobalKey<FormState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  // String _errorMessage = '';
  String bizName = '';
  String merchantName = 'Merchant';
  String merchantID = '';
  String bizLoc = '';
  String website = '';
  String selectedTab = 'all';
  List _tabs = ['all', 'product', 'service', 'loan'];
  List _templates = [];
  String email = '';
  String password = '';
  bool hasMerchant = false;
  bool hasTemplate = false;
  bool hasProduct = false;
  bool hasService = false;
  List randomColors = [
    Color.fromARGB(255, 255, 19, 7),
    Color.fromARGB(255, 7, 110, 255),
    Color.fromARGB(255, 8, 0, 247),
    Color.fromARGB(255, 185, 93, 0),

  ];
  late Map merchant = widget.merchant;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 5,
          toolbarHeight: 65,
          // leading: Container(),
          // actions: [
          //   Obx(() => IconBadge(
          //     onTap: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: ((context) =>
          //               Notifications(user: widget.user, pin: ''))));
          //     },
          //     maxCount: 9,
          //     icon: const Icon(Icons.notifications),
          //     itemCount: brakey.notiCount.toInt(),
          //     right: 10.0,
          //     hideZero: true,
          //     top: 10.0

          //     // hideZero: true,

          //     ))
          // ],
          
          title: Text(merchantName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Container(
            decoration: ContainerBackgroundDecoration(),
            child: ListView(
              children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(children: [
                                Container(
                                    // decoration: ContainerDecoration(),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Container(
                          
                                        width: 80,
                                        height: 80,
                                        decoration: ContainerDecoration().copyWith(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(30)),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        margin: EdgeInsets.only(right: 5),
                                        // padding: EdgeInsets.all(10),
                                        
                                        // child: Image.asset('assets/merchant_placeholder.png', fit: BoxFit.cover,)),
                                        child: Center(child: (Text(widget.merchant['Merchant'][0]?['merchant_name'][0]??'', textAlign: TextAlign.center,style: TextStyle(color: Colors.red, fontSize: 60, fontWeight: FontWeight.bold))))),
                                        SizedBox(height:10),
                                        Text(
                                          widget.merchant['Merchant'][0]?['merchant_name']??'',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                        Text(
                                          '@'+(widget.merchant['Merchant'][0]?['merchant_id']??''),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                        SizedBox(height:5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.diamond_sharp, color: Colors.teal),
                                            SizedBox(width:2),
                                            Text(
                                              (widget.merchant['Merchant'][0]?['business_location']??''),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.circle, color: Colors.teal, size:5),
                                            ),
                                            Icon(CupertinoIcons.map_pin_ellipse, color: Colors.teal),
                                            SizedBox(width:2),
                                            Text(
                                              (widget.merchant['Merchant'][0]?['website']??''),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            Text(
                                          (widget.merchant['Payload']?['merchant_description']??''),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                          ],
                                        ),
                                        // ListItemSeparated(
                                        //     text:
                                        //         widget.merchant['Payload']?['merchant_id']??'_ollo_ventures',
                                        //     title: 'Business ID'),
                                        // ListItemSeparated(
                                        //     text:
                                        //         snapshot.data['Payload']?
                                        //             ['business_email']??'olloventures@gmail.com',
                                        //     title: 'Business Email'),
                                        // ListItemSeparated(
                                        //     text: snapshot
                                        //             .data['Payload']?
                                        //         ['business_location']??'Epe Lagos',
                                        //     title: 'Address',
                                        //     isLast: true),
                                        SizedBox(height: 20,),
                                        DefaultTabController(
                                          length: 4,
                                          child: TabBar(
                                            onTap: (index) {
                                              setState(() {
                                                selectedTab = _tabs[index];
                                                print(selectedTab);
                                              });
                                            },
                                            indicatorColor: Colors.teal,
                                          labelPadding: EdgeInsets.zero,
                                            labelColor: Colors.teal,
                                            unselectedLabelColor: Colors.grey,
                                            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                                            labelStyle: TextStyle(fontWeight: FontWeight.w600),
                                            
                                            tabs: 
                                          [
                                            Tab(text: 'All'+ " (${_templates.length.toString()})"),
                                            Tab(text: 'Products'),
                                            Tab(text: 'Services'),
                                            Tab(text: 'Loans'),
                                            // Tab(text: 'All'),
                                          ]
                                          
                                          )
                                                                                  ,
                                        )],
                                    )),
                                const SizedBox(height: 20),

                                // SizedBox(
                                //     width: double.infinity,
                                //     child: Padding(
                                //       padding:
                                //           const EdgeInsets.all(8.0),
                                //       child: Column(
                                //         children: const [
                                //           Text(
                                //             'Your Registered contracts',
                                //             style: TextStyle(
                                //                 fontSize: 20,
                                //                 fontWeight:
                                //                     FontWeight.bold),
                                //           ),
                                //         ],
                                //       ),
                                //     )),
                                 FutureBuilder(
                                  future: Future.value(widget.merchant),
                                  builder: (BuildContext context,
                                      AsyncSnapshot templateSnapshot) {
                                    if (templateSnapshot.hasData &&
                                        templateSnapshot.data
                                            .containsKey('Product')) {
                                      final _dummytemplates = [];

                                      selectedTab == 'all' || selectedTab == 'product' ? _dummytemplates.addAll(
                                          templateSnapshot
                                              .data['Product']) : (){};
                                      selectedTab == 'all' || selectedTab == 'service' ? _dummytemplates.addAll(
                                          templateSnapshot
                                              .data['Service']) : () {};
                                      selectedTab == 'all' || selectedTab == 'loan' ? _dummytemplates.addAll(
                                          templateSnapshot
                                              .data['Loan']) : () {};
                                      // print("${_templates.length}, 99999999999999999999 ${template_snapshot.data['Product'].length}");
                                      if (templateSnapshot.data
                                              .containsKey('Product') &&
                                          _dummytemplates.isNotEmpty) {
                                        _templates = _dummytemplates;

                                        return GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  mainAxisExtent: 200),
                                          itemCount: _templates.length,
                                          itemBuilder:
                                              (BuildContext context,
                                                  int index) { 
                                            List<int> image;
                                        // print(_templates[index]['Payload'].keys.toList());
                                            try {
                                              if (_templates[index]['Payload']['contract_type'] == 'product') {
                                                  List<dynamic> ld = [0];
                                                  image = ld
                                                      .map((s) => s as int)
                                                      .toList();

                                                } else if (_templates[index]['Payload']['contract_type'] == 'service') {
                                                  List<dynamic> ld = [];
                                                  image = ld
                                                      .map((s) => s as int)
                                                      .toList();
                                                
                                                
                                                } else if (_templates[index]['Payload'].containsKey('loan_link')) {
                                                  List<dynamic> ld = jsonDecode(
                                                      utf8.decode(hex.decode(
                                                          _templates[index][
                                                                  'Payload']
                                                              [
                                                              'loan_picture'])));
                                                  image = ld
                                                      .map((s) => s as int)
                                                      .toList();
                                                } else {
                                                  List<dynamic> ld = jsonDecode(
                                                      utf8.decode(hex.decode(
                                                          _templates[index][
                                                                  'Payload']
                                                              [
                                                              'loan_picture'])));
                                                  image = ld
                                                      .map((s) => s as int)
                                                      .toList();
                                                }
                                            } catch (e) {
                                              print(e.toString()+'adfasdl');
                                              // return;
                                              print(hex.decode(
                                                      _templates[index][
                                                              'Payload']
                                                          [
                                                          'loan_picture']??''));
                                              List<dynamic> ld = jsonDecode(
                                                  utf8.decode(hex.decode(
                                                      _templates[index][
                                                              'Payload']
                                                          [
                                                          'loan_picture']??'4444')));
                                              image = ld
                                                  .map((s) => s as int)
                                                  .toList();
                                            }
                                            return InkWell(
                                              onTap: () {
                                                if (_templates[index]['Payload']['contract_type'] =='product') {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => 
                                                        MerchantProductDetail(
                                                            product:
                                                                _templates[
                                                                    index])));
                                                        

                                                } else if (_templates[index]['Payload']['contract_type'] =='service') {
                                              print(_templates[index]['Payload']['contract_type']);
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => MerchantServiceDetail(
                                                            product:
                                                                _templates[
                                                                    index]['Payload'])));
                                                } else if (_templates[index]['Payload'].containsKey('loan_picture')) {
                                                  
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => MerchantLoanDetail(
                                                            loan:
                                                                _templates[
                                                                    index]['Payload'])));
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets
                                                        .all(5.0),
                                                child: Container(
                                                   
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    decoration: ContainerDecoration(),
                                                          padding: EdgeInsets.all(5),
                                                    child: Column(
                                                      children: [
                                                      
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          child: Stack(
                                                            alignment: Alignment.bottomLeft,
                                                            children: [
                                                              _templates[index]['Payload']['contract_type'] =='product' ? 
                                                              Image.network(_templates[index]['Payload']['product_picture_links']?['link_1']??'https://firebasestorage.googleapis.com/v0/b/braketpay-mobile-app.appspot.com/o/assets%2Fimages.png?alt=media&token=2ca79fe2-172f-49ab-93bf-a6550ef78fa2', fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (_, __, ___) {
                                                    return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
                                                  },) :
                                                              _templates[index]['Payload']['contract_type'] =='service' ? 
                                                              Image.network(_templates[index]['Payload']['service_picture_links']?['link_1']??'https://firebasestorage.googleapis.com/v0/b/braketpay-mobile-app.appspot.com/o/assets%2Fimages.png?alt=media&token=2ca79fe2-172f-49ab-93bf-a6550ef78fa2', fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (_, __, ___) {
                                                    return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
                                                  },) :
                                                              Image.memory(Uint8List.fromList(image), fit: BoxFit.cover, width: double.infinity),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0, bottom: 5),
                                                              child: BlurryContainer(
                                                                padding: EdgeInsets.all(3),
                                                                color: Colors.black.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(5),
                                                                child: Text(_templates[index]['Payload']['contract_type']??'loan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                                                            ),
                                                                    SizedBox(height:4),
                                                            ],
                                                          ),
                                                          height: 120,
                                                          width: double.infinity,
                                                        ),
                                                                    SizedBox(height:10),

                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal:5.0),
                                                          child: Text(
                                                              _templates[index]['Payload'].containsKey(
                                                                      'loan_picture') ? toTitleCase(_templates[index]['Payload']['loan_title']): toTitleCase(_templates[index]['Payload']['contract_title']),
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center, style: TextStyle(fontWeight: FontWeight.w600)),
                                                        ),
                                                        SizedBox(height:5),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                          child: FittedBox(
                                                            child: Text(
                                                                _templates[index]['Payload'].containsKey(
                                                                        'product_amount')
                                                                    ? formatAmount(_templates[index]['Payload']['product_amount']
                                                                        .toString()) : _templates[index]['Payload'].containsKey(
                                                                        'total_service_amount')
                                                                    ? formatAmount(_templates[index]['Payload']['total_service_amount']
                                                                        .toString()): 
                                                                     _templates[index]['Payload'].containsKey(
                                                                        'loan_amount_range')
                                                                    ? formatAmount(_templates[index]['Payload']['loan_amount_range']['min'].toString()) + " - "  + formatAmount(_templates[index]['Payload']['loan_amount_range']['max'].toString()) :' ',
                                                                maxLines: 1,
                                                                style: const TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                    fontFamily:
                                                                        '')),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            
                                            );
                                          },
                                        );
                                      } else {
                                        return Container(
                                            margin: const EdgeInsets.all(40),
                                            child: Center(
                                                child: Column(
                                                  children: [
                                                    Image.asset('assets/empty.png'),
                                                    Text(
                                                        'You have not Registered any contract yet.\n Click the add button to create.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                                                  ],
                                                )));
                                      }
                                    } else {
                                      return Center(
                                          child: Column(
                                            children: [
                                              Image.asset('assets/sammy-no-connection.gif', height: 200),
                                              const Text(
                                                  "Couldn't load registered Contracts"),
                                              const SizedBox(height:10),
                                              RoundButton(
                                                          icon: Icons.refresh,

                                                text: 'Retry',
                                                color1: NeutralButton,
                                                color2: NeutralButton,
                                                onTap: () {
                                                  brakey.refreshMerchant.value!.currentState!.show();
                                                }
                                                
                                              )
                                            ],
                                          ));
                                    }
                                  },
                                )
                                // :
                              ]))
              ],
            )));
  }

  contractMode() {
    Get.to(() => MerchantContractModeSelect(
              user: widget.user, pin: "", merchantID: merchantID));
  }
  //       // child:
}
