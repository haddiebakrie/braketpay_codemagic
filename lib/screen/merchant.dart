import 'package:braketpay/uix/contractmodeselect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';

import '../api_callers/contracts.dart';
import '../classes/product_contract.dart';
import '../classes/user.dart';
import '../uix/contractlistcard.dart';

class Merchant extends StatefulWidget {
  Merchant({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;
  @override
  State<Merchant> createState() => _MerchantState();
}

class _MerchantState extends State<Merchant> {
  late Future<List<dynamic>> _transactions = fetchContracts(
      widget.user.payload!.accountNumber ?? "",
      widget.user.payload!.password ?? "",
      widget.pin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 5,
        toolbarHeight: 65,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        ],
        title: Text('Merchant',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
                onPressed: () {}),
          ),
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.zero),
            color: Colors.white,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              final transactions = await fetchContracts(
                  widget.user.payload!.accountNumber ?? "",
                  widget.user.payload!.password ?? "",
                  widget.pin);
              setState(() {
                _transactions = Future.value(transactions);
              });
            },)))}
            // child: 
}
