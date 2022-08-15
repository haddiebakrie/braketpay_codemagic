import 'dart:convert';
import 'dart:typed_data';

import 'package:card_swiper/card_swiper.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../constants.dart';
import '../uix/listitemseparated.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class MerchantLoanDetail extends StatefulWidget {
  const MerchantLoanDetail({ Key? key, required this.loan}) : super(key: key);

  
  final Map loan;
  
  @override
  State<MerchantLoanDetail> createState() => _MerchantLoanDetailState();
}

class _MerchantLoanDetailState extends State<MerchantLoanDetail> {
  final imageController = PageController();


  @override
  Widget build(BuildContext context) {
List<Widget> images = [];
       if (widget.loan['loan_picture_links'] == null) {
      widget.loan['loan_picture_links'] = {'link_1': brokenImageUrl};
    }
    if (widget.loan['loan_categories'] == null) {
      widget.loan['loan_categories'] = {'category_1': 'others'};
    }
    for (int i=0; i < widget.loan['loan_picture_links'].length; i++) {
      setState(() {
        images.add(Image.network(widget.loan['loan_picture_links']['link_${i+1}']??'', width: double.infinity, height: double.infinity, fit: BoxFit.contain, ));
        
      });
      };
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: ContainerBackgroundDecoration(),
          child: Padding(padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  InkWell(
                        onTap: () {
                          Get.to(() => 
                          
                          PhotoView(
                          imageProvider: NetworkImage(widget.loan['loan_picture_links']['link_1']??brokenImageUrl,))
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
                          child: Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.loan['loan_picture_links'].length,
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
                                  child: Image.network(widget.loan['loan_picture_links'][widget.loan['loan_picture_links'].keys.toList()[index]], height: double.infinity, width: double.infinity, fit: BoxFit.cover),
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
                      SizedBox(height:20),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: Column(
                          children: [
                          ListTile(title: Text('Loan ID', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical:10),
                            child: Text(widget.loan['loan_id'], style: TextStyle(fontFamily: '')),
                          ),
                          trailing: Column(
                            children: [
                            Icon(CupertinoIcons.doc_on_doc_fill, size: 16, color: Colors.redAccent),
                            Text('copy', style: TextStyle(color: Colors.redAccent, fontSize: 13))
                            ]
                          ),
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: widget.loan['loan_id']));
                                Get.showSnackbar(const GetSnackBar(
                                    duration: Duration(seconds: 1),
                                    animationDuration: Duration(milliseconds: 10),
                                    forwardAnimationCurve: Curves.ease,
                                    messageText: Text(
                                        'Loan ID has been copied',
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
                          text: widget.loan['loan_title'],
                          title: 'Loan Title'),
                      // ListItemSeparated(
                      //     text: 'LOAN CONTRACT',
                      //     title: 'Contract Type'),
                      //     ListTile(
                      //       subtitle: Text(widget.loan['loan_description'],),
                      //       title: Text('Loan Description'),
                      //     ),
                      // ListItemSeparated(
                      //     text: 
                      //     title: ),
                      ListSeparated(
                          text: toTitleCase(widget.loan['interest_rate'].toString()+'%'),
                          title: 'Interest Rate'),
                      ListSeparated(
                          text: toTitleCase(widget.loan['loan_type']),
                          title: 'Loan Type'),
                      ListSeparated(
                          text: toTitleCase(jsonDecode(widget.loan['loan_period'])['loan period']),
                          title: 'Loan Period'),
                      ListSeparated(
                          text: toTitleCase(jsonDecode(widget.loan['loan_period'])['borrower repayment start time'].toString() + "months"),
                          title: 'Months before Loan repayment'),
                      ListSeparated(
                          text: formatAmount(widget.loan['loan_amount_range']['min'].toString()),
                          title: 'Minimum Loan Amount'),
                      ListSeparated(
                          text: formatAmount(widget.loan['loan_amount_range']['max'].toString()),
                          title: 'Maximum Loan Amount'),
                    ],
                  )),
                  SizedBox(height: 20),
                  Container(
                  decoration: ContainerDecoration(),
                      child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Loan QRCODE',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.memory(
              Uint8List.fromList(hex.decode(widget.loan['loan_qr_code']??'')),
            ),
                        ),
                    ])),
                     
          ],
          
          )),
        ),
      )
    );
  }
}