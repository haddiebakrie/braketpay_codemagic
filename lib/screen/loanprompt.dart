import 'package:braketpay/uix/showinfo.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/merchant.dart';
import '../brakey.dart';
import '../utils.dart';
import 'merchantcreateloan.dart';


class LoanIDPrompt extends StatefulWidget {
  const LoanIDPrompt({Key? key}) : super(key: key);

  @override
  State<LoanIDPrompt> createState() => _LoanIDPromptState();
}

class _LoanIDPromptState extends State<LoanIDPrompt> {
  final _formKey = GlobalKey<FormState>();
  Brakey brakey = Get.put(Brakey());
  TextEditingController loanIDEdit = TextEditingController();
  String loanID = '';
  final RoundedLoadingButtonController _fetchLoanButtonController =
    RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
      title: const Text('Create Loan'),

      ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
          Container(
            // height: 200,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  Image.asset('assets/coins.png', width: 200,),
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Get', style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text('Stress Free', style: TextStyle(fontSize: 30, color: Colors.white)),
                    Text('LOAN', style: TextStyle(fontSize: 60, color: Colors.white)),
                    FittedBox(
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: ContainerDecoration(),
                                padding: EdgeInsets.all(5),
                                child: Text('\u2713 low interest', style: TextStyle(fontSize: 9,))),
                              SizedBox(width: 5,),
                               Container(
                                decoration: ContainerDecoration(),
                                padding: EdgeInsets.all(5),child: Text('\u2713 receive training', style: TextStyle(fontSize: 9,))),
                            ],
                          ),
                          SizedBox(height: 10,),
                              Row(
                                children: [
                                   Container(
                                decoration: ContainerDecoration(),
                                padding: EdgeInsets.all(5),child: Text('\u2713 business support', style: TextStyle(fontSize: 9,))),
                                ],
                              ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              ]
            )

          ),
          
            Expanded(
              child: Container(
                  decoration: ContainerBackgroundDecoration(),
                  padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                          
                          Container(
          width: 60,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(height:20),
        Row(
          children: [
            const Text('Enter Lender Loan ID', style: TextStyle(fontWeight: FontWeight.w600),),
            InkWell(
              onTap: (() => showInfo('Loan ID', 'Get the loan ID from a Loaner')),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.help_outline, size: 15,),
              ))
          ],
        ),
        const SizedBox(height:10),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: loanIDEdit,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(onPressed: () async {
                                     Clipboard.getData(Clipboard.kTextPlain).then((value) => 
                                     loanIDEdit.text = value?.text??''
                                     );
                                    },
                                     icon: Icon(Icons.content_paste_rounded, color: Theme.of(context).primaryColor,)
                                    ),
                                  fillColor: const Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: 'LONXXXXXXXXXX',
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (text) {
                                  loanID = text.trim();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'The Loan ID is required';
                                  }
                                  return null;
                                },
                              ),
                ),
                // SizedBox.expand(),
                Container(
                  // height: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 30),

                  child: RoundedLoadingButton(
                    borderRadius: 10,
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    controller: _fetchLoanButtonController,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        _fetchLoanButtonController.reset();
                        return;
                      }
                    Map a = await fetchMerchantContract(
                      loanID,
                      'loan',
                      '',
                      brakey.user.value!.payload!.walletAddress??'',
                      brakey.user.value!.payload!.pin??'',
                       'single',
                      );
                      print(a);
                      if (a.containsKey('Status')) {
                              if (a['Status'] == 'successfull' || a['Response Code'] == 202 || a['Response Code'] == 422 || a.containsKey('Payload') || a['Status'] == 'successful') {
                                _fetchLoanButtonController.success();
                                Navigator.of(context).pop();
                                Get.to(() =>
                                  MerchantCreateLoanFromScan(loan:a, user: brakey.user.value!, pin:brakey.pin.value )
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                          actions: [
                                            TextButton(
                                              child: const Text('Okay'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                                    _fetchLoanButtonController.reset();
                                              },
                                            )
                                          ],
                                          title: const Text(
                                              "Loan request failed"),
                                          content: Text(toTitleCase(a['Message'])));
                                    });
                              }
                            } else {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                          actions: [
                                            TextButton(
                                              child: const Text('Okay'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                                    _fetchLoanButtonController.reset();
                                                // Navigator.of(context)
                                                //     .pop();
                                                // Navigator.of(context)
                                                //     .pop();
                                              },
                                            )
                                          ],
                                          title: const Text(
                                              "Failed"),
                                          content: Text(toTitleCase(a['Message']??'No Internet access')));
                                    });
                                // }
            
                              }
            
            
                  }, child: Text('View')),
                ),
                  
                ]),
              ),
            ),
          ],
        ),
    );
  }
}