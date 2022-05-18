
import 'package:flutter/material.dart';

class ListItemSeparated extends StatelessWidget {
  ListItemSeparated({
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
          ListTile(title: Text(title), trailing: Text(text, style: TextStyle(fontFamily: ''))),
          Container(
              color: isLast ? Colors.transparent : Colors.grey.withOpacity(.5),
              height: 1,
              width: double.infinity)
        ]));
  }
}
