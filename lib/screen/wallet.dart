import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/modified_packages/modified_creditcardwidget.dart';
import 'package:braketpay/screen/bvnprompt.dart';
import 'package:braketpay/screen/notifications.dart';
import 'package:braketpay/screen/profile.dart';
import 'package:braketpay/screen/referral.dart';
import 'package:braketpay/screen/transfer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:braketpay/uix/walletcard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../uix/askpin.dart';
import '../uix/roundbutton.dart';
import '../uix/themedcontainer.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  List<Map> cards = [
    // {'cardNumber': '50601029837500000083',
    // 'expiryDate': '19/24',
    // 'cardHolderName': 'Abubakry Alamin',
    // 'cvvCode': '***'},
    // {'cardNumber': '51861029837500000083',
    // 'expiryDate': '19/24',
    // 'cardHolderName': 'Opeyemi Lawal',
    // 'cvvCode': '***'},
  ];
  String cardNumber = '';
        String expiryDate = '';
        String cardHolderName = '';
        String cvvCode = '';
  Brakey brakey = Get.put(Brakey());
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final CarouselController walletController = CarouselController();
  @override
  Widget build(BuildContext context) {
    // walletController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.ease);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 5,

        centerTitle: true,       
        title: Text('Wallet')
      ),
      body: Column(children: [
        // SizedBox(
        //     height: 150,
        //     width: double.infinity,
        //     child: CarouselSlider(
        //       carouselController: walletController,
        //       items: [
        //         Padding(
        //           padding: const EdgeInsets.only(left: 5),
        //           child: WalletCard(
        //               onTapFund: () {
        //                 Get.to(ReferralBonus());
        //               },
        //               onTapSend: () {
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => SendMoney(
        //                             user: widget.user, pin: widget.pin)));
        //               },
        //               rightButtonLabel: 'View',
        //               balance: '0',
        //               title: 'Refferal Bonus'),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(left: 5),
        //           child: Obx(() => WalletCard(
        //             onTapSend: () {
        //               Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => SendMoney(user: widget.user, pin: widget.pin)));
        //             },
        //             onTapFund: () {
        //               setState(() {brakey.changeManagerIndex(3);});
        //             },
        //               balance: brakey.user.value!.payload!.accountBalance.toString(),
        //               title: 'Braket Wallet'))
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(left: 5),
        //           child: WalletCard(
        //               onTapSend: () {
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => SendMoney(
        //                             user: widget.user, pin: widget.pin)));
        //               },
        //               balance: '0',
        //               title: 'Braket Savings'),
        //         )
        //       ],
        //       options: CarouselOptions(
        //           enlargeCenterPage: true,
        //           initialPage: 1,
        //           enableInfiniteScroll: false,
        //           viewportFraction: 0.9,
        //           enlargeStrategy: CenterPageEnlargeStrategy.height),
        //     )),
        
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            // margin: const EdgeInsets.only(top: 20),
            width: double.infinity,
            decoration: ContainerBackgroundDecoration(),
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {},
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Center(
                      child: Container(
                         margin: EdgeInsets.only(bottom: 10),
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  } else if (index == 1) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                        decoration: ContainerDecoration(),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Fund your wallet with Debit card',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          cards.isEmpty ? 
                          
                          Column(
                            children: [
                              Image.asset('assets/cre.png', width: 150),
                              const SizedBox(height:10),
                              const Text('You have not added any card yet', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height:10),
                              RoundButton(
                              color1: NeutralButton,
                              color2: NeutralButton,
                              width: 200,
                              text: 'Fund wallet',
                              onTap: () {
                                        addBankCard();
                                
                              })
                            ],
                          )
                          : Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                      icon: const Icon(Icons.add, color: Colors.white),
                                      onPressed: () {
                                        addBankCard();
                                      })),
                              Expanded(
                                child: CarouselSlider.builder(
                                  itemCount: cards.length,
                                  itemBuilder: (context, index, i) {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black,
                                      ),
                                      child: CreditCardWidget(
                                        isHolderNameVisible: true,
                                          // glassmorphismConfig: Glassmorphism.defaultConfig(),
                                          cardNumber: cards[index]['cardNumber'],
                                          cardBgColor: Colors.transparent,
                                          expiryDate: cards[index]['expiryDate'],
                                          cardHolderName: cards[index]['cardHolderName'],
                                          cvvCode: cards[index]['cvvCode'],
                                          height: 350,
                                          showBackView: false,
                                          isSwipeGestureEnabled: false,
                                          onCreditCardWidgetChange: (e) {}),
                                    );
                                  },
                                  // items: [
                                    
                            //         Container(
                            //           margin: EdgeInsets.all(5),
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(20),
                            //             color: Colors.black,
                            //           ),
                            //           child: CreditCardWidget(
                            //               // glassmorphismConfig: Glassmorphism.defaultConfig(),
                            //               cardNumber: '50601029837500000083',
                            //               expiryDate: '19/24',
                            //               cardHolderName: 'Master Card',
                            //               cvvCode: '***',
                            //               cardBgColor: Colors.transparent,
                            //               showBackView: false,
                            //               onCreditCardWidgetChange: (e) {}),
                            //         ),
                            //       ],
                                  options: CarouselOptions(
                                      enlargeCenterPage: true,
                                      padEnds: false,
                                      aspectRatio: 16 / 10,
                                      initialPage: 0,
                                      enableInfiniteScroll: false,
                                      viewportFraction: 0.95,
                                      enlargeStrategy:
                                          CenterPageEnlargeStrategy.height),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  } else if(index==2) {
                    return SizedBox(height:10);

                  
                  } else if (index == 3) {
                    return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: ContainerDecoration(),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Fund your wallet with Bank Transfer',
                            textAlign: TextAlign.center,

                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                'To fund your wallet using bank transfer, use the detail below',
                                textAlign: TextAlign.center),
                            ListTile(
                                title: const Text('Accout number'),
                                subtitle: InkWell(
                            onTap: () {
                              if (brakey.user.value!.payload!.bvn !=
                                  'Not added') {
                                Clipboard.setData(ClipboardData(
                                    text: brakey.user.value!.payload!
                                            .accountNumber ??
                                        ''));
                                Get.showSnackbar(const GetSnackBar(
                                    duration: Duration(seconds: 1),
                                    messageText: Text(
                                        'Account number has been copied',
                                        style:
                                            TextStyle(color: Colors.white))));
                              } else {
                                Get.to(() => BVNPrompt());
                              }
                            },
                            child: Row(
                              children: [
                                Text(brakey.user.value!.payload!.bvn !=
                                        'Not added'
                                    ? '${widget.user.payload!.accountNumber} '
                                    : 'Set Transaction PIN to get your account number'),
                                brakey.user.value!.payload!.bvn != 'Not added'
                                    ? Icon(CupertinoIcons.doc_on_doc_fill,
                                        size: 15,
                                        color: Theme.of(context).primaryColor)
                                    : Container()
                              ],
                            ),
                          ),),
                            const ListTile(
                                title: Text('Bank name'),
                                subtitle: Text('Wema Bank')),
                            ListTile(
                                title: const Text('Account name'),
                                subtitle:
                                    Text(widget.user.payload!.fullname ?? '')),
                          ],
                        ));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        )
      ]),
      // floatingActionButton: ElevatedButton(
      //     onPressed: () {
      //       // contractMode();
      //     },
      //     child: SizedBox(
      //       width: 70,
      //       height: 40,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: const [
      //           Icon(
      //             IconlyBold.send,
      //             color: Colors.white,
      //           ),
      //           Text(
      //             'Fund',
      //             style: TextStyle(color: Colors.white),
      //           )
      //         ],
      //       ),
      //     )),
    );
  }

  void addBankCard() {
  
  Get.to(() => AddBankCard());
  
  }
}

class AddBankCard extends StatefulWidget {
  AddBankCard({Key? key}) : super(key: key);

  @override
  State<AddBankCard> createState() => _AddBankCardState();
}

class _AddBankCardState extends State<AddBankCard> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvvCode = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(elevation: 0,),
          body: Container(
            // padding: MediaQuery.of(context).viewInsets,
            clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: ContainerBackgroundDecoration(),
              child: Builder(
                builder: (context) {
                  return ListView(
                    children: [
                      CreditCardWidget(
                        cardBgColor: Color.fromARGB(255, 0, 135, 202),
                        backgroundImage: 'assets/star-bg.png',
                        
                        isHolderNameVisible: true,
                        cardNumber: cardNumber, expiryDate: expiryDate, cardHolderName: cardHolderName, cvvCode: cvvCode, showBackView: false, onCreditCardWidgetChange: (e) {
                        }),
                      BraketCreditCardForm(
                        textColor: Get.isDarkMode ? Colors.white : Colors.black,
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        cvvCodeDecoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              hintText: 'CVV',
                              hintStyle: TextStyle(color: Colors.grey,),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                        expiryDateDecoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              hintText: 'Expired date',
                              hintStyle: TextStyle(color: Colors.grey,),

                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                        cardHolderDecoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              hintText: 'Card Name',
                              hintStyle: TextStyle(color: Colors.grey,),

                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                        cardNumberDecoration: const InputDecoration(
                              fillColor: Color.fromARGB(24, 158, 158, 158),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              hintText: 'Card number',
                              hintStyle: TextStyle(color: Colors.grey,),

                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                        onCreditCardModelChange: (e) {
                          setState(() {
                            cardNumber = e.cardNumber;
                            cardHolderName = e.cardHolderName;
                            expiryDate = e.expiryDate;
                            cvvCode = e.cvvCode;
                          });
                          cardNumber = e.cardNumber;
                            cardHolderName = e.cardHolderName;
                            expiryDate = e.expiryDate;
                            cvvCode = e.cvvCode;
                        },
                        formKey: _formKey,
                        themeColor: Theme.of(context).primaryColor,
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: RoundButton(
                            color1: NeutralButton,
                            color2: NeutralButton,
                            width: 300,
                            text: 'Fund wallet',
                            onTap: () {
                              showDialog(context: context, builder: 
                              (_) {
                                return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                  title: Text('Try again later'),
                                  content: Text('Not available, Please use bank transfer'), 
                                  actions: [
                                    TextButton(child: Text('Cancel'), onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    })
                                  ]
                                );
                              }
                              );
                            })),
                        Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.shield, color: Colors.blueGrey),
                                    const SizedBox(width: 5),
                                    // Text('Braket is CBN KYC Compliant', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                    Container(padding: const EdgeInsets.all(8), child: const Text('Your security is important to us. Our payment processor is PCI compliant which ensures that your information is being handled in accordance with the security standards ', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),)),
                                  ],
                                ),
                              ),
                                    const SizedBox(height: 40),
                    ],
                  );
                }
              )),
        );
      
  }
}