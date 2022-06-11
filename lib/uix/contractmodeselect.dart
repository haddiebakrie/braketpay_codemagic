import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/createproduct.dart';
import 'package:braketpay/screen/createservice.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/material.dart';

import '../screen/createproductmerchant.dart';
import '../screen/createservicemerchant.dart';

class ContractModeSelect extends StatefulWidget {
  ContractModeSelect({Key? key, required this.user, required this.pin}) : super(key: key);

  int contractType = 0;
  int creatorType = 0;
  final User user;
  final String pin;

  @override
  State<ContractModeSelect> createState() => _ContractModeSelectState();
}

class _ContractModeSelectState extends State<ContractModeSelect> {
  bool showService = false;
  bool showProduct = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 40),
        child: Column(children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height:30),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'What type of contract are you creating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height:30),

          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    UtilityButtonO(
                        url: 'assets/paint-roller.png',
                        text: 'Service',
                        onTap: () {
                          print(widget.contractType);
                          setState(() {
                            showProduct = false;
                            showService = true;
                          });
                        }),
                    Visibility(
                      visible: showService,
                      child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    UtilityButtonO(
                        url: 'assets/shopping-bag.png',
                        text: 'Product',
                        onTap: () {
                          setState(() {
                            showProduct = true;
                            showService = false;
                          });
                        }),
                    Visibility(
                      visible: showProduct,
                      child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height:30),
          Visibility(
            visible: showService == true || showProduct == true ? true : false,
            child: Text(
              'Which one describes you?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Visibility(
            visible: showProduct,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  UtilityButtonO(
                      url: 'assets/delivery-man.png',
                      text: 'Buyer',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => CreateProduct(
                                creatorType: 'Buyer', user: widget.user, pin: widget.pin)));
                      }),
                  UtilityButtonO(
                      url: 'assets/courier.png',
                      text: 'Seller',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => CreateProduct(
                                creatorType: 'Seller', user: widget.user, pin: widget.pin)));
                      }),
                ],
              ),
            ),
          ),
          Visibility(
            visible: showService,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  UtilityButtonO(
                    url: 'assets/delivery-man.png',
                    text: 'Provider',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => CreateService(creatorType: 'Provider', user:widget.user, pin: widget.pin)
                      ));
                    }
                  ),
                  UtilityButtonO(
                    url: 'assets/worker.png',
                    text: 'Client',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => CreateService(creatorType: 'Client', user:widget.user, pin: widget.pin)
                      ));
                    }
                  ),
                ],
              ),
            ),
          )
        ]));
    ;
  }
}


class MerchantContractModeSelect extends StatefulWidget {
  MerchantContractModeSelect({Key? key, required this.user, required this.merchantID,required this.pin}) : super(key: key);

  int contractType = 0;
  int creatorType = 0;
  String merchantID;
  final User user;
  final String pin;

  @override
  State<MerchantContractModeSelect> createState() => _MerchantContractModeSelectState();
}

class _MerchantContractModeSelectState extends State<MerchantContractModeSelect> {
  bool showService = false;
  bool showProduct = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 40),
        child: Column(children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height:30),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'What type of template are you creating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height:30),

          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    UtilityButtonO(
                        url: 'assets/paint-roller.png',
                        text: 'Service',
                        onTap: () {
                          print(widget.contractType);
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MerchantCreateService(user:widget.user, pin: widget.pin, merchantID: widget.merchantID)));
                          });
                        }),
                    Visibility(
                      visible: showService,
                      child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    UtilityButtonO(
                        url: 'assets/shopping-bag.png',
                        text: 'Product',
                        onTap: () {
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => MerchantCreateProduct(
                                merchantID: widget.merchantID, user: widget.user, pin: widget.pin)));
                          });
                        }),
                    Visibility(
                      visible: showProduct,
                      child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ],
            ),
          ),
          
        ]));
    ;
  }
}
