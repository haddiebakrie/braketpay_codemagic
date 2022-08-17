import 'package:braketpay/api_callers/userinfo.dart';
import 'package:braketpay/classes/message.dart';
import 'package:braketpay/screen/notifications.dart';
import 'package:braketpay/uix/contractlistcard.dart';
import 'package:braketpay/uix/messagecard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:collection/collection.dart";
import '../brakey.dart';
import '../uix/roundbutton.dart';
import '../uix/shimmerwidgets.dart';
import '../uix/themedcontainer.dart';
import 'marketplace_search.dart';

class ChatHistory extends StatefulWidget {
  ChatHistory({Key? key}) : super(key: key);

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  String keyword = '';
  Brakey brakey = Get.put(Brakey());
  late Future<List<dynamic>> chats = fetchChats(
      brakey.user.value!.payload!.walletAddress ?? "",
      brakey.user.value!.payload!.password ?? "",
      '',
      "all",
      "",
      "",
      "");
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(elevation: 0, automaticallyImplyLeading: false, toolbarHeight:0,),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
         Container(
     height: kToolbarHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              BackButton(color: Colors.white),
          Text('Chats', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 22),),
            ],
          ),
          Row(
            children: [

           Container(
            decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
            child: IconButton(
                onPressed: () {
                  Get.to(Notifications(user: brakey.user.value!, pin: ''));
                },
                icon: Icon(Icons.notifications, color: Colors.white)),
          ),
            ],
          )
            
        ],
      ),
    ),
       Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20)
                ),
        child: TextField(
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            setState(() {
              keyword = value;
            });
          },
          decoration: InputDecoration(
            // prefixIcon: Icon(Icons.search),
            contentPadding: EdgeInsets.zero,
          filled: true,
          
          fillColor: Colors.transparent,
          border: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: 'Search Contracts',
            hintStyle: TextStyle(fontSize: 14, color: Colors.white30, fontWeight: FontWeight.w600)
          ),
        ),
      ),
        SizedBox(height:20),
           Expanded(
             child: Container(
              padding: const EdgeInsets.symmetric(vertical:10),
                decoration: ContainerBackgroundDecoration(),
                child: RefreshIndicator(
                  key: brakey.refreshChat.value,
                  onRefresh: () async {
                    final _transactions = await fetchChats(
                 brakey.user.value!.payload!.walletAddress ?? "",
                 brakey.user.value!.payload!.password ?? "",
                 '',
                 "all",
                 "",
                 "",
                 "");
                        // if (transactions.isNotEmpty) {
                    setState(() {
                      chats = Future.value(_transactions);
                    });
                        // }
                        // print(chats);
                  },
                  child: FutureBuilder<List>(
                    future: chats,
                    builder: (context, snapshot) {
                      List<Message> _data = List.from(snapshot.data??[]);
                      Map<String, List<Message>> groupedData = _data.groupListsBy((Message element) => element.contractID!);
                        // if (snapshot.hasData && hide==2 && snapshot.data!.isNotEmpty) {
                        // _data.removeWhere((element) => element.isService());
                        // }
                        // else if (snapshot.hasData && hide==1 && snapshot.data!.isNotEmpty) {
                        // _data.removeWhere((element) => !element.isService());
                        // }
                        // if (snapshot.hasData && showOnly==2 && snapshot.data!.isNotEmpty) { 
                        //   _data.removeWhere((element) => element.payload!.states!.approvalState.toLowerCase() == 'approved');
                        // } else if (snapshot.hasData && showOnly==1 && snapshot.data!.isNotEmpty) { 
                        //   _data.removeWhere((element) => element.payload!.states!.approvalState!.toLowerCase() == 'not approved');
                        // }
                        // print(_data);
                      if (snapshot.hasData) {
                        return snapshot.data!.isNotEmpty
                            ? ListView.builder(
                        itemCount: groupedData.length,
                        itemBuilder: (context, index) {
                          // Message msg = snapshot.data![index];
                          return MessageCard(pin: '', product: groupedData[groupedData.keys.toList()[index]], user: brakey.user.value!);})
                            : ListView(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height-120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/empty.png', width: 140),
                                      const SizedBox(height:20),
                                      const Center(
                                        child: Text('You have no Message!', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                      } else if (snapshot.hasError) {
                        return SizedBox(
                          height: double.infinity,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/sammy-no-connection.gif',
                                  width: 150),
                              const Text(
                                  "No internet access\nCouldn't Load Contract History!",
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 20),
                              RoundButton(
                                  icon: Icons.refresh,
                                  text: 'Retry',
                                  color1: Colors.black,
                                  color2: Colors.black,
                                  onTap: () {
                                    brakey.refreshChat.value!.currentState!
                                        .show();
                                  }
                                  )
                            ],
                          )),
                        );
                      }
           
                      return ListView.builder(itemBuilder: (builder, index) {
                        return const ContractCardShimmer();
                      });
                    },
                  ),
                )),
           ),
         ],
       ),
      
    );
  }
}