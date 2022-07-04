
import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/notifications.dart';
import 'package:braketpay/screen/profile.dart';
import 'package:braketpay/uix/transactioncard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:iconly/iconly.dart';
import '../api_callers/transactions.dart';
import '../classes/product_contract.dart';
import '../classes/transaction.dart';
import '../classes/user.dart';
import '../uix/contractlistcard.dart';
import '../uix/roundbutton.dart';
import '../uix/shimmerwidgets.dart';
import '../uix/themedcontainer.dart';

class History extends StatefulWidget {
    const History({Key? key, required this.user, required this.pin}) : super(key: key);

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
        centerTitle: true,
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        // actions: [
        //   Obx(() => IconBadge(
        //     onTap: () {
        //       Navigator.of(context).push(MaterialPageRoute(builder: 
        //     ((context) => Notifications(user:widget.user, pin: widget.pin)
        //     )));
        //     },
        //     maxCount: 9,
        //     icon: Icon(Icons.notifications),
        //     itemCount: brakey.notiCount.toInt(),
        //     right: 10.0,
        //     hideZero: true,
        //     top:10.0

        //     // hideZero: true,
            
        //     ))
        // ],
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('History',
              // textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),

          ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical:10),
        decoration: ContainerBackgroundDecoration(),
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
              return snapshot.data!.isNotEmpty ? ListView.builder(
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
                                const SizedBox(height:20),

                                const Center(
                                  child: Text('You have not created any contract!'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
            } else if (snapshot.hasError) {
              return Container(
                
                child: ListView(
                  children: [
                    Center(
                                    child: Column(
                                  children: [
                                    Image.asset('assets/sammy-no-connection.gif',
                                        width: 150),
                                    const Text(
                                        "No internet access\nCouldn't Load Transaction History!",
                                        textAlign: TextAlign.center),
                                    const SizedBox(height: 20),
                                    RoundButton(
                                        text: 'Retry',
                                        color1: Colors.black,
                                        color2: Colors.black,
                                        onTap: () {
                                          brakey.refreshHistory.value!.currentState!.show();
                                        }
                                        
                                        )
                                  ],
                                ))
                  ],
                ));
            }
    
            return ListView.builder(itemBuilder: (builder, index) {
                  return const ContractCardShimmer();
                });
          },
        ),
      ),
    ));
  }
}
