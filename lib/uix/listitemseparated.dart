
import 'package:flutter/material.dart';

class ListItemSeparated extends StatelessWidget {
  ListItemSeparated({
    Key? key,
    required this.text,
    required this.title,
    this.leadingText = '',
    this.isLast = false,
  }) : super(key: key);

  final String text;
  final String title;
  final String leadingText;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        child: Column(children: [
          ListTile(
            leading: leadingText == '' ? SizedBox(width: 0,) : Text(leadingText, style: TextStyle(fontWeight: FontWeight.bold,)),
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            horizontalTitleGap: leadingText == '' ? 0 : 8,
            title: Flexible(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold,))), trailing: Flexible(child: Text(text, style: TextStyle(fontFamily: '', color: Colors.grey, fontWeight: FontWeight.w600)))),
          // Container(
          //     color: isLast ? Colors.transparent : Colors.grey.withOpacity(.5),
          //     height: 1,
          //     width: double.infinity)
        ]));
  }
}


class ListSeparated extends StatelessWidget {
  ListSeparated({
    Key? key,
    required this.text,
    required this.title,
    this.isLast = false,
  }) : super(key: key);

  final String text;
  final String title;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(children: [
          ListTile(title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical:10),
            child: Text(text, style: TextStyle(fontFamily: '',)),
          )),
          // Container(
          //     color: isLast ? Colors.transparent : Colors.grey.withOpacity(.5),
          //     height: 1,
          //     width: double.infinity)
        ]));
  }
}
