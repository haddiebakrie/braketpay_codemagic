
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractCardShimmer extends StatelessWidget {
  const ContractCardShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.2),
              //     spreadRadius: 3,
              //     blurRadius: 10,
              //     offset: const Offset(0, 0), // changes position of shadow
              //   ),
              ]),
              child: ListTile(
                horizontalTitleGap: 10,
                title: Container(margin: EdgeInsets.symmetric(vertical: 5), height: 20, color: Color.fromARGB(255, 215, 214, 214),),
                subtitle: Container(margin: EdgeInsets.symmetric(vertical: 5), height: 20, width: 20, color:  Color.fromARGB(255, 215, 214, 214)),
                leading: AbsorbPointer(
                  child: Container(
      width: 60,
                    decoration: BoxDecoration(
      color:  Color.fromARGB(255, 215, 214, 214),
      borderRadius: BorderRadius.circular(20)),
                    
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
