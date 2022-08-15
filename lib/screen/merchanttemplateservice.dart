import 'dart:convert';
import 'dart:typed_data';

import 'package:braketpay/constants.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';

import '../uix/listitemseparated.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class MerchantServiceDetail extends StatefulWidget {
  const MerchantServiceDetail({ Key? key, required this.product}) : super(key: key);
  
  final Map product;
  
  @override
  State<MerchantServiceDetail> createState() => _MerchantServiceDetailState();
}

class _MerchantServiceDetailState extends State<MerchantServiceDetail> {
  final imageController = PageController();

  @override
  Widget build(BuildContext context) {
       List<Widget> images = [];
       if (widget.product['service_picture_links'] == null) {
      widget.product['service_picture_links'] = {'link_1': brokenImageUrl};
    }
    if (widget.product['service_categories'] == null) {
      widget.product['service_categories'] = {'category_1': 'others'};
    }
    for (int i=0; i < widget.product['service_picture_links'].length; i++) {
      setState(() {
        images.add(Image.network(widget.product['service_picture_links']['link_${i+1}']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, ));
        
      });
      };
    Map stages = jsonDecode(widget.product['about_service_delivery_stages']);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(toolbarHeight: 5, automaticallyImplyLeading: false, elevation: 0,),
      body: Column(
        children: [
          Container(
     height: kToolbarHeight,
      padding: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              BackButton(color: Colors.white),
          // Text('Products', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 22),),
            ],
          ),
          Row(
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //         color: Colors.white24,
              //         borderRadius: BorderRadius.circular(20)
              //       ),
              //       margin: EdgeInsets.only(right: 15),
              //   child: IconButton(
              //   onPressed: () {},
              //   icon: Icon(CupertinoIcons.heart, color: Colors.white)),
              // ),
          Container(
            decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
            child: IconButton(
                onPressed: () {
              print(widget.product);
                  Share.share('Hi there, ${widget.product['provider_business_name']} is offering ${widget.product['contract_title']}! - shop now on Braketpay @ ${widget.product['service_contract_link']}');
                },
                icon: Icon(Icons.share, color: Colors.white)),
          ),
            ],
          )
            
        ],
      ),
    ),
          Expanded(
            child: Container(
              decoration: ContainerBackgroundDecoration(),
              child: SingleChildScrollView(
                child: Padding(padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  InkWell(
                        onTap: () {
                          Get.to(() => 
                          
                          PhotoView(
                          imageProvider: NetworkImage(widget.product['service_picture_links']['link_1']??brokenImageUrl,))
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
                          child: Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.product['service_picture_links'].length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                // print(imageController.page);
                              return InkWell(
                                onTap: () {
                                      imageController.animateToPage(
                                        index,
                                        duration: Duration(milliseconds: 1),
                                        curve: Curves.linear
                                      );
          
                                  
                                    
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
                                  child: Image.network(widget.product['service_picture_links'][widget.product['service_picture_links'].keys.toList()[index]], height: double.infinity, width: double.infinity, fit: BoxFit.cover),
                                ),
                              );
                            } 
                            
                            ),
                          ),
                        ),
                        
                        
                          ],
                        ),
                      ),
                        SizedBox(height:20),
          
                Container(
                        decoration: ContainerDecoration(),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Contract Details',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height:10),
          
                              Padding(
                              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              child: Column(
                                children: [
                                ListTile(title: Text('Service ID', style: TextStyle(fontWeight: FontWeight.bold),), subtitle: Padding(
                                  padding: const EdgeInsets.symmetric(vertical:10),
                                  child: Text(widget.product['service_id'], style: TextStyle(fontFamily: '')),
                                ),
                                trailing: Column(
                                  children: [
                                  Icon(CupertinoIcons.doc_on_doc_fill, size: 16, color: Colors.redAccent),
                                  Text('copy', style: TextStyle(color: Colors.redAccent, fontSize: 13))
                                  ]
                                ),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text: widget.product['service_id']));
                                      Get.showSnackbar(const GetSnackBar(
                                          duration: Duration(seconds: 1),
                                          animationDuration: Duration(milliseconds: 10),
                                          forwardAnimationCurve: Curves.ease,
                                          messageText: Text(
                                              'Service ID has been copied',
                                              style:
                                                  TextStyle(color: Colors.white))));
                                },
                                ),
                                // Container(
                                //     color:Colors.grey.withOpacity(.5),
                                //     height: 1,
                                //     width: double.infinity)
                              ])),
                            
                            ListSeparated(
                                text: widget.product['contract_title'],
                                title: 'Contract Title'),
                            ListSeparated(
                                text: '${widget.product['contract_type'].toUpperCase()} CONTRACT',
                                title: 'Contract Type'),
                            ListSeparated(
                                text: 'NGN ${(widget.product['downpayment'].toString())}',
                                title: 'Downpayment'),
                            ListSeparated(
                                text: widget.product['delivery_duration'],
                                title: 'Delivers In', isLast: true,),
                        SizedBox(height: 20),],)),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(15),
                        decoration: ContainerDecoration(),
          
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                            Text(
                              'Service stages',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: stages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListItemSeparated(title: stages[stages.keys.toList()[index]]['about_stage'], text: formatAmount('${stages[stages.keys.toList()[index]]['cost_of_stage']}')),
                            );
                          },
                        ),
                      ],
                    ),        
                    ),
                        SizedBox(height: 20),
                        Container(
                        decoration: ContainerDecoration(),
                            child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Contract QRCODE',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),),
                              Image.memory(
                    Uint8List.fromList(hex.decode(widget.product['service_qrcode']??'')),
                  ),
                          ])),
                ],
                
                )),
              ),
            ),
          ),
        ],
      )
    );
  }
}