import 'package:braketpay/api_callers/contracts.dart';
import 'package:braketpay/api_callers/userinfo.dart' as uinfo;
import 'package:braketpay/constants.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:braketpay/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../api_callers/marketplace.dart';
import '../classes/message.dart';
import '../classes/user.dart';


class ChatScreen extends StatefulWidget {
  final User user;
  final Map contract;
  late final List<Message>? messages;

  ChatScreen({required this.user, required this.contract, this.messages});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String? secondPartyName = widget.messages?.first.receiverAddr == widget.user.payload?.walletAddress ? widget.messages?.first.senderName : widget.messages?.first.receiverName;
  String msg = '';
  TextEditingController composerController = TextEditingController();
  late List<Message>? chatHistory = widget.messages;
  bool g = false;
  _buildMessage(Message message, bool isMe) {
    final container = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
            ),
      // width: MediaQuery.of(context).size.width * 0.75,
      
      child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75,
      minWidth: 90
      ),
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          decoration: BoxDecoration(
          color: isMe ? Color.fromARGB(169, 1, 190, 149) : Color.fromARGB(255, 108, 104, 104),
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                ),
        ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8.0),
              Text(
                message.message?['text'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4,),
              Container(
                // width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: isMe,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(message.contractID != null ? Icons.done_all_rounded : CupertinoIcons.clock, size: 10, color: Colors.white),
                      ),
                    ),
                    Text(
                      message.time.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 9.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          container,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        container,
        // IconButton(
        //   icon: message.isLiked
        //       ? Icon(Icons.favorite)
        //       : Icon(Icons.favorite_border),
        //   iconSize: 30.0,
        //   color: message.isLiked
        //       ? Theme.of(context).primaryColor
        //       : Colors.blueGrey,
        //   onPressed: () {},
        // ),
      ],
    );
  }

  _buildMessageComposer() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 50, maxHeight: 100),
      child: Container(
    
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: ContainerDecoration(),
        // color: Colors.white,
        child: Row(
          children: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.attach_file),
            //   iconSize: 25.0,
            //   color: Theme.of(context).primaryColor,
            //   onPressed: () {},
            // ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15
                ),
                margin: EdgeInsets.only(right: 10),
                child: TextField(
                  controller: composerController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {
                    setState(() {
                      msg = value;
                      
                    });
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: 'Send message...',
                    hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
              color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
    
              ),
              margin: EdgeInsets.all(8),
              child: IconButton(
                
                icon: Icon(IconlyBold.send),
                iconSize: 18.0,
                color: Colors.white,
                onPressed: ()
                {
                // print(widget.contract.keys.toList());
                // print(widget.contract.values.toList().elementAt(15));
                // print(widget.contract['merchant_logo_link']);
                  if (msg.trim() == ''){
                    return;

                  }
                //  final msg = Message(text: 'Hello', time: '12:00', isLiked: false);
                // setState(() {
                // chatHistory.add(msg);
                // });
                setState(() {
                chatHistory!.add(Message(senderAddr: widget.user.payload?.walletAddress, message: {'text':msg}, time: '2022-08-08 14:22:51.945555', ));
                composerController.clear();
                });
                print(widget.contract.keys.toList().toString());
                messageSeller(
                  widget.contract.isNotEmpty ? widget.contract['${widget.contract['contract_type']}_id'] : widget.messages?.first.contractID??widget.contract['${widget.contract['contract_type']}_id'], 
                  widget.user.payload?.walletAddress??'', 
                  widget.user.payload?.walletAddress == widget.contract['seller_address'] ?  widget.messages?.first.senderAddr : widget.contract['seller_address']??widget.messages?.first.receiverAddr, 
                  // widget.messages?.length != 1 && widget.user.payload?.walletAddress == widget.messages?.first.senderAddr ? widget.messages?.first.receiverAddr??'' : widget.messages?.first.senderAddr??widget.contract['seller_address'], 
                  widget.user.payload?.password??'', 
                  widget.contract.isEmpty ? widget.messages?.first.contractType??'' : 'merchant ${widget.contract['contract_type']}',
                  msg, 
                  widget.user.payload?.walletAddress == widget.contract['seller_address'] ?  "merchant" : "customer", 
                  );
               
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    brakey.refreshSingleChat.value?.currentState?.show();
    return Scaffold(
      appBar: AppBar(elevation: 0, titleSpacing: 0,
      title: CircleAvatar(backgroundImage: NetworkImage(widget.contract['merchant_logo_link']??brokenImageUrl)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Container(
      // height: kToolbarHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.all(10).copyWith(bottom:0, left: 0),
    ),
          Expanded(
            child: Container(
              decoration: ContainerBackgroundDecoration(),
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal:20),
                                  // decoration: ContainerDecoration(),
                                  padding: EdgeInsets.all(15),
                                  child: Column(children: [
                                    
                                    Container(
                                      height: 40,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: widget.contract['product_picture_links']?.length??widget.contract['service_picture_links']?.length??0,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: Image.network(widget.contract['product_picture_links']['link_${index+1}']??widget.contract['service_picture_links']['link_${index+1}']??brokenImageUrl, height: 40, width: 40,),
                                          );
                                        }
                                      ),
                                    ),
                                   
                                    SizedBox(height:10),
                                    Column(
                                      children: [
                                        Text(widget.contract['product_name']??widget.contract['contract_title']??widget.contract['conntract_title']??secondPartyName??'', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600),),
                                      ],
                                    ),
                                  ],)
                                ),
                              ),
                              Expanded(
                                child: RefreshIndicator(
                                  edgeOffset: -90,
                                  backgroundColor: Colors.transparent,
                                  color: Colors.transparent,
                                  strokeWidth: 0,
                                  key: brakey.refreshSingleChat.value,
                                      onRefresh: () async {
                                            // if (transactions.isNotEmpty) {
                                            // }
                                            // print(chats);
                                            // widget.contract.keys.forEach((element) {print(element);});
                                        // print(
                                        // widget.contract['${widget.contract['contract_type']}_id']+"askldfjasl"
                                        // );
                                        final chats = await uinfo.fetchChats(
                                        brakey.user.value!.payload!.walletAddress ?? "",
                                        brakey.user.value!.payload!.password ?? "",
                                        "",
                                        "single",
                                        widget.messages!.isEmpty ? widget.contract['seller_address'] != widget.user.payload?.walletAddress ? widget.user.payload?.walletAddress : widget.contract['seller_address'] : widget.messages!.isNotEmpty ? widget.messages!.first.senderAddr??'' : widget.contract.isEmpty ? '' : widget.user.payload?.walletAddress??'',
                                        widget.contract.isNotEmpty ? widget.contract['${widget.contract['contract_type']}_id'] :  widget.messages!.length > 0 ? widget.messages!.first.contractID??widget.contract['contract_id']??'' : '',
                                        widget.contract.isEmpty ? widget.messages?.first.contractType??'' : 'merchant ${widget.contract['contract_type']}',
                                        );
                                                                                // chats.then((value) {
                                            setState(() {
                                              // if (chatHistory!.length <= chats.length) {
                                              //   return;
                                              // }
                                              // print(chat);
                                              chatHistory = chats;
                                            });                                        
                                                                              },

                                  child: ListView.builder(
                                        reverse: true,
                                        padding: EdgeInsets.only(top: 15.0),
                                        itemCount: chatHistory?.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return _buildMessage(chatHistory!.reversed.toList()[index], chatHistory!.reversed.toList()[index].senderAddr == widget.user.payload!.walletAddress);
                                        },
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildMessageComposer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}