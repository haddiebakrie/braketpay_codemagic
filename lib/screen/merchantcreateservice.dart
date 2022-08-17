import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:braketpay/api_callers/merchant.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/constants.dart';
import 'package:braketpay/screen/viewmerchant.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:iconly/iconly.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../uix/askpin.dart';
import '../uix/listitemseparated.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';
import 'contract_chat.dart';
import 'manager.dart';

class MerchantCreateServiceFromScan extends StatefulWidget {
  const MerchantCreateServiceFromScan(
      {Key? key, required this.product, required this.user, required this.pin})
      : super(key: key);

  final Map product;
  final User user;
  final String pin;

  @override
  State<MerchantCreateServiceFromScan> createState() =>
      _MerchantCreateServiceFromScanState();
}

class _MerchantCreateServiceFromScanState
    extends State<MerchantCreateServiceFromScan> {
        bool hasLoadError = false;
  String loadErrorMsg = '';
      Brakey brakey = Get.put(Brakey());
  late String shipDest;
  final imageController = PageController();
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final TextEditingController _shipDestFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map stages = jsonDecode(widget.product['about_service_delivery_stages']);

    List<Widget> images = [];
    if (widget.product['service_picture_links'] == null) {
      widget.product['service_picture_links'] = {'link_1': brokenImageUrl};
    }
    if (widget.product['service_categories'] == null) {
      widget.product['service_categories'] = {'category_1': 'others'};
    }
    for (int i = 0; i < widget.product['service_picture_links']?.length; i++) {
      setState(() {
        images.add(Image.network(
          widget.product['service_picture_links']?['link_${i + 1}'] ?? '',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ));
      });
    }
    ;
    return Scaffold(
             backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(toolbarHeight: 1, elevation: 0, automaticallyImplyLeading: false),
        floatingActionButton: FloatingActionButton (
          // backgroundColor: Theme.of(context).textTheme.bodyLarge!.color,
          child: AbsorbPointer(
            child: IconBadge(icon: 
            Icon(CupertinoIcons.bubble_left_fill, color: Colors.white), onTap: () {},
            itemCount: 1,
            itemColor: Colors.white,
            ),
          ),
          onPressed: () {
            Get.to(() => ChatScreen(user: widget.user, contract: widget.product));
          },
        ),
        // extendBody: true,
        body: Column(
          children: [
          Container(
     height: kToolbarHeight,
      padding: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Text('Products', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 22),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(color: Colors.white,),
            ],
          ),
              Container(
                decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    margin: EdgeInsets.only(right: 15),
                child: IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.heart, color: Colors.white)),
              ),
            
        ],
      ),
    ),
   
            Expanded(
              child: Container(
                
                decoration: ContainerBackgroundDecoration(),
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => PhotoView(
                                      imageProvider: NetworkImage(
                                    widget.product['service_picture_links']
                                            ['link_${(imageController.page! + 1).toInt()}'] ??
                                        brokenImageUrl,
                                  )));
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
                                      setState(() {});
                                    },
                                    children: images
                                    // Image.network(widget.product['service_picture_links']['link_2']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, ),
                                    // Image.network(widget.product['service_picture_links']['link_3']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, ),
            
                                    // options: CarouselOptions(
                                    //     enlargeCenterPage: true,
                                    //     initialPage: 1,
                                    //     enableInfiniteScroll: false,
                                    //     height: double.infinity,
                                    //     viewportFraction: 1.5,
                                    //     // padEnds: false,
            
                                    //     enlargeStrategy: CenterPageEnlargeStrategy.scale),
                                    )),
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
                                      count: images.length,
                                      controller: imageController),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 80,
                            child: Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      widget.product['service_picture_links'].length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    print(imageController.page);
                                    return InkWell(
                                      onTap: () {
                                        imageController.animateToPage(index,
                                            duration: Duration(milliseconds: 1),
                                            curve: Curves.linear);
            
                                        // PhotoView(
                                        // imageProvider: NetworkImage(widget.product['service_picture_links'][widget.product['service_picture_links'].keys.toList()[index]]??'',))
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
                                        child: Image.network(
                                            widget.product['service_picture_links'][
                                                widget
                                                    .product['service_picture_links']
                                                    .keys
                                                    .toList()[index]],
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.cover),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // Text(
                          //   'Contract Details',
                          //   style: TextStyle(
                          //       fontSize: 20, fontWeight: FontWeight.bold),
                          // ),
                          Container(
                            decoration: ContainerDecoration(),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(widget.product['merchant_name']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                                                'service',
                                                                widget.product['merchant_id'],
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(widget.product['merchant_name']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                      child: CircleAvatar(backgroundImage: NetworkImage(widget.product["merchant_logo_link"]??''), radius: 10,)),
                                    Text("Provider: ${widget.product["provider_business_name"]}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo, decoration: TextDecoration.underline)),
                                  ],
                                ),
                              ),
                              
                                  SizedBox(height: 5),
                                ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.product['contract_title'] ?? '',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                        '${nairaSign()}${widget.product["total_service_amount"]}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                                  ],
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      widget.product["service_categories"]
                                          ['category_1'],
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(height: 25),
                                // SizedBox(height:25),
                                // Container(height: 1.5, color: Colors.grey),
                                // SizedBox(height:10),
                                Text('Stages',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600)),
                                SizedBox(height: 5),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: stages.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListItemSeparated(
                                      leadingText: (index+1).toString(),
                                        title: stages[stages.keys.toList()[index]]
                                            ['about_stage'],
                                        text: formatAmount(
                                            '${stages[stages.keys.toList()[index]]['cost_of_stage']}'));
                                  },
                                ),
                                SizedBox(height: 10),
                                ListItemSeparated(
                                      text:
                                          '${formatAmount(widget.product['downpayment'].toString())}',
                                      title: 'Advance payment'),
                                  Text('This amount is paid to ${widget.product['provider_business_name']} immediately the contract is approved.', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                                  ListItemSeparated(
                                    text: widget.product['delivery_duration'],
                                    title: 'Delivery takes',
                                    isLast: true,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height:20),
                          Container(
                          decoration: ContainerDecoration(),
                          padding: EdgeInsets.all(20),
                          child: Column(children: [
                            Text('Braket Smart contract ensures secure payment and product delivery on every sale in 3 steps.',
                            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)
                            ),
                            SizedBox(height:10),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(right: 10),
                                child: Icon(Icons.check_circle, color: Colors.teal, size: 18),
                              ),
                              Flexible(child: Text('${widget.product["provider_business_name"]} accepts the terms of the contract', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
                            ],),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(right: 10),
                                child: Icon(Icons.lock_sharp, color: Colors.teal, size: 18),
                              ),
                              Flexible(child: Text('Your payment is locked on Braket vault until you confirm the delivery has been successful', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
                            ],),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(right: 10),
                                child: Icon(IconlyBold.buy, color: Colors.teal, size: 18),
                              ),
                              Flexible(child: Text('Money is only sent to ${widget.product["provider_business_name"]} after you confirm the product is delivered to you', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
                            ],),
                            // Text('Prevent what I ordered VS what I got.',
                            // style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)
                            // ),
                          ]),
                          ),
                      SizedBox(height:20),
                          Form(
                            key: _formKey,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Delivery Details',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          child: const Text(
                                            'House address',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _shipDestFieldController,
                                          cursorColor: Colors.grey,
                                          maxLines: null,
                                          minLines: null,
                                          decoration: const InputDecoration(
                                            fillColor:
                                                Color.fromARGB(24, 158, 158, 158),
                                            filled: true,
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            hintText: 'Ikeja, Lagos\n',
                                            hintStyle: TextStyle(
                                              color: Colors.grey, fontWeight: FontWeight.w600
                                            ),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          onChanged: (text) {
                                            _loginButtonController.reset();
                                            shipDest = text.trim();
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
                                
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
           decoration: ContainerDecoration().copyWith(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.all(10),
            child:   RoundedLoadingButton(
                                borderRadius: 10,
                                color: Colors.teal,
                                elevation: 0,
                                controller: _loginButtonController,
                                child: const Text('Create'),
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  if (!_formKey.currentState!.validate()) {
                                    _loginButtonController.reset();
                                  } else {
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
                                                'Creating Service contract',
                                                textAlign: TextAlign.center,
                                              ),
                                              // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                                              content: Row(children: const [
                                                Padding(
                                                  padding: EdgeInsets.all(20.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                Text('Please wait....',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ]));
                                        });
                                    print(widget.product.keys.toList());
                                    Map a =
                                        await activateServiceMerchantContract(
                                      widget.user.payload!.bvn ?? '',
                                      widget.product['merchant_id'],
                                      pin['pin'],
                                      widget.product['service_id'],
                                      widget.user.payload!.walletAddress ?? '',
                                      shipDest,
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
                                                      Get.offUntil(MaterialPageRoute(
                                            builder: (_) => 
                                            Manager(user: widget.user, pin: widget.pin)), (route) => false);
                                            brakey.changeManagerIndex(1);
                                            brakey.refreshUserDetail();
                                                    },
                                                  )
                                                ],
                                                title: const Text(
                                                    "Contract created!"),
                                                content: const Text(
                                                    'Your Service Contract has been created.'));
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
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                      // Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                                title: const Text(
                                                    "Can't Register service!"),
                                                content: Text(a['Message']));
                                          });
                                    }
                                  }
                                }),
                          
        ),
        );
  }
}
