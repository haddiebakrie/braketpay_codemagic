
import 'package:flutter/material.dart';

class UtilityButton extends StatelessWidget {
  UtilityButton({
    Key? key, required this.url, required this.text, this.onTap,
  }) : super(key: key);

  final String url;
  final String text;
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      onPressed: () {
        onTap!();
      },
      child: Container(
          margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          
              color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 0),
            )
          ]),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 35,
              child: Image.asset(url)),
            Container(
              
             //  margin: EdgeInsets.all(5),
              child: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal,color: Colors.black)))
            
            ]
        ),
      ),
    );
  }
}


class UtilityButtonO extends StatelessWidget {
  UtilityButtonO({
    Key? key, required this.url, required this.text, this.onTap,
  }) : super(key: key);

  final String url;
  final String text;
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      onPressed: () {
        onTap!();
      },
      child: Container(
        width: 100,
        child: Column(
          children: [
            Container(
              width: 35,
              margin: EdgeInsets.all(10),
              child: Image.asset(url)),
            Container(
              
             //  margin: EdgeInsets.all(5),
              child: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal,color: Colors.black)))
            
            ]
        ),
      ),
    );
  }
}

