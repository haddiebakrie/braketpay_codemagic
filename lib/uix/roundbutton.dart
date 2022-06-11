import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key, this.text='', this.width = 70, this.height = 40, this.color1 = const Color.fromARGB(255, 0, 13, 194),
    this.color2 = const Color.fromARGB(255, 0, 13, 194), this.textColor = Colors.white, this.onTap , this.radius = 20.0,
  }) : super(key: key);

  final String text;
  final double width;
  final double height;
  final Color color1;
  final Color color2;
  final Color textColor;
  final double radius;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(colors: [
            color1, color2
          ])),
      child: TextButton(
          clipBehavior: Clip.hardEdge,
          onPressed: () {
            onTap!();
          },
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: textColor),
          )),
    );
  }
}


class SavingsPlanButton extends StatelessWidget {
  SavingsPlanButton({Key? key, required this.color, required this.title})
      : super(key: key);

  String title;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      height: 70,
      width: 70,
      child: Center(
          child: Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 20))),
    );
  }
}