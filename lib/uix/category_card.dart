import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final category;

  CategoryCard({Key? key, 
    required this.category,
  }) : super(key: key);

  final Map cats = {
    "Gadgets": 'assets/headphones_4.png',
    "Fashion": "assets/hoodie_red.png",
    "Phones & Tablets": "assets/iphones.png",
    "Health": "assets/skin_care.png",
    "Home & Office": "assets/fridge.png",
    "Computers & Accesories": "assets/laptop.png",
    "Electronics & Accesories": "assets/woofer.png",
    "Construction Materials": "assets/irons.png",
    "Gaming": "assets/gamepad.png",
    "All" : "assets/all_gadgets.png",
    "Art Works & Paintings": "assets/pencils.png",
    "Beauty & Cosmetics": "assets/pomade.png",
    "Others": "assets/bike.png",
    "Tailouring": "assets/scissors.png",
    "Painting": "assets/painting.png",
    "Car & Mechanical Repairs": "assets/tyres.png",
    "Event plannings": "assets/event_planning.png",
    "Air Dressing & Makeups": "assets/comb.png",
    "Computer & Electronics Repairs": "assets/com_repair.png",
    "Construction Works": "assets/irons.png",
    "Web & App Developement": "assets/web_design.png",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      height: 140,
      width: 100,
      decoration: ContainerDecoration(),
      // margin: const EdgeInsets.all(10),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //     gradient: RadialGradient(
            //         colors: [category.begin, category.end],
            //         center: Alignment(0, 0),
            //         radius: 0.8,
            //         focal: Alignment(0, 0),
            //         focalRadius: 0.1)),
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Image.asset(cats[category.category]??'', height: 70,),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  category.category,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 8),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

