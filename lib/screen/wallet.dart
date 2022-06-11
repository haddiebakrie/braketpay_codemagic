import 'package:braketpay/api_callers/transactions.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:braketpay/screen/createproduct.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/createservice.dart';
import 'package:braketpay/screen/profile.dart';
import 'package:braketpay/screen/qrcodescanner.dart';
import 'package:braketpay/screen/savings.dart';
import 'package:braketpay/screen/transfer.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:braketpay/screen/utilities.dart';
import 'package:braketpay/uix/transactioncard.dart';
import 'package:braketpay/uix/walletcard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../api_callers/contracts.dart';
import '../classes/product_contract.dart';
import '../uix/contractlistcard.dart';
import '../uix/contractmodeselect.dart';
import '../uix/roundbutton.dart';
import '../uix/utilitybutton.dart';
import '../utils.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Brakey brakey = Get.put(Brakey());
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 5,
        toolbarHeight: 65,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: IconButton(
                icon: const Icon(IconlyBold.profile),
                color: Theme.of(context).primaryColor,
                iconSize: 20,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Profile(user: widget.user, pin: widget.pin)));
                }),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        ],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text( 
                'Hi ${brakey.user.value!.payload!.fullname!.split(" ")[1]}',
                style: const TextStyle(fontWeight: FontWeight.bold))),
            Obx(() => Text( 
                '@${brakey.user.value!.payload!.username}',
                style: const TextStyle(fontSize: 14)))
          ],
        ),
      ),
      body: Column(children: [
        SizedBox(
            height: 150,
            width: double.infinity,
            child: CarouselSlider(
              items: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: WalletCard(
                      onTapSend: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendMoney(
                                    user: widget.user, pin: widget.pin)));
                      },
                      balance: widget.user.payload!.accountBalance.toString(),
                      title: 'Refferal Bonus'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: WalletCard(
                      onTapSend: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendMoney(
                                    user: widget.user, pin: widget.pin)));
                      },
                      balance: widget.user.payload!.accountBalance.toString(),
                      title: 'Braket Wallet'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: WalletCard(
                      onTapSend: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendMoney(
                                    user: widget.user, pin: widget.pin)));
                      },
                      balance: widget.user.payload!.accountBalance.toString(),
                      title: 'Braket Savings'),
                )
              ],
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  initialPage: 1,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.9,
                  enlargeStrategy: CenterPageEnlargeStrategy.height),
            )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.only(top: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(29),
                    topRight: Radius.circular(20))),
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
                        //  margin: EdgeInsets.only(top: 10),
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  } else if (index == 1) {
                    return CarouselSlider(
                      items: [
                        CreditCardWidget(
                            // glassmorphismConfig: Glassmorphism.defaultConfig(),
                            cardNumber: '51861029837500000083',
                            cardBgColor: Colors.transparent,
                            expiryDate: '19/24',
                            cardHolderName: 'Master Card',
                            cvvCode: '***',
                            height: 300,
                            showBackView: false,
                            onCreditCardWidgetChange: (e) {}),
                        CreditCardWidget(
                            // glassmorphismConfig: Glassmorphism.defaultConfig(),
                            cardNumber: '50601029837500000083',
                            cardBgColor: Colors.transparent,
                            expiryDate: '19/24',
                            cardHolderName: 'Master Card',
                            cvvCode: '***',
                            showBackView: false,
                            onCreditCardWidgetChange: (e) {}),
                      ],
                      options: CarouselOptions(
                          enlargeCenterPage: true,
                          padEnds: false,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                          enlargeStrategy: CenterPageEnlargeStrategy.height),
                    );
                  } else if (index == 2) {
                    return Container(
                      padding: EdgeInsets.all(20),
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
                            SizedBox(height: 10),
                            Text(
                              'Fund your wallet',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height:10),
                          Text('To fund your wallet using bank transfer, use the detail below', textAlign: TextAlign.center),
                          ListTile(title: Text('Accout number'), subtitle: Text(widget.user.payload!.accountNumber??'')),
                          ListTile(title: Text('Bank name'), subtitle: Text('Wema Bank PLC')),
                          ListTile(title: Text('Account name'), subtitle: Text(widget.user.payload!.fullname??'')),
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
