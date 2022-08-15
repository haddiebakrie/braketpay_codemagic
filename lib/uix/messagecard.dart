
import 'package:braketpay/classes/message.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/chats.dart';
import 'package:braketpay/screen/contract_chat.dart';
import 'package:braketpay/screen/productdetail.dart';
import 'package:braketpay/screen/servicedetail.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../classes/product_contract.dart';
import '../screen/loandetail.dart';
import '../utils.dart';

class MessageCard extends StatelessWidget {
  MessageCard({
    Key? key, 
    required this.pin,
    required this.product,
    required this.user
  }) : super(key: key);

  final List<Message>? product;
  final String pin;
  final User user;

  @override
  Widget build(BuildContext context) {
    // String state = product.contractType() == 2 ? product.payload!.states!.confirmationState??'' : product.payload?.states?.closingState == 'Closed' ? 'Closed' : product.payload?.states?.closingState == 'Terminated' ? 'Terminated' : product.payload!.states!.approvalState ?? ""; 
    return InkWell(
      onTap: () {
        Get.to(() => ChatScreen(user: user, contract: {}, messages: product,));
              // print(product.payload.terms.;
      //   product.contractType() == 0 ? Navigator.of(context).push(MaterialPageRoute(
      //       builder: (BuildContext context) => ProductDetail(contract: product, pin: pin, user: user)
      // )) : product.contractType() == 1 ? Navigator.of(context).push(MaterialPageRoute(
      //       builder: (BuildContext context) => ServiceDetail(contract: product, pin: pin, user: user)
      // )) : Navigator.of(context).push(MaterialPageRoute(
      //       builder: (BuildContext context) {
      //         print(product.payload!.toJson());
      //         return LoanDetail(contract: product, pin: pin, user: user);}));
          
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        child: Container(
          decoration: ContainerDecoration(),
          child: ListTile(
            horizontalTitleGap: 10,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              
              children: [
                Text(product!.last.dateTime(), style: TextStyle(color: Colors.grey, fontSize: 10),),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text('15', style: TextStyle(color: Colors.white, fontSize:9, fontWeight: FontWeight.bold),))
                // Text(state, style: TextStyle(fontWeight: FontWeight.bold, color: this.colors[state]??Theme.of(context).textTheme.labelMedium?.color, fontSize: 12))
              ],
            ),
            subtitle: Text(
              product!.last.message?['text'],
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            title: RichText(
              maxLines: 1,
              text: TextSpan(
                  text: product!.last.senderName, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        text:
                            "${toTitleCase('')}"),
                  ]),
            ),
            leading: Stack(
              alignment: Alignment.bottomRight,
              children: [
                AbsorbPointer(
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    // child: IconButton(
                    //         icon: const Icon(CupertinoIcons.archivebox_fill),
                    //         color: Colors.white,
                    //         iconSize: 25,
                    //         onPressed: () {})     
                    //         ,
                    child: Image.asset('assets/avatar_test.jpg')
                  ),
                ),
                Icon(Icons.circle, color: Colors.green, size: 15)
              ],
            ),
          ),
        ),
      ),
    
    );
  }
}
