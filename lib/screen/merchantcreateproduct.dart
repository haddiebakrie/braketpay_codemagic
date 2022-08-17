import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:braketpay/api_callers/merchant.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/modified_packages/modified_elegant_number_button.dart';
import 'package:braketpay/screen/contract_chat.dart';
import 'package:braketpay/screen/index.dart';
import 'package:braketpay/screen/viewmerchant.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:iconly/iconly.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../constants.dart';
import '../uix/askpin.dart';
import '../utils.dart';

class MerchantCreateProductFromScan extends StatefulWidget {
  const MerchantCreateProductFromScan(
      {Key? key, required this.product, required this.user, required this.pin})
      : super(key: key);

  final Map product;
  final User user;
  final String pin;

  @override
  State<MerchantCreateProductFromScan> createState() =>
      _MerchantCreateProductFromScanState();
}

class _MerchantCreateProductFromScanState extends State<MerchantCreateProductFromScan> {
  Brakey brakey = Get.put(Brakey());
  late String shipFee = '';
  bool hasLoadError = false;
  String loadErrorMsg = '';
  late String shipDest = '';
  final imageController = PageController();
  late int quantity = 1;
  late String shipAddr = '';
  late String deliveryDays = '';
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final TextEditingController _shipFeeFieldController = TextEditingController();
  final TextEditingController _shipDestFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> images = [];
    if (widget.product['product_picture_links'] == null) {
      widget.product['product_picture_links'] = {'link_1': brokenImageUrl};
    }
    if (widget.product['categories'] == null) {
      widget.product['categories'] = {'category_1': 'others'};
    }
    for (int i=0; i < widget.product['product_picture_links'].length; i++) {
      setState(() {
        images.add(Image.network(
          widget.product['product_picture_links']['link_${i+1}']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, 
          errorBuilder: (_, __, ___) {
              return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
            },
          ));
        
      });
      };
    // widget.product.keys.forEach((element) {print(element);});
    // print(widget.product.keys);
    return Scaffold(  
      // backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(toolbarHeight: 1, elevation: 0, automaticallyImplyLeading: false, backgroundColor: Colors.transparent),
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
            Get.to(() => ChatScreen(user: widget.user, contract: widget.product, messages: []));
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
              BackButton(),
            ],
          ),
              Container(
                decoration: BoxDecoration(
                      // color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    margin: EdgeInsets.only(right: 15),
                child: IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.heart, )),
              ),
            
        ],
      ),
    ),
   
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  // decoration: ContainerBackgroundDecoration(),
                  padding: EdgeInsets.all(10).copyWith(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => 
                          
                          PhotoView(
                          imageProvider: NetworkImage(widget.product['product_picture_links']['link_${(imageController.page! + 1).toInt()}']??brokenImageUrl,
                          
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
                              // Image.network(widget.product['product_picture_links']['link_2']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, ),
                              // Image.network(widget.product['product_picture_links']['link_3']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, ),
                            
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
                                  itemCount: widget.product['product_picture_links'].length,
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
                                        // imageProvider: NetworkImage(widget.product['product_picture_links'][widget.product['product_picture_links'].keys.toList()[index]]??'',))
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
                                      child: Image.network(widget.product['product_picture_links'][widget.product['product_picture_links'].keys.toList()[index]], height: double.infinity, width: double.infinity, fit: BoxFit.cover),
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
                                              // print(widget.product.values.toList().elementAt(7)+'adflkajsdlfasdlfasdlfa');
                                              widget.product.forEach((key, value) {print("$key - $value");});
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(widget.product['business_name']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                ),
                                                isDismissible: false
                                              );
                                              // print(widget.product.keys.toList());
                                              Map a =
                                                            await fetchMerchantContract(
                                                                '',
                                                                'product',
                                                                widget.product['merchant_id'],
                                                                brakey.user.value!.payload!.walletAddress ??'',
                                                                brakey.user.value?.payload?.pin??'',
                                                                'all',
                                                                brakey.user.value?.payload?.password??'',
                                                                
                                                                );
                                                                print(a);
                                              if (a
                                                            .containsKey('Merchant')) {
                                                              // print(a['Merchant']);
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(widget.product['business_name']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                    Text("Seller: ${widget.product["business_name"]}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo, decoration: TextDecoration.underline )),
                                  ],
                                ),
                              ),
                              SizedBox(height:10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(widget.product['product_name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    
                                  ),
                                  SizedBox(width: 5,),
                                  Text('${nairaSign()}${widget.product["product_amount"]}', textAlign: TextAlign.left,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Text(widget.product["categories"]
                                          ['category_1'], style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),)
                              ),
                              SizedBox(height:25),
                              // Container(height: 1.5, color: Colors.grey),
                              // SizedBox(height:10),
                              Text('Product Detail', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              SizedBox(height:5),
                              MarkdownBody(
                                data: '${widget.product["product_details"]}'),
                              SizedBox(height:10),
            
                            ],
                          )),
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
                              Flexible(child: Text('${widget.product["business_name"]} accepts the terms of the contract', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
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
                              Flexible(child: Text('Money is only sent to ${widget.product["business_name"]} after you confirm the product is delivered to you', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
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
                          padding: EdgeInsets.all(20),
                          decoration: ContainerDecoration(),
                          child: Column(
                            children: [
                              // SizedBox(height: 10),
                              Text(
                                'Shipping Details',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              
                              SizedBox(height: 20),
                              Row(
                                children: [
                              Expanded(child: Text('Quantity', textAlign: TextAlign.left,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                  NumberButton(
                                    initialValue: quantity,
                                    minValue: 1,
                                    maxValue: 1000000,
                                    decimalPlaces: 0,
                                    color: Colors.redAccent,
                                    textStyle: TextStyle(color: Colors.white),
                                    step: 1,
                                    onChanged: (value) { // get the latest value from here
                                      setState(() {
                                        quantity = value.toInt();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height:10),
                              Row(
                                children: [
                              Expanded(child: Text('Amount', textAlign: TextAlign.left,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                Text('${nairaSign()} ${widget.product['product_amount']*quantity}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                                ],
                              ),
                              SizedBox(height:20),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Available locations', textAlign: TextAlign.start,
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                      RoundButton(
                                        text: 'Make request',
                                        color1: Colors.black,
                                        color2: Colors.black,
                                        textSize: 10,
                                        icon: CupertinoIcons.bubble_left_fill,
                                      )
                                  ],
                                ),
                              ),
                              Text('${widget.product["business_name"]} only ships to the following locations, you can also request for a location from ${widget.product["business_name"]} by clicking the "Make request button"', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600)),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // margin: EdgeInsets.only(bottom: 10),
                                      // child: Text(
                                      //   'Shipping Destination',
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.w600,
                                      //       fontSize: 15),
                                      // ),
                                    ),
                                  //   Text('${widget.product['business_name']} only ships this product to the following areas',
                                  // style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 15),
                                  // textAlign: TextAlign.center,
                                  // ),
                                    
                                  ],
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
                                            // popupTitle: Text('Select Your Location'),
                                            dropdownSearchDecoration: InputDecoration(
                                              hintText: 'Select State',
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            onChanged: (e) {
                                              setState(() {
                                              shipAddr = e;
                                              shipFee = e.replaceAll('(${nairaSign()})', '');
                                              shipFee = shipFee.replaceAll('(', '-');
                                              Map data = widget.product['delivery_data'];
                                              data.forEach((key, value) {
                                                // print(value['name']+  shipAddr);
                                                if (value['name'] == shipAddr) {
                                                    shipFee = value['amount'];
                                                    deliveryDays = value['delivery_days'];
                                                }
                                                }
                                              );
                                              print(shipFee);
                                                
                                              });
                                               
                                              // print(shipAddr)
                                            },
                                            // showSearchBox: true,
                                            // showClearButton: true,
                                            mode: Mode.DIALOG,
                                            searchDelay: Duration.zero,
                                            items: widget.product['delivery_data'].values.toList().map((e) => "${e['name']}").toList(),
                                            // selectedItem: ngStates.map((e) => e['name']).toList()[0]
                                            selectedItem: shipAddr != '' ? shipAddr : 'Select your Location'
                          
                                          ),
                                        ),
                                        Visibility(
                                          visible: shipAddr != '',
                                          child: Row(
                                            children: [
                                              Expanded(child: Text('${widget.product['business_name']} Ships to $shipAddr for ${nairaSign()}$shipFee')),
                                            ],
                                          )),
                                
                              // ListView.builder(
                              //       physics: NeverScrollableScrollPhysics(),
                              //       shrinkWrap: true,
                              //       itemCount: widget.product['delivery_data'].length,
                              //     itemBuilder: 
                              //     (builder, index) {
                              //       print( widget.product['delivery_data'][ widget.product['delivery_data'].keys.toList()[0]]);
                              //       return Container(
                              //         margin: EdgeInsets.symmetric(vertical:5),
                              //         child: Row(
                              //           children: [
                              //             Expanded(child: Text( widget.product['delivery_data'][widget.product['delivery_data'].keys.toList()[0]]['name'])),
                              //             // Text("${nairaSign()}${ widget.product['delivery_data'][0].values.first['amount']}"),
                              //             IconButton(
                              //               padding: EdgeInsets.zero,
                              //               visualDensity: VisualDensity(horizontal: -4),
                              //               iconSize: 17
                              //               ,onPressed: () {
                              //               setState(() {
                              //                widget.product['delivery_data'].removeAt(index);
                                              
                              //               });
                              //             }, icon: Icon(Icons.delete, color: Colors.redAccent,))
                              //           ],
                              //         ),
                              //       );
                              //     }
                              //     ),
                              
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        'House Address',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _shipFeeFieldController,
                                      cursorColor: Colors.grey,
                                      keyboardType: TextInputType.multiline,
                                      maxLength: null,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        prefixStyle: TextStyle(color: Colors.grey),
                                        fillColor:
                                            Color.fromARGB(24, 158, 158, 158),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        hintText: '13, Grace city Street\n',
                                        hintStyle: TextStyle(fontWeight: FontWeight.w600, ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                      ),
                                      onChanged: (text) {
                                        shipDest = text.trim();
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Your house address is required';
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
                    SizedBox(height: 20),
                      Container(
                        decoration: ContainerDecoration(),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                         SizedBox(height: 10),
                              Text(
                                'Fees',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                
                              SizedBox(height: 20,),
                              Row(
                                children: [
                              Expanded(child: Text('Product amount', textAlign: TextAlign.left,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Text('${formatAmount((widget.product['product_amount']*quantity).toString())}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                              Expanded(child: Text('Shipping fee', textAlign: TextAlign.left,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Text(shipFee == '' ? '-----' : shipFee, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                              Expanded(child: Text('Total', textAlign: TextAlign.left,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                Text("${nairaSign()}${double.tryParse(shipFee=='' ? '0' : shipFee)!.toDouble() + double.parse((widget.product['product_amount']*quantity).toString())}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                                ],
                              ),
                              // ListItemSeparated(title: 'Product Amount', text: ''),
                          ],
                        ),),
                            SizedBox(height: 150,),
                
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:  Container(
          decoration: ContainerDecoration().copyWith(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.all(10),
          child: RoundedLoadingButton(
                                borderRadius: 20,
                                // width: 70,
                                color: Colors.teal,
                                elevation: 0,
                                controller: _loginButtonController,
                                child: Text('Buy'),
                                onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (shipAddr=='') {
                                showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                actions: [
                                  TextButton(child: Text('Okay'), 
                                  onPressed: () {
                                    Get.close(1);
                                    _loginButtonController.reset();
                                  },
                                  )
                                ],
                                  title: const Text(
                                    'No Location selected',
                                    textAlign: TextAlign.center,
                                  ),
                                  // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                                  content: Row(children: const [
                                    Text('Please Select delivery location', style: TextStyle(fontWeight: FontWeight.w500))
                                  ]));
                            });
                              }
                            print(shipAddr);

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
                                    'Creating product contract',
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
                        Map a = await activateMerchantContract(
                           widget.user.payload!.bvn ?? '',
                            widget.product['merchant_id'],
                           pin['pin'],
                            widget.product['product_id'],
                           widget.user.payload!.walletAddress ?? '',
                           deliveryDays,
                            quantity,
                           "($shipAddr) $shipDest",
                           shipFee.toString()
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
                                    title: const Text("Contract created!"),
                                    content:  Text('Your Product Contract has been created.'));
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
                                    title: const Text("Can't create Template!"),
                                    content:  Text(a['Message']));
                              });

                        }
                                  }
                                }),
        ),
                
        );
  }
}
