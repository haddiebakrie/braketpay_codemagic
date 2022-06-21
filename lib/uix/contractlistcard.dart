
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productdetail.dart';
import 'package:braketpay/screen/servicedetail.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../classes/product_contract.dart';
import '../screen/loandetail.dart';
import '../utils.dart';

class ContractListCard extends StatelessWidget {
  ContractListCard({
    Key? key, 
    required this.pin,
    required this.product,
    required this.user
  }) : super(key: key);

  final ProductContract product;
  final String pin;
  final User user;

  final Map<String, Color> colors = {
  'Terminated':Colors.red,
  'Rejected':Colors.red,
  'Closed': Colors.blueGrey.shade600,
  'Not approved': Colors.blue,
  'Approved': Colors.green,
  'Confirmed': Colors.green,
  'Not Confirmed': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    String state = product.contractType() == 2 ? product.payload!.states!.confirmationState??'' : product.payload?.states?.closingState == 'Closed' ? 'Closed' : product.payload?.states?.closingState == 'Terminated' ? 'Terminated' : product.payload!.states!.approvalState ?? ""; 
    return InkWell(
      onTap: () {
      print(product.contractType());
        product.contractType() == 0 ? Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ProductDetail(contract: product, pin: pin, user: user)
      )) : product.contractType() == 1 ? Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ServiceDetail(contract: product, pin: pin, user: user)
      )) : Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => LoanDetail(contract: product, pin: pin, user: user)));
          
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        child: Container(
          decoration: ContainerDecoration(),
          child: ListTile(
            horizontalTitleGap: 10,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              
              children: [
                Text(product.dateCreated(), style: TextStyle(color: Colors.grey),),
                Text(state, style: TextStyle(fontWeight: FontWeight.bold, color: this.colors[state]??Theme.of(context).textTheme.labelMedium?.color))
              ],
            ),
            title: Text(
              product.payload!.terms!.contractTitle ??
                  "",
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: RichText(
              maxLines: 1,
              text: TextSpan(
                  text: product.isContractCreator(user.payload!.walletAddress??'') ? "To: " : "From: ", 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        text:
                            "${toTitleCase(product.getSecondParty(user.payload!.fullname??''))}"),
                  ]),
            ),
            leading: AbsorbPointer(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: product.contractType() == 0
                    ? IconButton(
                        icon: const Icon(IconlyBold.document),
                        color: Colors.white,
                        iconSize: 20,
                        onPressed: () {})
                    : product.contractType() == 1 ? 
                    
                    IconButton(
                        icon: const Icon(IconlyBold.setting),
                        color: Colors.white,
                        iconSize: 20,
                        onPressed: () {}) : 
                   IconButton(
                        icon: const Icon(Icons.money),
                        color: Colors.white,
                        iconSize: 20,
                        onPressed: () {})     
                        ,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
