
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';

class Message {
  Map? message;
  String? time;
  bool? isRead;
  String? senderAddr;
  String? receiverAddr;
  String? fileLink;
  String? senderName;
  String? receiverName;
  String? contractID;
  String? contractType;
  String? productID;

  Message(
      {this.message, this.time, this.isRead, this.senderAddr, this.receiverAddr,
      this.contractID, this.contractType, this.fileLink, this.receiverName, this.senderName,
      this.productID
      });

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    time = json['message_timestamp'];
    isRead = false;
    fileLink = json['file_link'];
    senderName = json['sender_name'];
    receiverName = json['receiver_name'];
    contractID = json['contract_id'];
    contractType = json['contract_type'];
    productID = json['product_id'];
    receiverAddr = json['receiver_address'];
    senderAddr = json['sender_address'];
  }

  dateTime() {
    DateTime formatted = DateTime.parse(time?? "");
    formatted = formatted.subtract(Duration(hours: 1));
    String date = DateFormat('MMM, dd yyyy').format(formatted);
    String timeAgo = GetTimeAgo.parse(formatted).replaceAll('a day ago', 'yesterday').replaceAll('a min ago', '1 min');
    return timeAgo.contains('ago') || timeAgo == 'yesterday' ? timeAgo : date;
  }

}