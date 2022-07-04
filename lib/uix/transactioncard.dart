
import 'package:braketpay/classes/transaction.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/transactiondetail.dart';
import 'package:braketpay/uix/themedcontainer.dart';
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
    return InkWell(
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
          decoration: ContainerDecoration(),
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
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: RichText(
              text: TextSpan(
                  text: "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color

                  ),
                  children: <TextSpan>[
                    TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        text:
                            "${transaction.payload!.formatAmount()}"),
                  ]),
            ),
            leading: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)),
                  child: transaction.payload!.transactionType!.contains('airtel') ? Image.asset('assets/airtel.png') 
                  : transaction.payload!.transactionType!.contains('9') ? Image.asset('assets/9mobile.png')
                  : transaction.payload!.transactionType!.contains('etisalat') ? Image.asset('assets/9mobile.png')
                  : transaction.payload!.transactionType!.contains('glo') ? Image.asset('assets/glo.jpg')
                  : transaction.payload!.transactionType!.contains('dstv') ? Image.asset('assets/dstv.png')
                  : transaction.payload!.transactionType!.contains('dstv') ? Image.asset('assets/dstv.png')
                  : transaction.payload!.transactionType!.contains('gotv') ? Image.asset('assets/gotv.png')
                  : transaction.payload!.transactionType!.contains('mtn') ? Image.asset('assets/mtn.png') : IconButton(
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
