import 'package:braketpay/screen/savingsplandetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key, this.text='', this.textSize=0, this.icon, this.width = 70, this.height = 40, this.color1 = const Color.fromARGB(255, 0, 13, 194),
    this.color2 = const Color.fromARGB(255, 0, 13, 194), this.textColor = Colors.white, this.onTap , this.radius = 20.0,
  }) : super(key: key);

  final String text;
  final double width;
  final double height;
  final Color color1;
  final Color color2;
  final Color textColor;
  final double textSize;
  final double radius;
  final IconData? icon;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: textSize==0 ? EdgeInsets.symmetric(vertical: 10, horizontal:16) :  EdgeInsets.symmetric(vertical: 5, horizontal:10),
      // height: height,
      // width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(colors: [
            color1, color2
          ])),
      child: InkWell(
          onTap: () {
            onTap!();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: icon != null,
                child: Container(
                  
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(icon, color: textColor, size: 15),
                )),
              textSize==0 ? Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: textColor),
              ) : Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: textSize, color: textColor),
              ) ,
            ],
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
    return Hero(
      tag: 'savings_detail_$title',
      child: Material(
        child: InkWell(
          onTap: () {
            print('ji');
            Get.to(() => SavingsPlanDetail(plan: title));
          },
          child: Container(
            decoration:
                BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            height: 70,
            width: 70,
            child: Center(
                child: Text(title,
                    style: const TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}