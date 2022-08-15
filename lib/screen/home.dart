import 'dart:io';
import 'dart:ui';

import 'package:braketpay/api_callers/transactions.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:braketpay/screen/buydata.dart';
import 'package:braketpay/screen/bvn.dart';
import 'package:braketpay/screen/bvnprompt.dart';
import 'package:braketpay/screen/cabletv.dart';
import 'package:braketpay/screen/contracts.dart';
import 'package:braketpay/screen/createproduct.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/createservice.dart';
import 'package:braketpay/screen/notifications.dart';
import 'package:braketpay/screen/profile.dart';
import 'package:braketpay/screen/qrcodescanner.dart';
import 'package:braketpay/screen/recharge.dart';
import 'package:braketpay/screen/referral.dart';
import 'package:braketpay/screen/savings.dart';
import 'package:braketpay/screen/transfer.dart';
import 'package:braketpay/screen/upload_dp.dart';
import 'package:braketpay/screen/wallet.dart';
import 'package:braketpay/uix/askpin.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:braketpay/brakey.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:braketpay/screen/utilities.dart';
import 'package:braketpay/uix/transactioncard.dart';
import 'package:braketpay/uix/walletcard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../api_callers/contracts.dart';
import '../classes/product_contract.dart';
import '../modified_packages/icon_badge.dart';
import '../uix/actionbutton.dart';
import '../uix/contractlistcard.dart';
import '../uix/contractmodeselect.dart';
import '../uix/roundbutton.dart';
import '../uix/shimmerwidgets.dart';
import '../uix/utilitybutton.dart';
import '../utils.dart';
import 'chats.dart';
import 'electricity.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.user, required this.pin, this.gotoWallet})
      : super(key: key);

  final User user;
  final String pin;
  final Function? gotoWallet;
  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Brakey brakey = Get.put(Brakey());
  late Future<List<dynamic>> _contracts = fetchContracts(
      widget.user.payload!.accountNumber ?? "",
      widget.user.payload!.password ?? "",
      widget.pin);
  late Future<List<dynamic>> _transactions = fetchTransactions(
      widget.user.payload!.accountNumber ?? "",
      widget.user.payload!.password ?? "",
      widget.pin);
  final walletsController = CarouselController();
  
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(gradient: 
              LinearGradient(
                
                begin: Alignment.centerLeft,
                colors: [Color.fromARGB(255, 61, 3, 143), Color.fromARGB(255, 19, 1, 213)])
              ),
          // color: Theme.of(context).primaryColor
          ),
                Image.asset('assets/braket-bg_grad-01.png', height: 300, fit: BoxFit.cover, width: double.infinity,),

        Scaffold(
          extendBody: true,
backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            titleSpacing: 2,
            toolbarHeight: 65,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  padding: EdgeInsets.zero,
                    icon: Text(brakey.user.value?.payload?.fullname?[0]??'', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize:18),),
                    color: Theme.of(context).primaryColor,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Profile(user: widget.user, pin: widget.pin)));
                    }),
              ),
            ),
            actions: [
              Obx(() => IconBadge(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) =>
                            Notifications(user: widget.user, pin: widget.pin))));
                  },
                  maxCount: 9,
                  icon: const Icon(Icons.notifications),
                  itemCount: brakey.notiCount.toInt(),
                  right: 10.0,
                  hideZero: true,
                  top: 10.0

                  )),
              Obx(() => IconBadge(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) =>
                            ChatHistory())));
                  },
                  maxCount: 9,
                  icon: const Icon(CupertinoIcons.bubble_left_fill),
                  itemCount: brakey.notiCount.toInt(),
                  right: 10.0,
                  hideZero: true,
                  top: 10.0

                  ))
            ],
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                    'Hi ${brakey.user.value?.payload?.fullname?.split(" ")[1]}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                Obx(() => Text('@${brakey.user.value?.payload?.username}',
                    style: const TextStyle(fontSize: 12)))
              ],
            ),
          ),
          body: Stack(
            children: [

              Column(
                children: [
                // SizedBox(height: 100,),
                SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: CarouselSlider(
                      carouselController: walletsController,
                      items: [
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: WalletCard(
                            showLeftButton: false,
                              rightButtonIcon: Icons.open_in_new_rounded,
                              leftButtonLabel: 'claim',
                              leftButtonIcon: Icons.card_giftcard_outlined,
                              onTapFund: () {
                                Get.to(() => ReferralBonus());
                              },
                              onTapSend: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SendMoney(
                                            user: widget.user, pin: widget.pin)));
                              },
                              rightButtonLabel: 'View',
                              balance: '0',
                              title: 'Refferal Bonus',
                              ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Obx(() => WalletCard(
                              // showAccountNumber: true,
                              rightButtonIcon: IconlyBold.wallet,
                              leftButtonIcon: IconlyBold.send,
                                onTapSend: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SendMoney(
                                              user: widget.user, pin: widget.pin)));
                                },
                                onTapFund: () {
                                  Get.to(() => Wallet(user: widget.user, pin: widget.pin));
                                },
                                balance: brakey.user.value!.payload!.accountBalance
                                    .toString(),
                                title: 'Braket Wallet'))),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Obx(() => WalletCard(
                            leftButtonLabel: 'save',
                            rightButtonLabel: 'break',
                            leftButtonIcon: CupertinoIcons.lock_fill,
                              rightButtonIcon: CupertinoIcons.lock_open_fill,
                                onTapFund: () {
                                  widget.gotoWallet != null
                                      ? widget.gotoWallet!()
                                      : print('null function');
                                },
                                onTapSend: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SendMoney(
                                              user: widget.user, pin: widget.pin)));
                                },
                                balance: brakey.savedBalance.toString(),
                                title: 'Braket Savings'),
                          ),
                        )
                      ],
                      options: CarouselOptions(
                          enlargeCenterPage: true,
                          initialPage: 1,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.9,
                          enlargeStrategy: CenterPageEnlargeStrategy.height
                          ),
                    )),
                
                SizedBox(height: 20,),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      // margin: const EdgeInsets.only(top: 20),
                      // width: double.infinity,
                      decoration: ContainerBackgroundDecoration(),
                      child: RefreshIndicator(
                        key: brakey.refreshAll.value,
                        onRefresh: () async {
                          brakey.reloadUser(widget.pin);
                          final contracts = await fetchContracts(
                              widget.user.payload!.accountNumber ?? "",
                              widget.user.payload!.password ?? "",
                              widget.pin);
                          final transactions = await fetchTransactions(
                              widget.user.payload!.accountNumber ?? '',
                              widget.user.payload!.password ?? "",
                              widget.pin);
                          setState(() {
                            _contracts = Future.value(contracts);
                            _transactions = Future.value(transactions);
                          });
                        },
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Center(
                                  child: Container(
                                     margin: EdgeInsets.only(top: 5),
                                    width: 60,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              } else if (index == 1) {
                                return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: ContainerDecoration(),

                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        // Text('Create Contract', style: TextStyle(fontWeight: FontWeight.w600)),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            ActionButton(title: 'Buy & Sell', icon: Icon(IconlyBold.buy, size: 30, color: Color.alphaBlend(Color.fromARGB(255, 0, 8, 255), Colors.blueAccent)), onTap: () {
                                              productPrompt();
                                            },),
                                            ActionButton(title: 'Service', icon: const Icon(CupertinoIcons.paintbrush_fill, size: 30, color: Colors.teal), onTap: () {
                                              servicePrompt();
                                            },),
                                            ActionButton(title: 'Loan', icon:  
                                            Image.asset('assets/naira.png', height: 32), onTap: () {
                                            loanPrompt();
                                        },),
                                            ActionButton(title: 'Pay bills', icon: const Icon(Icons.lightbulb, size: 30, color: Colors.red), onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => Utilities(user: widget.user, pin: widget.pin)));
                                              
                                            },),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 20),
                                        // Row(
                                        //   children: [
                                        // ActionButton(title: 'Airtime', icon: const Icon(Icons.phone_iphone_rounded, size: 30, color: Colors.blue), onTap: () {
                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => Recharge(user: widget.user, pin: widget.pin)));

                                        // },),
                                        // ActionButton(title: 'Data', icon: Icon(CupertinoIcons.wifi, size: 30, color: Theme.of(context).primaryColor), onTap: () {
                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => BuyData(user: widget.user, pin: widget.pin)));

                                        // },),
                                        // ActionButton(title: 'Electricity', icon: const Icon(Icons.lightbulb, size: 30, color: Color.fromARGB(255, 35, 57, 255)), onTap: () {
                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => Electricity(user: widget.user, pin: widget.pin)));

                                        // },),
                                        // ActionButton(title: 'Cable TV', icon: const Icon(CupertinoIcons.tv_fill, size: 30, color: Colors.lightBlue), onTap: () {
                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => CableTV(user: widget.user, pin: widget.pin)));


                                        // },),
                                        //   ],
                                        // ),
                                        // ActionButton(title: 'Electricity', icon: Icon(CupertinoIcons.tv_fill, size: 30)),
                                        
                                      ]
                                    ));
                              } else if (index == 2) {
                                return Container(
                                );
                              
                              } else if (index == 6) {
                                return InkWell(
                                  onTap: (() async {
                                    // Get.to(() => ReferralBonus());
                                    final cameras = await availableCameras();
                                    Get.to(UploadProfilePicture(cameras: cameras));
                                    
                                  }),
                                  child: Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 320,
                                      decoration: const BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(20))),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(30.0).copyWith(bottom: 0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Flexible(
                                                  child: Text(
                                                'Get Bonus for telling your friends about BraketPay',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                              Hero(
                                                tag: 'referral_box',
                                                child: Image.asset(
                                                  'assets/open_gift.png',
                                                  height: 180,
                                                ),
                                              ),
                                            ]),
                                      )),
                                );
                              } else if (index == 4) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal:10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Text('My Active contracts',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700)),
                                            TextButton(onPressed: () {

                                                Get.to(() => Contracts(user: widget.user, pin: widget.pin));
                                            }, child: 
                                            Text('view all', style: TextStyle(color: Colors.redAccent))
                                            )
                                          ],
                                        )),
                                    SizedBox(
                                      height: 250,
                                      child: FutureBuilder<List>(
                                        future: _contracts,
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                            case ConnectionState.active:
                                              {
                                                return ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: 4,
                                                  itemBuilder: (builder, index) {
                                                            return const ContractCardShimmer();
                                                          });
                                              }
                                            case ConnectionState.done:
                                              {
                                                if (snapshot.hasData) {
                                                  return snapshot.data!.isNotEmpty
                                                      ? ListView.builder(
                                                          padding: const EdgeInsets.only(top:7),

                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: snapshot
                                                                  .data!.isNotEmpty
                                                              ? snapshot.data!.length.clamp(0, 3)
                                                              : 0,
                                                          itemBuilder:
                                                              (context, index) {
                                                                
                                                            ProductContract product =
                                                                snapshot.data![index];
                                                            return ContractListCard(
                                                                product: product,
                                                                pin: widget.pin,
                                                                user: widget.user);
                                                          })
                                                      : Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottom:
                                                                        Radius.zero),
                                                          ),
                                                          child: Center(
                                                              child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                  'assets/empty.png',
                                                                  width: 140),
                                                              const SizedBox(height: 20),
                                                              const Text(
                                                                  "You have not created any contracts yet!",
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              const SizedBox(height: 20),
                                                              RoundButton(
                                                                  width: 140,
                                                                  text:
                                                                      'Create contract',
                                                                  color1: Colors.black,
                                                                  color2: Colors.black,
                                                                  onTap: () {
                                                                    contractMode();
                                                                  })
                                                            ],
                                                          )));
                                                } else if (snapshot.hasError) {
                                                  return Container(
                                                      decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top:
                                                                    Radius.circular(20),
                                                                bottom: Radius.zero),
                                                      ),
                                                      child: Center(
                                                          child: Column(
                                                        children: [
                                                          Image.asset(
                                                              'assets/sammy-no-connection.gif',
                                                              width: 100),
                                                          const Text(
                                                              "No internet access\nCouldn't Load Contract History!",
                                                              textAlign:
                                                                  TextAlign.center),
                                                          const SizedBox(height: 20),
                                                          RoundButton(
                                                              icon: Icons.refresh,
                                                              text: 'Retry',
                                                              color1: Colors.black,
                                                              color2: Colors.black,
                                                              onTap: () {
                                                                print(brakey.user.value?.payload?.deviceInfo);
                                                                // askPin(_pinEditController, _pinErrorController)
                                                                brakey
                                                                    .refreshUserDetail();
                                                              })
                                                        ],
                                                      )));
                                                }
                                              }
                                          }

                                          return ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),

                                            shrinkWrap: true,
                                                  itemCount: 3,
                                                  itemBuilder: (builder, index) {
                                                            return const ContractCardShimmer();
                                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else if (index == 5) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal:10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Text('Recent Transactions',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700)),
                                            TextButton(onPressed: () {
                                              brakey.changeManagerIndex(2);
                                            }, child: 
                                            Text('view all', style: TextStyle(color: Colors.redAccent))
                                            )
                                          ],
                                        )),
                                    SizedBox(
                                      height: 250,
                                      child: FutureBuilder<List>(
                                        future: _transactions,
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                            case ConnectionState.active:
                                              {
                                                return ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),

                                                  shrinkWrap: true,
                                                  itemCount: 3,
                                                  itemBuilder: (builder, index) {
                                                            return const ContractCardShimmer();
                                                          });
                                              
                                              }
                                            case ConnectionState.done:
                                              {
                                                if (snapshot.hasData) {
                                                  return snapshot.data!.isNotEmpty
                                                      ? ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: snapshot
                                                                  .data!.isNotEmpty
                                                              ? snapshot.data!.length
                                                              : 0,
                                                          itemBuilder:
                                                              (context, index) {
                                                            Transaction transaction =
                                                                snapshot.data![index];
                                                            return TransactionListCard(
                                                                transaction:
                                                                    transaction,
                                                                user: widget.user);
                                                          })
                                                      : Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottom:
                                                                        Radius.zero),
                                                          ),
                                                          child: Center(
                                                              child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                  'assets/empty.png',
                                                                  width: 140),
                                                              const SizedBox(height: 20),
                                                              const Text(
                                                                  "You have not made any transaction yet!",
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              
                                                            ],
                                                          )));
                                                } else if (snapshot.hasError) {
                                                  return Container(
                                                      decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top:
                                                                    Radius.circular(20),
                                                                bottom: Radius.zero),
                                                      ),
                                                      child: Center(
                                                          child: Column(
                                                        children: [
                                                          Image.asset(
                                                              'assets/sammy-no-connection.gif',
                                                              width: 120),
                                                          const Text(
                                                              "No internet access\nCouldn't Load Transaction History!",
                                                              textAlign:
                                                                  TextAlign.center),
                                                          const SizedBox(height: 20),
                                                          RoundButton(
                                                              icon: Icons.refresh,
                                                              text: 'Retry',
                                                              color1: Colors.black,
                                                              color2: Colors.black,
                                                              onTap: () {
                                                                brakey
                                                                    .refreshUserDetail();
                                                              })
                                                        ],
                                                      )));
                                                }
                                              }
                                          }

                                          return ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),

                                            shrinkWrap: true,
                                                  itemCount: 3,
                                                  itemBuilder: (builder, index) {
                                                            return const ContractCardShimmer();
                                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Container();
                              //  }
                              //    Container(
                              //      height: 150,
                              //      decoration: BoxDecoration(
                              //        color: Colors.blueAccent,
                              //        borderRadius: BorderRadius.all(Radius.circular(20))
                              //      ),
                              //      child: Row(
                              //        children: [

                              //        ]
                              //      )
                              //    )
                              //  ],
                            }),
                      )),
                )
              ]),
            ],
          ),
          // floatingActionButton: ElevatedButton(
          //     onPressed: () {
          //       contractMode();
          //     },
          //     child: SizedBox(
          //       width: 70,
          //       height: 40,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: const [
          //           Icon(
          //             IconlyBold.paper_plus,
          //             color: Colors.white,
          //           ),
          //           Text(
          //             'Create',
          //             style: TextStyle(color: Colors.white),
          //           )
          //         ],
          //       ),
          //     )),
        ),
      ],
    );
  }

  contractMode() {
    Get.to(() => ContractModeSelect(user: widget.user, pin: widget.pin));
    // return showModalBottomSheet(
    //     context: context,
    //     isDismissible: true,
    //     enableDrag: true,
    //     backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
    //     isScrollControlled: true,
    //     builder: (context) {
    //       return ContractModeSelect(user: widget.user, pin: widget.pin);
    //     });
  }
}
