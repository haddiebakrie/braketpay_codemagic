import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContractCardShimmer extends StatelessWidget {
  const ContractCardShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300.withOpacity(0.3),
      highlightColor: Colors.grey.shade100.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        child: Container(
          decoration: const BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
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
            title: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              height: 20,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 215, 214, 214),
                  borderRadius: BorderRadius.circular(20)),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 20,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 215, 214, 214),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal:5),
                  height: 20,
                  width: 60,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 215, 214, 214),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
            leading: AbsorbPointer(
              child: Container(
                width: 60,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 215, 214, 214),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SquareShimmer extends StatelessWidget {
  const SquareShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration(),
        margin: const EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300.withOpacity(0.3),
        highlightColor: Colors.grey.shade100.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
          child: Container(
            decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: 3,
                  //     blurRadius: 10,
                  //     offset: const Offset(0, 0), // changes position of shadow
                  //   ),
                ]),
            child: Row(
              children: [
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 5),
              //   height: 20,
              //   decoration: BoxDecoration(
              //       color: const Color.fromARGB(255, 215, 214, 214),
              //       borderRadius: BorderRadius.circular(20)),
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         margin: const EdgeInsets.symmetric(vertical: 5),
              //         height: 20,
              //         decoration: BoxDecoration(
              //             color: const Color.fromARGB(255, 215, 214, 214),
              //             borderRadius: BorderRadius.circular(20)),
              //       ),
              //     ),
              //     Container(
              //       margin: const EdgeInsets.symmetric(vertical: 5, horizontal:5),
              //       height: 20,
              //       width: 60,
              //       decoration: BoxDecoration(
              //           color: const Color.fromARGB(255, 215, 214, 214),
              //           borderRadius: BorderRadius.circular(20)),
              //     ),
              //   ],
              // ),
              
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        child: Container(
                        width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 214, 214),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    // SizedBox(height:10),
                    // AbsorbPointer(
                    //   child: Container(
                    //     height: 20,
                    //     decoration: BoxDecoration(
                    //         color: const Color.fromARGB(255, 215, 214, 214),
                    //         borderRadius: BorderRadius.circular(5)),
                    //   ),
                    // ),
                  ],
                ),
              ),
              ]
            ),

          ),
        ),
      ),
    );
  }
}
