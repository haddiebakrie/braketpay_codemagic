
import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/profile.dart';
import 'package:braketpay/uix/transactioncard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../api_callers/transactions.dart';
import '../classes/product_contract.dart';
import '../classes/transaction.dart';
import '../classes/user.dart';
import '../uix/contractlistcard.dart';

class History extends StatefulWidget {
    History({Key? key, required this.user, required this.pin}) : super(key: key);

  final User user;
  final String pin;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Brakey brakey = Get.put(Brakey());
  late Future<List<dynamic>> _transactions = fetchTransactions(
      widget.user.payload!.accountNumber ?? "",
      widget.user.payload!.password ?? "",
      widget.pin);  @override  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 5,
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        ],
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('History',
              // textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),

          ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom:Radius.zero),
          color: Colors.white,
          ),
        child: RefreshIndicator(
                key: brakey.refreshHistory.value,
                onRefresh: () async {
                  final transactions = await fetchTransactions(
                      widget.user.payload!.accountNumber ?? "",
                      widget.user.payload!.password ?? "",
                      widget.pin);
                  setState(() {
                    _transactions = Future.value(transactions);
                  });
                },
          child: FutureBuilder<List>(
          future: _transactions,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.length > 0 ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    Transaction transaction = snapshot.data![index];
                    return TransactionListCard(transaction: transaction, user: widget.user);
                                              }) : ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height-120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/empty.png', width: 140),
                                SizedBox(height:20),

                                Center(
                                  child: Text('You have not created any contract!'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
            } else if (snapshot.hasError) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20), bottom: Radius.zero),
                  color: Colors.white,
                ),
                child: ListView(
                  children: [
                    Center(
                          child: Column(
                            children: [
                              SizedBox(height:40),
                              Icon(Icons.wifi_off_rounded),
                              Text(
                                  "No internet access\nCoudn't Load Transaction History!\n\nPull down to refresh", textAlign: TextAlign.center),
                            ],
                          )),
                  ],
                ));
            }
    
            return Center(child: SpinKitCubeGrid(
              color: Theme.of(context).primaryColor,
              
    
    
    
              
            ));
          },
        ),
      ),
    ));
  }
}
