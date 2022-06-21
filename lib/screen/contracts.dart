import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/notifications.dart';
import 'package:braketpay/screen/profile.dart';
import 'package:braketpay/uix/contractmodeselect.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../api_callers/contracts.dart';
import '../classes/product_contract.dart';
import '../classes/user.dart';
import '../uix/contractlistcard.dart';
import '../uix/roundbutton.dart';
import '../uix/shimmerwidgets.dart';

class Contracts extends StatefulWidget {
  const Contracts({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;
  @override
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> {
  int asc = 0;
  int showOnly = 0;
  int hide = 0; 
  Brakey brakey = Get.put(Brakey());
  late Future<List<dynamic>> transactions = fetchContracts(
      widget.user.payload!.accountNumber ?? "",
      widget.user.payload!.password ?? "",
      widget.pin);
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        titleSpacing: 5,
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(icon:const Icon(CupertinoIcons.sort_down), onPressed:(){
        //     Get.bottomSheet(
        //       BottomSheet(
        //         backgroundColor: Colors.transparent,
        //         enableDrag: false,
        //         onClosing: () {}, 
        //         builder: (context) {
        //         return StatefulBuilder(
        //           builder: (context, changeState) {
        //             return Container(
        //               padding: const EdgeInsets.all(20),
        //               decoration: const BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight:Radius.circular(20))
        //             ),
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                const Text(
        //                     'Filter',
        //                     style: TextStyle(
        //                         fontSize: 20, fontWeight: FontWeight.w300),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Row(children: [
        //                       const Expanded(child: Text('Sort by')),
        //                       Container(
        //                         height: 35,
        //                         margin: EdgeInsets.all(5),
        //                         color: asc == 0 ? Colors.black : Colors.transparent,
        //                         child: TextButton(child: Text('ASC', style: TextStyle(color: asc == 0 ? Colors.white : Colors.black)), 
                                
        //                         onPressed: () {
        //                           setState(() {
        //                             asc = 0;
        //                           });
        //                           changeState(() {

        //                           });
        //                         }),
        //                       ),
        //                       Container(
        //                         height: 35,
        //                         margin: EdgeInsets.all(5),
        //                         color: asc == 1 ? Colors.black : Colors.transparent,
        //                         child: TextButton(child: Text('DESC', style: TextStyle(color: asc == 1 ? Colors.white : Colors.black)), 
                                
        //                         onPressed: () {
        //                           setState(() {
        //                             asc = 1;
        //                           });
        //                           changeState(() {

        //                           });
        //                         }),
        //                       ),
        //                     ],),
        //                   ),
        //                   Row(children: [
        //                     const Expanded(child: Text('Show')),
        //                     Container(
        //                         height: 35,
        //                         margin: EdgeInsets.all(5),
        //                         color: showOnly == 0 ? Colors.black : Colors.transparent,
        //                         child: TextButton(child: Text('All', style: TextStyle(color: showOnly == 0 ? Colors.white : Colors.black)), 
                                
        //                         onPressed: () {
        //                           setState(() {
        //                             showOnly = 0;
        //                           });
        //                           changeState(() {

        //                           });
        //                         }),
        //                       ),
        //                     Container(
        //                         height: 35,
        //                         margin: EdgeInsets.all(5),
        //                         color: showOnly == 1 ? Colors.black : Colors.transparent,
        //                         child: TextButton(child: Text('Approved', style: TextStyle(color: showOnly == 1 ? Colors.white : Colors.black)), 
                                
        //                         onPressed: () {
        //                           setState(() {
        //                             showOnly = 1;
        //                           });
        //                           changeState(() {

        //                           });
        //                         }),
        //                       ),
        //                     Container(
        //                         height: 35,
        //                         margin: EdgeInsets.all(5),
        //                         color: showOnly == 2 ? Colors.black : Colors.transparent,
        //                         child: TextButton(child: Text('Pending', style: TextStyle(color: showOnly == 2 ? Colors.white : Colors.black)), 
                                
        //                         onPressed: () {
        //                           setState(() {
        //                             showOnly = 2;
        //                           });
        //                           changeState(() {

        //                           });
        //                         }),
        //                       ),
        //                   ],),
        //                   Row(children: [
        //                     const Expanded(child: Text('Hide')),
        //                     Container(
        //                         height: 35,
        //                         margin: EdgeInsets.all(5),
        //                         color: hide == 0 ? Colors.black : Colors.transparent,
        //                         child: TextButton(child: Text('None', style: TextStyle(color: hide == 0 ? Colors.white : Colors.black)), 
                                
        //                         onPressed: () {
        //                           setState(() {
        //                             hide = 0;
        //                           });
        //                           changeState(() {

        //                           });
        //                         }),
        //                       ),
        //                     Container(
        //                         height: 35,
        //                         margin: EdgeInsets.all(5),
        //                         color: hide == 1 ? Colors.black : Colors.transparent,
        //                         child: TextButton(child: Text('Product', style: TextStyle(color: hide == 1 ? Colors.white : Colors.black)), 
                                
        //                         onPressed: () {
        //                           setState(() {
        //                             hide = 1;
        //                           });
        //                           changeState(() {

        //                           });
        //                         }),
        //                       ),
        //                     Container(
        //                         height: 35,
        //                         margin: EdgeInsets.all(5),
        //                         color: hide == 2 ? Colors.black : Colors.transparent,
        //                         child: TextButton(child: Text('Service', style: TextStyle(color: hide == 2 ? Colors.white : Colors.black)), 
                                
        //                         onPressed: () {
        //                           setState(() {
        //                             hide = 2;
        //                           });
        //                           changeState(() {

        //                           });
        //                         }),
        //                       ),
        //                   ],),
        //             ],)
        //             );
        //           }
        //         );}
        //       )

        //     );
        //   })
        // ],
        // // actions: [
        // //   Obx(() => IconBadge(
        // //     onTap: () {
        // //       Navigator.of(context).push(MaterialPageRoute(builder: 
        //     ((context) => Notifications(user:widget.user, pin: widget.pin)
        //     )));
        //     },
        //     maxCount: 9,
        //     icon: Icon(Icons.notifications),
        //     itemCount: brakey.notiCount.toInt(),
        //     right: 10.0,
        //     hideZero: true,
        //     top:10.0

        //     // hideZero: true,
            
        //     ))
        // ],
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('Contracts',
              // textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        // centerTitle: true,
        // leading: Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        //   child: Container(
        //     decoration: BoxDecoration(
        //         color: Colors.white,
        //         border: Border.all(color: Colors.white),
        //         borderRadius: BorderRadius.circular(20)),
        //     child: IconButton(
        //         icon: const Icon(IconlyBold.profile),
        //         color: Theme.of(context).primaryColor,
        //         iconSize: 20,
        //         onPressed: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) =>
        //                   Profile(user: widget.user, pin: widget.pin)));
        //         }),
        //   ),
        // ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical:10),
          decoration: ContainerBackgroundDecoration(),
          child: RefreshIndicator(
            key: brakey.refreshContracts.value,
            onRefresh: () async {
              final _transactions = await fetchContracts(
                  widget.user.payload!.accountNumber ?? "",
                  widget.user.payload!.password ?? "",
                  widget.pin);
                  // if (transactions.isNotEmpty) {
              setState(() {
                transactions = Future.value(_transactions);
              });
                  // }
            },
            child: FutureBuilder<List>(
              future: transactions,
              builder: (context, snapshot) {
                List _data = List.from(snapshot.data??[]);
                  // if (snapshot.hasData && hide==2 && snapshot.data!.isNotEmpty) {
                  // _data.removeWhere((element) => element.isService());
                  // }
                  // else if (snapshot.hasData && hide==1 && snapshot.data!.isNotEmpty) {
                  // _data.removeWhere((element) => !element.isService());
                  // }
                  // if (snapshot.hasData && showOnly==2 && snapshot.data!.isNotEmpty) { 
                  //   _data.removeWhere((element) => element.payload!.states!.approvalState.toLowerCase() == 'approved');
                  // } else if (snapshot.hasData && showOnly==1 && snapshot.data!.isNotEmpty) { 
                  //   _data.removeWhere((element) => element.payload!.states!.approvalState!.toLowerCase() == 'not approved');
                  // }
                  // print(_data);
                if (snapshot.hasData) {
                  return _data.isNotEmpty
                      ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    ProductContract transaction = snapshot.data![index];
                    return ContractListCard(pin: widget.pin, product: snapshot.data![index], user: widget.user);})
                      : ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height-120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/empty.png', width: 140),
                                const SizedBox(height:20),
                                const Center(
                                  child: Text('You have not created any contract!'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: double.infinity,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/sammy-no-connection.gif',
                            width: 150),
                        const Text(
                            "No internet access\nCouldn't Load Contract History!",
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        RoundButton(
                            text: 'Retry',
                            color1: Colors.black,
                            color2: Colors.black,
                            onTap: () {
                              brakey.refreshContracts.value!.currentState!
                                  .show();
                            }
                            )
                      ],
                    )),
                  );
                }

                return ListView.builder(itemBuilder: (builder, index) {
                  return const ContractCardShimmer();
                });
              },
            ),
          )),
      floatingActionButton: RoundButton(
          onTap: () {
            contractMode();
          },
          text: 'Create'),
    );
  }

  Future<dynamic> contractMode() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (context) {
          return ContractModeSelect(user: widget.user, pin: widget.pin);
        });
  }
}
