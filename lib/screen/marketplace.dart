import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/constants.dart';
import 'package:braketpay/screen/marketplace_loan.dart';
import 'package:braketpay/screen/marketplace_products.dart';
import 'package:braketpay/screen/marketplace_search.dart';
import 'package:braketpay/screen/marketplace_service.dart';
import 'package:braketpay/screen/merchantcreateservice.dart';
import 'package:braketpay/screen/notifications.dart';
import 'package:braketpay/screen/tabview.dart';
import 'package:braketpay/uix/shimmerwidgets.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:math' as math;


import '../api_callers/marketplace.dart';
import '../api_callers/merchant.dart';
import '../classes/product.dart';
import '../uix/product_list.dart';
import '../utils.dart';
import 'chats.dart';
import 'merchantcreateloan.dart';
import 'merchantcreateproduct.dart';


class MarketPlace extends StatefulWidget {
  @override
  _MarketPlaceState createState() => _MarketPlaceState();
}


class _MarketPlaceState extends State<MarketPlace> {
      List<String> timelines = ['Trending', 'Latest', 'For you',];
      String selectedTimeline = 'Trending';
      final Brakey brakey = Get.put(Brakey());
  late Future<Map> _products = fetchMarketContracts(
      brakey.user.value?.payload?.publicKey ?? "",
      brakey.user.value?.payload!.password ?? "",
      );
  // late Future<List<dynamic>> _service = fetchMarketServiceContracts(
  //     brakey.user.value?.payload?.publicKey ?? "",
  //     brakey.user.value?.payload!.password ?? "",
  //     );
  bool hasLoadError = false;
  String loadErrorMsg = '';

  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
      // color: Colors.amber,
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
            // Container(
            // decoration: BoxDecoration(
            //           // color: Colors.white24,
            //           borderRadius: BorderRadius.circular(20)
            //         ),child: Icon(Icons.storefront, color: Color.fromARGB(255, 255, 255, 255), size: 43)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Smart Contract', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20),),
                  Container(
                    // color: Colors.white10,
                    // padding: EdgeInsets.all(4),
                // crossAxisAlignment: CrossAxisAlignment.start,
                    child: Column(
                      children: [
                        Text('Marketplace', style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromARGB(255, 255, 255, 255), fontSize: 12),),
                      ],
                    )),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    margin: EdgeInsets.only(right: 15),
                child: IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.heart_fill, color: Colors.white)),
              ),
          Container(
                    margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
            child: IconButton(
                onPressed: () {
                  Get.to(ChatHistory());
                },
                icon: Icon(CupertinoIcons.bubble_right_fill, color: Colors.white)),
          ),
           Container(
            decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
            child: IconButton(
                onPressed: () {
                  Get.to(MarketPlaceSearch());
                },
                icon: Icon(CupertinoIcons.search, color: Colors.white)),
          ),
            ],
          )
            
        ],
      ),
    );

    
    Widget topHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              selectedTimeline = timelines[0];
              
            });
          },
          child: Text(
            timelines[0],
            style: TextStyle(
                fontSize: timelines[0] == selectedTimeline ? 30 : 14,
                color: timelines[0] == selectedTimeline ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w600,
                ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              selectedTimeline = timelines[1];
              
            });
          },
          child: Text(timelines[1],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                  fontSize: timelines[1] == selectedTimeline ? 30 : 14,
                color: timelines[1] == selectedTimeline ? Colors.white : Colors.white38
              )),
        ),
        InkWell(
          onTap: () {
            setState(() {
              selectedTimeline = timelines[2];
              
            });
          },
          child: Text(timelines[2],
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                  fontSize: timelines[2] == selectedTimeline ? 30 : 14,
                color: timelines[2] == selectedTimeline ? Colors.white : Colors.white38,
                  )),
        ),
      ],
    );



    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(children: [
          appBar,
          topHeader,
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            
          //   margin: EdgeInsets.symmetric(horizontal: 10),
          //   decoration: BoxDecoration(
          //             color: Colors.white24,
          //             borderRadius: BorderRadius.circular(20)
          //           ),
          //   child: TextField(
          //     textCapitalization: TextCapitalization.sentences,
          //     onChanged: (value) {},
          //     decoration: InputDecoration(
          //       // prefixIcon: Icon(Icons.search),
          //       contentPadding: EdgeInsets.zero,
          //     filled: true,
          //     fillColor: Colors.transparent,
          //     border: InputBorder.none,
          //       focusedBorder: InputBorder.none,
          //       hintText: 'Search Contracts',
          //       hintStyle: TextStyle(fontSize: 14, color: Colors.white30, fontWeight: FontWeight.w600)
          //     ),
          //   ),
          // ),
          // // AppBar(elevation: 0, title: Text('Contracts'), centerTitle: true,),
          Expanded(
            child: Container(
              decoration: ContainerBackgroundDecoration(),
              padding: EdgeInsets.all(5).copyWith(right: 0),
              margin: EdgeInsets.only(top: 20),
              child: RefreshIndicator(
              key: brakey.refreshMarket.value,
              onRefresh: () async {
                brakey.reloadUser('');
                final product = await fetchMarketContracts(
                    brakey.user.value?.payload?.publicKey?? '',
                    brakey.user.value?.payload?.password??''
                    
                    );
                    product['PRODUCT'].forEach((key) {
                      // key.keys.forEach((value) => print(value));
                      
                      });
                  // final service = await fetchMarketServiceContracts(
                  //   brakey.user.value?.payload?.publicKey?? '',
                  //   brakey.user.value?.payload?.password??''
                    
                  //   );
                setState(() {
                  _products = Future.value(product);
                  // _service = Future.value(service);
                });
              },
                child: SingleChildScrollView(
                  child: Column(
                    
                    children: [
                      Container(
                                     margin: EdgeInsets.only(top: 5),
                                    width: 60,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0).copyWith(bottom: 10),
                              child: Text('Product Contracts', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black45)),
                            ),
                             TextButton(
                                        onPressed: () => Get.to(() => MarketPlaceProducts()),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                          color: Colors.teal,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Text('View Products', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.white)),
                                        ),
                                      ),
                                  
                          ],
                        ),
                          Container(
                            // height: height * 0.25,
                            child: FutureBuilder<Map>(
                              future: _products,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                  case ConnectionState.active:
                                  {
                                    return Container(
                                      height: height * 0.25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                                  // physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: 6,
                                                  itemBuilder: (builder, index) {
                                                            return Container(
                                                              height: 140,
                                                              width: 180,
                                                              child: const SquareShimmer());
                                                          }));
                                  }

                                  case ConnectionState.done:
                                  int a;
                                    // TODO: Handle this case.
                                     if (snapshot.hasData) {
                                      print(snapshot.data!['PRODUCT']);
                                      selectedTimeline == 'For you' ? 
                                      snapshot.data!['PRODUCT'].sort((a, b) => 
                                      DateTime.parse(a['Payload']['date_product_registered']).compareTo(DateTime.parse(b['Payload']['date_product_registered']))
                                      ) : 
                                      selectedTimeline == 'Latest' ? 
                                      snapshot.data!['PRODUCT'].sort((a, b) => 
                                      DateTime.parse(a['Payload']['date_product_registered']).compareTo(DateTime.parse(b['Payload']['date_product_registered']))
                                      ) : 
                                      snapshot.data!['PRODUCT'].sort((a, b) => 
                                      int.parse(a['Payload']['activation_level'].toString()).compareTo(int.parse(b['Payload']['activation_level'].toString()))
                                      );

                                      snapshot.data!['PRODUCT'] = snapshot.data!['PRODUCT'].reversed.toList();
                                      // print(snapshot.data!['PRODUCT'][0]);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: height * 0.25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!['PRODUCT'].length.clamp(0, 8),
                                        itemBuilder: (BuildContext context, int index) {
                                          // print(snapshot.data);
                                          // return Container(
                                          //   child: Column(children: [

                                          //     Text(snapshot.data!['PRODUCT'][index]['Payload']['product_name'].toString())
                                          //   ],)
                                          // );
                                          List _templates = snapshot.data!['PRODUCT'];
                                          return InkWell(
                                            onTap: () async{
                                          print(snapshot.data?.keys??'no keys');
                                              _templates[index]['Payload'].forEach((key, value) => print(' $key ==> $value'));
                                              print(hasLoadError);
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(_templates[index]['Payload']['product_name'])}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                                                _templates[index]['Payload']['product_id'],
                                                                'product',
                                                                '',
                                                                brakey
                                                                        .user
                                                                        .value!
                                                                        .payload!
                                                                        .walletAddress ??
                                                                    '',
                                                                brakey.user.value?.payload?.pin??'',
                                                                'single',
                                                                brakey.user.value?.payload?.password??'',
                                                                
                                                                );
                                              if (a
                                                            .containsKey('Payload')) {
                                                          a['Payload'].addEntries({
                                                            'product_id': _templates[index]['Payload']['product_id']
                                                          }.entries);
                                                          // Navigator.of(context).pop();
                                                    Get.close(1);
                                                    hasLoadError = false;
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: ((context) =>
                                                                      MerchantCreateProductFromScan(
                                                                          product: a[
                                                                              'Payload'],
                                                                          user: brakey
                                                                              .user
                                                                              .value!,
                                                                          pin: brakey.user.value?.payload?.pin??''))));
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(_templates[index]['Payload']['contract_title']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                            child: Container(
                                                height: height * 0.25,
                                                width: 140,
                                                margin: EdgeInsets.all(10),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: ContainerDecoration(),
                                                      padding: EdgeInsets.all(5),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                                      ),
                                                        // child: Image()
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      child: Stack(
                                                        alignment: Alignment.bottomLeft,
                                                        children: [
                                                          Image.network(_templates[index]['Payload']['product_picture_links']?['link_1']??'https://firebasestorage.googleapis.com/v0/b/braketpay-mobile-app.appspot.com/o/assets%2Fimages.png?alt=media&token=2ca79fe2-172f-49ab-93bf-a6550ef78fa2', fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                                                          errorBuilder: (_, __, ___) {
                                                              return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
                                                            },),
                                                        // Padding(
                                                        //   padding: const EdgeInsets.only(left:8.0, bottom: 5),
                                                        //   child: BlurryContainer(
                                                        //     padding: EdgeInsets.all(3),
                                                        //     color: Colors.black.withOpacity(0.1),
                                                        //     borderRadius: BorderRadius.circular(5),
                                                        //     child: Text(_templates[index]['Payload']['contract_type']??'loan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                                                        // ),
                                                                SizedBox(height:4),
                                                        ],
                                                      ),
                                                      height: height * 0.15,
                                                      width: double.infinity,
                                                    ),
                                                                SizedBox(height:10),
                                          
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal:5.0),
                                                      child: Text(toTitleCase(_templates[index]['Payload']['product_name']??''),
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
                                          );
                                                      
                                        },
                                      ),
                                    ),
                                      
                                  ],
                                );

                                } else {
                                  return Container(
                                      height: height * 0.25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text('No internet Access, Pull down to refresh', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 20))),
                                      ));
                                }
                                }
                               
                              }
                            ),
                          ),
                       
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0).copyWith(bottom: 10),
                              child: Text('Service Contracts', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black45)),
                            ),
                            TextButton(
                                        onPressed: () => Get.to(() => MarketPlaceService()),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                          color: Colors.teal,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Text('View Services', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.white)),
                                        ),
                                      ),
                          ],
                        ),
                          Container(
                            child: FutureBuilder<Map>(
                              future: _products,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                  case ConnectionState.active:
                                  {
                                    return Container(
                                      height: height * 0.25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                                  // physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: 6,
                                                  itemBuilder: (builder, index) {
                                                            return Container(
                                                              height: 140,
                                                              width: 180,
                                                              child: const SquareShimmer());
                                                          }));
                                  }
                                  case ConnectionState.done:
                                if (snapshot.hasData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: height * 0.25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!['SERVICE'].length.clamp(0, 8),
                                        itemBuilder: (BuildContext context, int index) {
                                           List _templates = snapshot.data!['SERVICE'];
                                          return InkWell(
                                            
                                            onTap: () async {
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(_templates[index]['Payload']['contract_title']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                                                _templates[index]['Payload']['service_id'],
                                                                'service',
                                                                '',
                                                                brakey
                                                                        .user
                                                                        .value!
                                                                        .payload!
                                                                        .walletAddress ??
                                                                    '',
                                                                brakey.user.value?.payload?.pin??'',
                                                                'single',
                                                                  brakey.user.value?.payload?.password??'',
                                                                
                                                                );
                                              if (a
                                                            .containsKey('Payload')) {
                                                          a['Payload'].addEntries({
                                                            'service_id': _templates[index]['Payload']['service_id']
                                                          }.entries);
                                                          // Navigator.of(context).pop();
                                                          Get.close(1);
                                                          hasLoadError = false;
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: ((context) =>
                                                                      MerchantCreateServiceFromScan(
                                                                          product: a[
                                                                              'Payload'],
                                                                          user: brakey
                                                                              .user
                                                                              .value!,
                                                                          pin: brakey.user.value?.payload?.pin??''))));
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(_templates[index]['Payload']['contract_title']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                            child: Container(
                                                height: height * 0.25,
                                                width: 140,
                                                margin: EdgeInsets.all(10),
                                          
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: ContainerDecoration(),
                                          
                                                      padding: EdgeInsets.all(5),
                                                child: Column(
                                                  children: [
                                                  
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                                      ),
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      child: Stack(
                                                        alignment: Alignment.bottomLeft,
                                                        children: [
                                                          Image.network(
                                                            _templates[index]['Payload']['service_picture_links']?['link_1']??'https://firebasestorage.googleapis.com/v0/b/braketpay-mobile-app.appspot.com/o/assets%2Fimages.png?alt=media&token=2ca79fe2-172f-49ab-93bf-a6550ef78fa2', fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                                                            errorBuilder: (_, __, ___) {
                                                              return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
                                                            },
                                                            ),
                                                        // Padding(
                                                        //   padding: const EdgeInsets.only(left:8.0, bottom: 5),
                                                        //   child: BlurryContainer(
                                                        //     padding: EdgeInsets.all(3),
                                                        //     color: Colors.black.withOpacity(0.1),
                                                        //     borderRadius: BorderRadius.circular(5),
                                                        //     child: Text(_templates[index]['Payload']['contract_type']??'loan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                                                        // ),
                                                                SizedBox(height:4),
                                                        ],
                                                      ),
                                                      height: height * 0.15,
                                                      width: double.infinity,
                                                    ),
                                                                SizedBox(height:10),
                                          
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal:5.0),
                                                      child: Text(
                                                          toTitleCase(_templates[index]['Payload']['conntract_title']??''),
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
                                          );
                                                   
                                        },
                                      ),
                                    ),
                                    
                                  ],
                                );

                                } else {
                                  return Container(
                                      height: height * 0.25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text('No internet Access, Pull down to refresh', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 20))),
                                      ));
                                }}
                              }
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0).copyWith(bottom: 10),
                              child: Text('Loan Contracts', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black45)),
                            ),
                            TextButton(
                                        onPressed: () => Get.to(() => MarketPlaceLoan()),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                          color: Colors.teal,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Text('View Loans', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.white)),
                                        ),
                                      ),
                          ],
                        ),
                          Container(
                          // padding: const EdgeInsets.symmetric(vertical: 10.0),

                            child: FutureBuilder<Map>(
                              future: _products,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                  case ConnectionState.active:
                                  {
                                    return Container(
                                      height: height * 0.25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                                  // physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: 6,
                                                  itemBuilder: (builder, index) {
                                                            return Container(
                                                              height: 140,
                                                              width: 180,
                                                              child: const SquareShimmer());
                                                          }));
                                  }
                                  case ConnectionState.done:
                                if (snapshot.hasData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: height * 0.25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!['LOAN'].length.clamp(0, 8),
                                        itemBuilder: (BuildContext context, int index) {
                                           List _templates = snapshot.data!['LOAN'];
                                          return InkWell(
                                            onTap: () async {
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(_templates[index]['Payload']['contract_title']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                                                _templates[index]['Payload']['loan_id'],
                                                                'loan',
                                                                '',
                                                                brakey
                                                                        .user
                                                                        .value!
                                                                        .payload!
                                                                        .walletAddress ??
                                                                    '',
                                                                brakey.user.value?.payload?.pin??'',
                                                                'single',
                                                                brakey.user.value?.payload?.password??'',
                                                                
                                                                );
                                              if (a
                                                            .containsKey('Payload')) {
                                                          a['Payload'].addEntries({
                                                            'merchant_id': '',
                                                            'loan_id': _templates[index]['Payload']['loan_id']
                                                          }.entries);
                                                          Navigator.of(context).pop();
                                                          hasLoadError = false;
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: ((context) =>
                                                                      MerchantCreateLoanFromScan(
                                                                          loan: a,
                                                                          user: brakey
                                                                              .user
                                                                              .value!,
                                                                          pin: brakey.user.value?.payload?.pin??''))));
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
                                                            Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(_templates[index]['Payload']['contract_title']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
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
                                            child: Container(
                                                height: height * 0.25,
                                                width: 140,
                                                margin: EdgeInsets.all(10),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: ContainerDecoration(),
                                                      padding: EdgeInsets.all(5),
                                                child: Column(
                                                  children: [
                                                  
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
                                          
                                                      ),
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      child: Stack(
                                                        alignment: Alignment.bottomLeft,
                                                        children: [
                                                          Image.network(_templates[index]['Payload']['loan_picture_links']?['link_1']??'https://firebasestorage.googleapis.com/v0/b/braketpay-mobile-app.appspot.com/o/assets%2Fimages.png?alt=media&token=2ca79fe2-172f-49ab-93bf-a6550ef78fa2', fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                                                          errorBuilder: (_, __, ___) {
                                                              return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
                                                            },),                                                        // Padding(
                                                        //   padding: const EdgeInsets.only(left:8.0, bottom: 5),
                                                        //   child: BlurryContainer(
                                                        //     padding: EdgeInsets.all(3),
                                                        //     color: Colors.black.withOpacity(0.1),
                                                        //     borderRadius: BorderRadius.circular(5),
                                                        //     child: Text(_templates[index]['Payload']['contract_type']??'loan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                                                        // ),
                                                                SizedBox(height:4),
                                                        ],
                                                      ),
                                                      height: height * 0.15,
                                                      width: double.infinity,
                                                    ),
                                                                SizedBox(height:10),
                                          
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal:5.0),
                                                      child: Text(
                                                          toTitleCase(_templates[index]['Payload']['loan_title']),
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
                                          );
                                                   
                                        },
                                      ),
                                    ),
                                    // TextButton(
                                    //     onPressed: () {},
                                    //     child: Container(
                                    //       padding: EdgeInsets.all(10),
                                    //       decoration: BoxDecoration(
                                    //       color: Colors.teal,
                                    //           borderRadius: BorderRadius.circular(10)
                                    //       ),
                                    //       child: Text('View Laons', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.white)),
                                    //     ),
                                    //   ),
                                  ],
                                );

                                } else {
                                  return Container(
                                      height: height * 0.25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text('No internet Access, Pull down to refresh', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 20))),
                                      ));
                                }
                              }}
                            ),
                          ),
                        ],
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //   Text('Loans', style: TextStyle(fontWeight: FontWeight.w600)),
                      //     Container(
                      //       height: height * 0.25
                      //     ),
                      //   ],
                      // )
                    ]
                  ),
                ),
              ),
            ),
          )
        ]),
        // bottomNavigationBar: CustomBottomBar(controller: bottomTabController),
        
      ),
    );
  }
}