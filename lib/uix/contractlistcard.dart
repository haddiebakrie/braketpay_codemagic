
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/productdetail.dart';
import 'package:braketpay/screen/servicedetail.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../classes/product_contract.dart';

class ContractListCard extends StatelessWidget {
  const ContractListCard({
    Key? key, 
    required this.pin,
    required this.product,
    required this.user
  }) : super(key: key);

  final ProductContract product;
  final String pin;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        product.payload!.parties!.buyersName != null ? Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ProductDetail(contract: product, pin: pin, user: user)
      )) : Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ServiceDetail(contract: product)
      ));
      // );
      // }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]),
          child: ListTile(
            horizontalTitleGap: 10,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              
              children: [
                Text(product.dateCreated(), style: TextStyle(color: Colors.grey),),
                Text(product.payload!.states!.approvalState ?? "")
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
                  text: "By: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        text:
                            "${product.payload!.parties!.contractCreator}"),
                  ]),
            ),
            leading: AbsorbPointer(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: product.isService()
                    ? IconButton(
                        icon: const Icon(IconlyBold.document),
                        color: Colors.white,
                        iconSize: 20,
                        onPressed: () {})
                    : IconButton(
                        icon: const Icon(IconlyBold.setting),
                        color: Colors.white,
                        iconSize: 20,
                        onPressed: () {}),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
