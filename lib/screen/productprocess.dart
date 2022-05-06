import 'package:flutter/material.dart';



class ContractCreationLoading extends StatefulWidget {
  ContractCreationLoading({Key? key}) : super(key: key);

  @override
  State<ContractCreationLoading> createState() => _ContractCreationLoadingState();
}

class _ContractCreationLoadingState extends State<ContractCreationLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [
            Container(
              child: Text('Creating contract')

            ),
            
          ],
        ),
      ),

    );
  }
}