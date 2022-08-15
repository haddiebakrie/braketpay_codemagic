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
          Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Container(
                          decoration: ContainerDecoration(),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.asset('assets/loan_banner.png')),
                    ),
          
            Expanded(
              child: Container(
                  decoration: ContainerBackgroundDecoration(),
                  padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                          
                          Container(
          width: 60,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(height:20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: double.infinity,),
            const Text('Enter Lender Loan ID', style: TextStyle(fontWeight: FontWeight.w600),),
            Text('Get a Loan ID from the Lender', style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height:10),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: loanIDEdit,
                    minLines: null,
                                    maxLines: null,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(onPressed: () async {
                                     Clipboard.getData(Clipboard.kTextPlain).then((value) {
                                        setState(() {
                                        loanIDEdit.text = value?.text??'';

                                        });

                                     }
                                     );
                                    },
                                     icon: Column(
                                       children: [
                                         Icon(Icons.content_paste_rounded, color: Colors.redAccent),
                                        Text('paste', style: TextStyle(color: Colors.redAccent, fontSize: 7, fontWeight: FontWeight.w600))
                                       ],
                                     )
                                    ),
                                  fillColor: const Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: 'LONXXXXXXXXXX\n',
                                  hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding: const EdgeInsets.all(10),
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
                 
                ]),
              ),
            ),
          ],
        ),
        extendBody: true,
        bottomNavigationBar:  Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                color: Get.isDarkMode ? Color.fromARGB(255, 42, 42, 59) : Colors.white
                ),
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
                      brakey.user.value?.payload?.password??'',
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                 
    );
  }
}