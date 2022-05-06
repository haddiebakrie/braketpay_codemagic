
import 'package:braketpay/classes/transaction.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/transactiondetail.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class TransactionListCard extends StatelessWidget {
  const TransactionListCard({
    Key? key,
    required this.user,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TransactionDetail(transaction: transaction, user:user)
      ));
      // );
      // }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                Text(transaction.payload!.dateMade()),
                transaction.payload!.receiverAccountNumber == user.payload!.accountNumber ? 
                Icon(Icons.call_received, color: Colors.greenAccent) : 
                Icon(Icons.call_made, color: Colors.redAccent)
              ],
            ),
            title: Text(
              transaction.payload!.receiverName ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: RichText(
              text: TextSpan(
                  text: "",
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
                            "${transaction.payload!.formatAmount()}"),
                  ]),
            ),
            leading: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                      icon: const Icon(IconlyBold.send),
                      color: Colors.white,
                      iconSize: 20,
                      onPressed: () {}),
            ),
          // ),
        ),
      )),
    );
  }
}
