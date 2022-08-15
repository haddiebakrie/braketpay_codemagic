import 'dart:async';

import 'package:braketpay/classes/user.dart';
import 'package:braketpay/faqs.dart';
import 'package:braketpay/screen/createloanmerchant.dart';
import 'package:braketpay/screen/createproduct.dart';
import 'package:braketpay/screen/createservice.dart';
import 'package:braketpay/screen/loanprompt.dart';
import 'package:braketpay/uix/askpin.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/contracts.dart';
import '../api_callers/merchant.dart';
import '../brakey.dart';
import '../screen/createproductmerchant.dart';
import '../screen/createservicemerchant.dart';
import '../screen/merchantcreateloan.dart';
import '../screen/merchantcreateproduct.dart';
import '../screen/merchantcreateservice.dart';
import '../screen/productprompt.dart';
import '../screen/serviceprompt.dart';
import '../utils.dart';

class ContractModeSelect extends StatefulWidget {
  ContractModeSelect({Key? key, required this.user, required this.pin})
      : super(key: key);

  int contractType = 0;
  int creatorType = 0;
  final User user;
  final String pin;

  @override
  State<ContractModeSelect> createState() => _ContractModeSelectState();
}

class _ContractModeSelectState extends State<ContractModeSelect> {
  bool showService = false;
  bool showEmployment = false;
  bool showLoan = false;
  bool showInvestment = false;
  bool showInsurance = false;
  bool showRealEstate = false;
  bool showPension = false;
  bool showGovernment = false;
  bool showProduct = false;
  bool showServiceInputField = true;
  bool showProductInputField = true;
  String pi = '';
  String si = '';
  final List<FAQs> _faqs = generateFAQs(fAQItems.length);
  final List<PFAQs> _pfaqs = generatePFAQs(productFAQ.length);
  final List<SFAQs> _sfaqs = generateSFAQs(serviceFAQ.length);
  final List<LFAQs> _lfaqs = generateLFAQs(loanFAQ.length);
  final RoundedLoadingButtonController _piButtonController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _siButtonController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _liButtonController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Theme.of(context).primaryColor),
        Image.asset(
          'assets/braket-bg_grad-01.png',
          height: 300,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Column(
              children: [
                // Icon(CupertinoIcons.doc_plaintext, size: 40),
                Image.asset('assets/stamp.png', width: 70),
                const SizedBox(height: 10),
                const Text('Create Payment contracts'),
              ],
            ),
            elevation: 0,
            toolbarHeight: 150,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
                decoration: ContainerBackgroundDecoration(),
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 10, bottom: 40),
                child: Column(children: <Widget>[
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: ContainerDecoration(),
                    child: Column(
                      children: [
                        const Text(
                          'What type of contract are you creating',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 1),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            InkWell(
                              onTap: () {
                                productPrompt();
                                // setState(() {
                                //   if (showProduct) {
                                //     showProduct = false;
                                //     return;
                                //   }
                                //   showProduct = true;
                                //   showService = false;
                                //   showLoan = false;
                                //   showEmployment = false;
                                //   showInsurance = false;
                                //   showInvestment = false;

                                //   showRealEstate = false;
                                //   showPension = false;
                                //   showGovernment = false;
                                // });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      showProduct
                                          ? Icons.shopping_cart_rounded
                                          : Icons.shopping_cart_outlined,
                                      size: 35,
                                      color: Colors.red),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Buy & Sell',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                servicePrompt();
                                // setState(() {
                                //   if (showService) {
                                //     showService = false;
                                //     return;
                                //   }
                                //   showProduct = false;
                                //   showLoan = false;
                                //   showEmployment = false;
                                //   showInsurance = false;
                                //   showRealEstate = false;
                                //   showInvestment = false;

                                //   showService = true;
                                //   showPension = false;
                                //   showGovernment = false;
                                // });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      showService
                                          ? CupertinoIcons.paintbrush_fill
                                          : CupertinoIcons.paintbrush,
                                      size: 35,
                                      color: Colors.teal),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Service',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                loanPrompt();
                                // setState(() {
                                //   if (showLoan) {
                                //     showLoan = false;
                                //     return;
                                //   }
                                //   showProduct = false;
                                //   showLoan = true;
                                //   showEmployment = false;
                                //   showInsurance = false;
                                //   showRealEstate = false;
                                //   showService = false;
                                //   showInvestment = false;

                                //   showPension = false;
                                //   showGovernment = false;
                                // });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      showLoan
                                          ? Icons.store_mall_directory
                                          : Icons.store_mall_directory_outlined,
                                      size: 35,
                                      color: Colors.red),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Loan',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       if (showEmployment) {
                            //         showEmployment = false;
                            //         return;
                            //       }
                            //       showProduct = false;
                            //       showLoan = false;
                            //       showEmployment = true;
                            //       showInsurance = false;
                            //       showRealEstate = false;
                            //       showInvestment = false;

                            //       showService = false;
                            //       showPension = false;
                            //       showGovernment = false;
                            //     });
                            //   },
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Icon(
                            //           showEmployment
                            //               ? Icons.people_alt
                            //               : Icons.people_alt_outlined,
                            //           size: 35,
                            //           color: Colors.indigo),
                            //       const SizedBox(height: 10),
                            //       const Text(
                            //         'Payroll',
                            //         style: TextStyle(
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.w500),
                            //       )
                            //     ],
                            //   ),
                            // ),

                            //   InkWell(
                            //   onTap: () {
                            //           setState(() {
                            //             if (showGovernment) {
                            //               showGovernment = false;
                            //               return;
                            //             }
                            //             showProduct = false;
                            //             showLoan = false;
                            //             showEmployment = false;
                            //             showInsurance = false;
                            //             showInvestment = false;
                            //             showRealEstate = false;
                            //             showService = false;
                            //             showGovernment= true;
                            //             showPension = false;
                            //           });
                            //   },
                            //     child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,children:[

                            //       Icon(
                            //         showGovernment ? Icons.corporate_fare:
                            //         Icons.corporate_fare_outlined, size: 35, color: Colors.purpleAccent),
                            //       const SizedBox(height:10),
                            //       const Text('Government',
                            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

                            //       )
                            //     ],),
                            //   ),

                            //   InkWell(
                            //   onTap: () {
                            //           setState(() {
                            //             if (showInvestment) {
                            //               showInvestment = false;
                            //               return;
                            //             }
                            //             showProduct = false;
                            //             showLoan = false;
                            //             showEmployment = false;
                            //             showInsurance = false;
                            //             showInvestment = true;
                            //             showRealEstate = false;
                            //             showService = false;
                            //             showGovernment= false;
                            //             showPension = false;
                            //           });
                            //   },
                            //     child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,children:[

                            //       Icon(
                            //         showInvestment ? Icons.landscape:
                            //         Icons.landscape_outlined, size: 35, color: Colors.teal),
                            //       const SizedBox(height:10),
                            //       const Text('Investment',
                            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

                            //       )
                            //     ],),
                            //   ),
                            //   InkWell(
                            //   onTap: () {
                            //           setState(() {
                            //             if (showInsurance) {
                            //               showInsurance = false;
                            //               return;
                            //             }
                            //             showProduct = false;
                            //             showLoan = false;
                            //             showEmployment = false;
                            //             showInvestment = false;

                            //             showInsurance = true;
                            //             showRealEstate = false;
                            //             showService = false;
                            //             showPension = false;
                            //             showGovernment = false;
                            //           });
                            //   },
                            // child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children:[
                            //     Icon(showInsurance ? Icons.health_and_safety : Icons.health_and_safety_outlined, size: 35, color: Colors.blue),
                            //     const SizedBox(height:10),
                            //     const Text('Insurance',
                            //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

                            //     )
                            //   ],),),
                            //   InkWell(
                            //   onTap: () {
                            //           setState(() {
                            //             if (showRealEstate) {
                            //               showRealEstate = false;
                            //               return;
                            //             }
                            //             showProduct = false;
                            //             showLoan = false;
                            //             showEmployment = false;
                            //             showInsurance = false;
                            //             showRealEstate = true;
                            //             showInvestment = false;

                            //             showService = false;
                            //             showPension = false;
                            //             showGovernment = false;
                            //           });
                            //   },
                            //     child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,children:[

                            //       Icon(showRealEstate ? Icons.apartment : Icons.apartment_outlined, size: 35, color: Colors.blue),
                            //       const SizedBox(height:10),
                            //       const Text('Property',
                            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

                            //       )
                            //     ],),
                            //   ),
                            //   InkWell(
                            //   onTap: () {
                            //           setState(() {
                            //             if (showPension) {
                            //               showPension = false;
                            //               return;
                            //             }
                            //             showProduct = false;
                            //             showLoan = false;
                            //             showEmployment = false;
                            //             showInsurance = false;
                            //             showRealEstate = false;
                            //             showInvestment = false;

                            //             showService = false;
                            //             showPension = true;
                            //             showGovernment = false;

                            //           });
                            //   },
                            //     child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,children:[

                            //       Icon(showPension ? Icons.work : Icons.work_outline, size: 35, color: Colors.blue),
                            //       const SizedBox(height:10),
                            //       const Text('Pension',
                            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

                            //       )
                            //     ],),
                            //   ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: ContainerDecoration(),
                    child: Column(
                      children: [
                        Visibility(
                          visible: showService == true ||
                                  showProduct == true ||
                                  showLoan == true ||
                                  showRealEstate == true ||
                                  showInsurance == true ||
                                  showInvestment == true ||
                                  showPension == true ||
                                  showGovernment == true ||
                                  showEmployment == true
                              ? true
                              : false,
                          child: const Text(
                            'Which one describes you?',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          visible: showProduct,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => ProductPrompt(
                                          user: widget.user,
                                          creatorType: 'Buyer',
                                        ));
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.person_pin_circle_rounded,
                                          size: 35, color: Colors.red),
                                      SizedBox(height: 10),
                                      Text(
                                        'Buyer',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => ProductPrompt(
                                          user: widget.user,
                                          creatorType: 'Seller',
                                        ));
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.delivery_dining_rounded,
                                          size: 35, color: Colors.red),
                                      SizedBox(height: 10),
                                      Text(
                                        'Seller',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showPension,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.person,
                                          size: 35, color: Colors.blue),
                                      SizedBox(height: 10),
                                      Text(
                                        'Company',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.account_circle,
                                          size: 35, color: Colors.blue),
                                      SizedBox(height: 10),
                                      Text(
                                        'Pensioneer',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showInvestment,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.person,
                                          size: 35, color: Colors.teal),
                                      SizedBox(height: 10),
                                      Text(
                                        'Business',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.account_circle,
                                          size: 35, color: Colors.teal),
                                      SizedBox(height: 10),
                                      Text(
                                        'Investor',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showGovernment,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.person,
                                          size: 35, color: Colors.purpleAccent),
                                      SizedBox(height: 10),
                                      Text(
                                        'Parastatal',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.account_circle,
                                          size: 35, color: Colors.purpleAccent),
                                      SizedBox(height: 10),
                                      Text(
                                        'Contractor',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showLoan,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => const LoanIDPrompt());
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.person,
                                          size: 35, color: Colors.red),
                                      SizedBox(height: 10),
                                      Text(
                                        'Borrower',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => MerchantCreateLoan(
                                        merchantID: '',
                                        pin: '',
                                        user: widget.user));
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.account_circle,
                                          size: 35, color: Colors.red),
                                      SizedBox(height: 10),
                                      Text(
                                        'Lender',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showEmployment,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.person,
                                          size: 35, color: Colors.indigo),
                                      SizedBox(height: 10),
                                      Text(
                                        'Employee',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.account_circle,
                                          size: 35, color: Colors.indigo),
                                      SizedBox(height: 10),
                                      Text(
                                        'Employer',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showInsurance,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.person,
                                          size: 35, color: Colors.blue),
                                      SizedBox(height: 10),
                                      Text(
                                        'Insurer',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.account_circle,
                                          size: 35, color: Colors.blue),
                                      SizedBox(height: 10),
                                      Text(
                                        'Insured',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showRealEstate,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.person,
                                          size: 35, color: Colors.red),
                                      SizedBox(height: 10),
                                      Text(
                                        'Owner',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                            title: const Text(
                                                'Not Available yet.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                            content: const Text(
                                                'This Feature would be available in Public release V2.0'),
                                          );
                                        });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.account_circle,
                                          size: 35, color: Colors.red),
                                      SizedBox(height: 10),
                                      Text(
                                        'Buyer',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showService,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => ServicePrompt(
                                          user: widget.user,
                                          creatorType: 'Provider',
                                        ));
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.boy_rounded,
                                          size: 35, color: Colors.teal),
                                      SizedBox(height: 10),
                                      Text(
                                        'Provider',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => ServicePrompt(
                                          user: widget.user,
                                          creatorType: 'Client',
                                        ));
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Icons.hail_outlined,
                                          size: 35, color: Colors.teal),
                                      SizedBox(height: 10),
                                      Text(
                                        'Client',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      // margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ContainerDecoration(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(width: 5),
                              Text(
                                'Frequently asked Questions',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            elevation: 0,
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                for (var e in _faqs) {
                                  e.isExpanded = false;
                                }
                                _faqs[index].isExpanded = !isExpanded;
                              });
                            },
                            children: _faqs.map<ExpansionPanel>((FAQs item) {
                              return ExpansionPanel(
                                backgroundColor: Colors.transparent,
                                canTapOnHeader: true,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    minVerticalPadding: 0,
                                    title: Text(item.headerValue,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  );
                                },
                                body: ListTile(
                                  minVerticalPadding: 0,
                                  // contentPadding: 0,
                                  subtitle: Text(item.expandedValue),
                                ),
                                isExpanded: item.isExpanded,
                              );
                            }).toList(),
                          ),
                        ],
                      ))
                ])),
          ),
        ),
      ],
    );
  }
}

Future<dynamic> servicePrompt() {
  final List<FAQs> _faqs = generateFAQs(fAQItems.length);
  final List<PFAQs> _pfaqs = generatePFAQs(productFAQ.length);
  final List<SFAQs> _sfaqs = generateSFAQs(serviceFAQ.length);
  final List<LFAQs> _lfaqs = generateLFAQs(loanFAQ.length);
  Brakey brakey = Get.put(Brakey());
  bool showServiceInputField = true;
  String pi = '';
  String si = '';
  bool showProductInputField = true;
  final RoundedLoadingButtonController _piButtonController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _siButtonController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _liButtonController =
      RoundedLoadingButtonController();
  return Get.bottomSheet(
      Container(
        margin: const EdgeInsets.only(top: 180),
        child: StatefulBuilder(builder: (context, setState) {
          return BottomSheet(
              // isDismissible: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              onClosing: () {
                showServiceInputField = false;
              },
              builder: (context) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: ContainerBackgroundDecoration(),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height: 10),
                            const Text('Create a Service contract',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: ContainerDecoration()
                                            .copyWith(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(15),
                                        child: InkWell(
                                          onTap: () {
                                            // Get.close(1);

                                            Get.to(() => ServicePrompt(
                                                  user: brakey.user.value!,
                                                  creatorType: 'Provider',
                                                ));
                                          },
                                          child: Column(children: const [
                                            Icon(Icons.person_pin,
                                                color: Colors.red),
                                            SizedBox(height: 10),
                                            Text(
                                              'As a Provider',
                                              style: TextStyle(
                                                color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            FittedBox(
                                              child: Text(
                                                  'Render your\nservice and get paid for it.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.grey, fontWeight: FontWeight.w600)),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: ContainerDecoration()
                                            .copyWith(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(15),
                                        child: InkWell(
                                          onTap: () {
                                            // Get.close(1);
                                            Get.to(() => ServicePrompt(
                                                  user: brakey.user.value!,
                                                  creatorType: 'Client',
                                                ));
                                          },
                                          child: Column(children: const [
                                            Icon(Icons.person_pin_rounded,
                                                color: Colors.teal),
                                            SizedBox(height: 10),
                                            Text(
                                              'As a Client',
                                              style: TextStyle(
                                                color: Colors.teal,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            FittedBox(
                                              child: Text(
                                                  'Only pay\n for each completed stage.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.grey, fontWeight: FontWeight.w600)),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            height: 1, color: Colors.grey),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('or',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            height: 1, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                // const SizedBox(height: 20),
                                StatefulBuilder(
                                    builder: (context, changeState) {
                                  return Container(
                                    padding: EdgeInsets.all(10),

                                    decoration: ContainerDecoration().copyWith(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(children: [
                                      ListTile(
                                        title: const Text(
                                            "Use a Provider's Service ID?", style: TextStyle(fontWeight: FontWeight.w600)),
                                        subtitle: const FittedBox(
                                            child: Text(
                                                'You can get a Service ID from a Service provider')),
                                        trailing: Icon(!showServiceInputField
                                            ? Icons.chevron_right
                                            : Icons.keyboard_arrow_up_sharp),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        onTap: () {
                                          changeState(() {
                                            showServiceInputField =
                                                !showServiceInputField;
                                          });
                                        },
                                      ),
                                      Visibility(
                                        visible: showServiceInputField,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              TextField(
                                                  cursorColor: Colors.grey,
                                                   maxLines: null,
                                                  minLines: null,
                                                decoration:
                                                    const InputDecoration(
                                                  fillColor: Color.fromARGB(
                                                      24, 158, 158, 158),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  hintStyle: TextStyle(fontWeight: FontWeight.w600),
                                                    hintText: 'SERXXXXXXXXXX\n',
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                  ),
                                                  onChanged: (text) {
                                                    setState(() {
                                                      si = text;
                                                    });
                                                  }),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              RoundedLoadingButton(
                                                  controller:
                                                      _siButtonController,
                                                  child: const Text('View'),
                                                  borderRadius: 10,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  elevation: 0,
                                                  onPressed: () async {
                                                    StreamController<
                                                            ErrorAnimationType>
                                                        _pinErrorController =
                                                        StreamController<
                                                            ErrorAnimationType>();
                                                    final _pinEditController =
                                                        TextEditingController();
                                                    Map? pin = await askPin(
                                                        _pinEditController,
                                                        _pinErrorController);

                                                    if (pin == null ||
                                                        !pin.containsKey(
                                                            'pin')) {
                                                      _siButtonController
                                                          .reset();
                                                      return;
                                                    }

                                                    nPressed:
                                                    () async {
                                                      Map a = await fetchMerchantContract(
                                                          si,
                                                          'service',
                                                          '',
                                                          brakey
                                                                  .user
                                                                  .value!
                                                                  .payload!
                                                                  .walletAddress ??
                                                              '',
                                                          pin['pin'],
                                                          'single',
                      brakey.user.value?.payload?.password??'',
                                                          
                                                          );
                                                      print(a);

                                                      if (a.containsKey(
                                                          'Payload')) {
                                                        a['Payload'].addEntries(
                                                            {
                                                          'merchant_id': '',
                                                          'service_id': si
                                                        }.entries);
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: ((context) =>
                                                                MerchantCreateServiceFromScan(
                                                                    product: a[
                                                                        'Payload'],
                                                                    user: brakey
                                                                        .user
                                                                        .value!,
                                                                    pin: pin[
                                                                        'pin']))));
                                                      } else {
                                                        _siButtonController
                                                            .reset();
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (prompt) {
                                                              return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'Okay'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(prompt)
                                                                            .pop();
                                                                        // Navigator.of(context).pop();
                                                                        // Navigator.of(context).pop();
                                                                      },
                                                                    )
                                                                  ],
                                                                  title: const Text(
                                                                      "Can't fetch Service Contract!"),
                                                                  content: Text(
                                                                      a['Message']));
                                                            });
                                                      }
                                                    };
                                                  })
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                }),
                                const SizedBox(height: 20),
                                Container(
                                    padding: const EdgeInsets.all(20),

                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: ContainerDecoration(),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(width: 5),
                                            Text(
                                              'Frequently asked Questions',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                const SizedBox(height: 20),
                                        StatefulBuilder(
                                            builder: (context, toggleExpand) {
                                          return ExpansionPanelList(
                                            elevation: 0,
                                            expandedHeaderPadding:
                                                EdgeInsets.symmetric(vertical:5),
                                            expansionCallback:
                                                (int index, bool isExpanded) {
                                              toggleExpand(() {
                                                for (var e in _sfaqs) {
                                                  e.isExpanded = false;
                                                }
                                                _sfaqs[index].isExpanded =
                                                    !isExpanded;
                                              });
                                            },
                                            children: _sfaqs
                                                .map<ExpansionPanel>(
                                                    (SFAQs item) {
                                              return ExpansionPanel(
                                                
                                                backgroundColor:
                                                    Colors.transparent,
                                                canTapOnHeader: true,
                                                headerBuilder:
                                                    (BuildContext context,
                                                        bool isExpanded) {
                                                  return ListTile(
                                                    minVerticalPadding: 0,
                                                    title: Text(
                                                        item.headerValue,
                                                        style: const TextStyle(
                                                            fontSize: 15, fontWeight: FontWeight.w600)),
                                                  );
                                                },
                                                body: Text(item.expandedValue),
                                                isExpanded: item.isExpanded,
                                              );
                                            }).toList(),
                                          );
                                        }),
                                      ],
                                    ))
                              ],
                            )
                          ])),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.close(1);
                        },
                        icon: const Icon(Icons.close)),
                  ],
                );
              });
        }),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      isDismissible: true,
      enableDrag: true);
}

Future<dynamic> productPrompt() {
  final List<FAQs> _faqs = generateFAQs(fAQItems.length);
  final List<PFAQs> _pfaqs = generatePFAQs(productFAQ.length);
  final List<SFAQs> _sfaqs = generateSFAQs(serviceFAQ.length);
  final List<LFAQs> _lfaqs = generateLFAQs(loanFAQ.length);
  Brakey brakey = Get.put(Brakey());
  bool showServiceInputField = true;
  String pi = '';
  String si = '';
  bool showProductInputField = true;
  final RoundedLoadingButtonController _piButtonController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _siButtonController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _liButtonController =
      RoundedLoadingButtonController();
  return Get.bottomSheet(
      Container(
        margin: const EdgeInsets.only(top: 180),
        child: StatefulBuilder(builder: (context, setState) {
          return BottomSheet(
              // isDismissible: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              onClosing: () {
                showServiceInputField = false;
              },
              builder: (context) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: ContainerBackgroundDecoration(),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height: 20),
                            const Text('Create a Buy & Sell contract',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: ContainerDecoration()
                                            .copyWith(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            // Get.close(1);
                                            Get.to(() => ProductPrompt(
                                                  user: brakey.user.value!,
                                                  creatorType: 'Seller',
                                                ));
                                          },
                                          child: Column(children: const [
                                            Icon(Icons.person_pin,
                                                color: Colors.red),
                                            SizedBox(height: 10),
                                            Text(
                                              'As a Seller',
                                              style: TextStyle(
                                                color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            FittedBox(
                                              child: Text(
                                                  'Avoid\nunneccesary order cancellation.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.grey, fontWeight: FontWeight.w600)),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: ContainerDecoration()
                                            .copyWith(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            // Get.close(1);
                                            Get.to(() => ProductPrompt(
                                                  user: brakey.user.value!,
                                                  creatorType: 'Buyer',
                                                ));
                                          },
                                          child: Column(children: const [
                                            Icon(Icons.person_pin_rounded,
                                                color: Colors.teal),
                                            SizedBox(height: 10),
                                            Text(
                                              'As a Buyer',
                                              style: TextStyle(
                                                color: Colors.teal,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            FittedBox(
                                              child: Text(
                                                  'Prevent\n "What I ordered VS What I Got".',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.grey, fontWeight: FontWeight.w600)),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            height: 1, color: Colors.grey),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('or',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            height: 1, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                StatefulBuilder(
                                    builder: (context, changeState) {
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: ContainerDecoration().copyWith(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(children: [
                                      ListTile(
                                        minVerticalPadding: 0,
                                        title: const Text(
                                            "Use a Seller's Product ID", style: TextStyle(fontWeight: FontWeight.w600)),
                                        subtitle: const FittedBox(
                                            child: Text(
                                                'You can get a Product ID from the Seller')),
                                        trailing: Icon(!showProductInputField
                                            ? Icons.chevron_right
                                            : Icons.keyboard_arrow_up_sharp),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        onTap: () {
                                          changeState(() {
                                            showProductInputField =
                                                !showProductInputField;
                                          });
                                        },
                                      ),
                                      Visibility(
                                        visible: showProductInputField,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              TextField(
                                                cursorColor: Colors.grey,
                                                  maxLines: null,
                                                  minLines: null,
                                                decoration:
                                                    const InputDecoration(
                                                  fillColor: Color.fromARGB(
                                                      24, 158, 158, 158),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  hintStyle: TextStyle(fontWeight: FontWeight.w600),
                                                  hintText: 'PRDXXXXXXXXXX\n',
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                ),
                                                onChanged: (text) {
                                                  setState(() {
                                                    pi = text;
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              RoundedLoadingButton(
                                                controller: _piButtonController,
                                                child: const Text('View'),
                                                borderRadius: 10,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                elevation: 0,
                                                onPressed: () async {
                                                  StreamController<
                                                          ErrorAnimationType>
                                                      _pinErrorController =
                                                      StreamController<
                                                          ErrorAnimationType>();
                                                  final _pinEditController =
                                                      TextEditingController();
                                                  Map? pin = await askPin(
                                                      _pinEditController,
                                                      _pinErrorController);

                                                  if (pin == null ||
                                                      !pin.containsKey('pin')) {
                                                    _siButtonController.reset();
                                                    return;
                                                  }
                                                  Map a =
                                                      await fetchMerchantContract(
                                                          pi,
                                                          'product',
                                                          '',
                                                          brakey
                                                                  .user
                                                                  .value!
                                                                  .payload!
                                                                  .walletAddress ??
                                                              '',
                                                          pin['pin'],
                                                          'single',
                      brakey.user.value?.payload?.password??'',
                                                          
                                                          );
                                                  print(a);

                                                  if (a
                                                      .containsKey('Payload')) {
                                                    a['Payload'].addEntries({
                                                      'merchant_id': '',
                                                      'product_id': pi
                                                    }.entries);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: ((context) =>
                                                                MerchantCreateProductFromScan(
                                                                    product: a[
                                                                        'Payload'],
                                                                    user: brakey
                                                                        .user
                                                                        .value!,
                                                                    pin: pin[
                                                                        'pin']))));
                                                  } else {
                                                    _piButtonController.reset();
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (prompt) {
                                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                                              actions: [
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          'Okay'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            prompt)
                                                                        .pop();
                                                                    // Navigator.of(context).pop();
                                                                    // Navigator.of(context).pop();
                                                                  },
                                                                )
                                                              ],
                                                              title: const Text(
                                                                  "Can't fetch Product Contract!"),
                                                              content: Text(a[
                                                                  'Message']));
                                                        });
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                }),
                                const SizedBox(height: 20),
                                Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: ContainerDecoration(),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(width: 5),
                                            Text(
                                              'Frequently asked Questions',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:20),
                                        StatefulBuilder(
                                            builder: (context, toggleExpand) {
                                          return ExpansionPanelList(
                                            elevation: 0,
                                            expandedHeaderPadding:
                                                EdgeInsets.symmetric(vertical:5),
                                            expansionCallback:
                                                (int index, bool isExpanded) {
                                              toggleExpand(() {
                                                for (var e in _pfaqs) {
                                                  e.isExpanded = false;
                                                }
                                                _pfaqs[index].isExpanded =
                                                    !isExpanded;
                                              });
                                            },
                                            children: _pfaqs
                                                .map<ExpansionPanel>(
                                                    (PFAQs item) {
                                              return ExpansionPanel(
                                                backgroundColor:
                                                    Colors.transparent,
                                                canTapOnHeader: true,
                                                headerBuilder:
                                                    (BuildContext context,
                                                        bool isExpanded) {
                                                  return ListTile(
                                                    minVerticalPadding: 0,
                                                    title: Text(
                                                        item.headerValue,
                                                        style: const TextStyle(
                                                            fontSize: 15, fontWeight: FontWeight.w600)),
                                                  );
                                                },
                                                body: Text(item.expandedValue),
                                                isExpanded: item.isExpanded,
                                              );
                                            }).toList(),
                                          );
                                        }),
                                      ],
                                    ))
                              ],
                            )
                          ])),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.close(1);
                        },
                        icon: const Icon(Icons.close)),
                  ],
                );
              });
        }),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      isDismissible: true,
      enableDrag: true);
}

Future<dynamic> loanPrompt() {
  final List<FAQs> _faqs = generateFAQs(fAQItems.length);
  final List<PFAQs> _pfaqs = generatePFAQs(productFAQ.length);
  final List<SFAQs> _sfaqs = generateSFAQs(serviceFAQ.length);
  final List<LFAQs> _lfaqs = generateLFAQs(loanFAQ.length);
  Brakey brakey = Get.put(Brakey());
  bool showServiceInputField = true;
  String pi = '';
  String si = '';
  bool showProductInputField = true;
  final RoundedLoadingButtonController _piButtonController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _siButtonController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _liButtonController =
      RoundedLoadingButtonController();
  return Get.bottomSheet(
      Container(
        margin: const EdgeInsets.only(top: 180),
        child: BottomSheet(
            // isDismissible: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            onClosing: () {
              showServiceInputField = false;
            },
            builder: (context) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: ContainerBackgroundDecoration(),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(height: 20),
                          const Text('Create a Loan contract',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: ContainerDecoration()
                                          .copyWith(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          // Get.close(1);
                                          Get.to(() => const LoanIDPrompt());
                                        },
                                        child: Column(children: const [
                                          Icon(Icons.person_pin,
                                              color: Colors.red),
                                          SizedBox(height: 10),
                                          Text(
                                            'As a Borrower',
                                            style: TextStyle(
                                              color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          FittedBox(
                                            child: Text('Get a\n  Loan without Stress  ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.grey, fontWeight: FontWeight.w600)),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      decoration: ContainerDecoration()
                                          .copyWith(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          // Get.close(1);
                                          Get.to(() => MerchantCreateLoan(
                                              merchantID: '',
                                              pin: '',
                                              user: brakey.user.value!));
                                        },
                                        child: Column(children: const [
                                          Icon(Icons.person_pin_rounded,
                                              color: Colors.teal),
                                          SizedBox(height: 10),
                                          Text(
                                            'As a Lender',
                                            style: TextStyle(
                                              color: Colors.teal,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          FittedBox(
                                            child: Text(
                                                'Avoid\nUnnecessary Loan Defaults',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.grey, fontWeight: FontWeight.w600)),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                  padding:
                                      const EdgeInsets.all(20),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: ContainerDecoration(),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          SizedBox(width: 5),
                                          Text(
                                            'Frequently asked Questions',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                        SizedBox(height:20),

                                      StatefulBuilder(
                                          builder: (context, toggleExpand) {
                                        return ExpansionPanelList(
                                          elevation: 0,
                                          expandedHeaderPadding:
                                              EdgeInsets.zero,
                                          expansionCallback:
                                              (int index, bool isExpanded) {
                                            toggleExpand(() {
                                              for (var e in _lfaqs) {
                                                e.isExpanded = false;
                                              }
                                              _lfaqs[index].isExpanded =
                                                  !isExpanded;
                                            });
                                          },
                                          children: _lfaqs.map<ExpansionPanel>(
                                              (LFAQs item) {
                                            return ExpansionPanel(
                                              backgroundColor:
                                                  Colors.transparent,
                                              canTapOnHeader: true,
                                              headerBuilder:
                                                  (BuildContext context,
                                                      bool isExpanded) {
                                                return  ListTile(
                                                    minVerticalPadding: 0,
                                                    title: Text(
                                                        item.headerValue,
                                                        style: const TextStyle(
                                                            fontSize: 15, fontWeight: FontWeight.w600)),
                                                );
                                              },
                                              body: Text(item.expandedValue),
                                              isExpanded: item.isExpanded,
                                            );
                                          }).toList(),
                                        );
                                      }),
                                    ],
                                  ))
                            ],
                          )
                        ])),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.close(1);
                      },
                      icon: const Icon(Icons.close)),
                ],
              );
            }),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      isDismissible: true,
      enableDrag: true);
}

class FAQs {
  FAQs({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<FAQs> generateFAQs(int length) {
  return List<FAQs>.generate(length, (int index) {
    return FAQs(
      headerValue: fAQItems.keys.toList()[index],
      expandedValue: fAQItems.values.toList()[index].runtimeType != String
          ? fAQItems.values
              .toList()[index]
              .toString()
              .replaceAll('[', '●  ')
              .replaceAll(',', '.\n\n●  ')
              .replaceAll(']', '')
          : fAQItems.values.toList()[index],
    );
  });
}

class PFAQs {
  PFAQs({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<PFAQs> generatePFAQs(int length) {
  return List<PFAQs>.generate(length, (int index) {
    return PFAQs(
      headerValue: productFAQ.keys.toList()[index],
      expandedValue: productFAQ.values.toList()[index].runtimeType != String
          ? productFAQ.values
              .toList()[index]
              .toString()
              .replaceAll('[', '●  ')
              .replaceAll(',', '.\n\n●  ')
              .replaceAll(']', '')
          : productFAQ.values.toList()[index],
    );
  });
}

class SFAQs {
  SFAQs({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<SFAQs> generateSFAQs(int length) {
  return List<SFAQs>.generate(length, (int index) {
    return SFAQs(
      headerValue: serviceFAQ.keys.toList()[index],
      expandedValue: serviceFAQ.values.toList()[index].runtimeType != String
          ? serviceFAQ.values
              .toList()[index]
              .toString()
              .replaceAll('[', '●  ')
              .replaceAll(',', '.\n\n●  ')
              .replaceAll(']', '')
          : serviceFAQ.values.toList()[index],
    );
  });
}

class LFAQs {
  LFAQs({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<LFAQs> generateLFAQs(int length) {
  return List<LFAQs>.generate(length, (int index) {
    return LFAQs(
      headerValue: loanFAQ.keys.toList()[index],
      expandedValue: loanFAQ.values.toList()[index].runtimeType != String
          ? loanFAQ.values
              .toList()[index]
              .toString()
              .replaceAll('[', '●  ')
              .replaceAll(',', '.\n\n●  ')
              .replaceAll(']', '')
          : loanFAQ.values.toList()[index],
    );
  });
}

createLoan() async {
  final _formKey = GlobalKey<FormState>();
  Brakey brakey = Get.put(Brakey());
  final RoundedLoadingButtonController _sendOTPButtonController =
      RoundedLoadingButtonController();
  String loanID = '';
  Get.bottomSheet(BottomSheet(
      backgroundColor: Colors.transparent,
      onClosing: () {},
      builder: (context) {
        return Container(
            padding: const EdgeInsets.all(20),
            decoration: ContainerBackgroundDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 15),
                const Text('Enter Loan ID'),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(24, 158, 158, 158),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'LONXXXXXXXXXX',
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')),
                    RoundedLoadingButton(
                        width: 30,
                        elevation: 0,
                        color: Colors.transparent,
                        valueColor: Theme.of(context).primaryColor,
                        controller: _sendOTPButtonController,
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            _sendOTPButtonController.reset();
                            return;
                          }
                          Map a = await fetchMerchantContract(
                            loanID,
                            'loan',
                            '',
                            brakey.user.value!.payload!.walletAddress ?? '',
                            brakey.user.value!.payload!.pin ?? '',
                            'single',
                      brakey.user.value?.payload?.password??'',

                          );
                          print(a);
                          if (a.containsKey('Status')) {
                            if (a['Status'] == 'successfull' ||
                                a['Response Code'] == 202 ||
                                a['Response Code'] == 422 ||
                                a.containsKey('Payload') ||
                                a['Status'] == 'successful') {
                              _sendOTPButtonController.success();
                              Navigator.of(context).pop();
                              Get.to(() => MerchantCreateLoanFromScan(
                                  loan: a,
                                  user: brakey.user.value!,
                                  pin: brakey.pin.value));
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
                                              Navigator.of(context).pop();
                                              _sendOTPButtonController.reset();
                                            },
                                          )
                                        ],
                                        title:
                                            const Text("Loan request failed"),
                                        content:
                                            Text(toTitleCase(a['Message'])));
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
                                            Navigator.of(context).pop();
                                            _sendOTPButtonController.reset();
                                            // Navigator.of(context)
                                            //     .pop();
                                            // Navigator.of(context)
                                            //     .pop();
                                          },
                                        )
                                      ],
                                      title: const Text("Failed"),
                                      content: Text(toTitleCase(a['Message'] ??
                                          'No Internet access')));
                                });
                            // }

                          }
                        },
                        child: Text('View',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor))),
                  ],
                ),
              ],
            ));
      }));
}
// class MerchantContractModeSelect extends StatefulWidget {
//   MerchantContractModeSelect({Key? key, required this.user, required this.merchantID,required this.pin}) : super(key: key);

//   int contractType = 0;
//   int creatorType = 0;
//   String merchantID;
//   final User user;
//   final String pin;

//   @override
//   State<MerchantContractModeSelect> createState() => _MerchantContractModeSelectState();
// }

// class _MerchantContractModeSelectState extends State<MerchantContractModeSelect> {
//   bool showService = false;
//   bool showProduct = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//         padding:
//             const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 40),
//         child: Column(children: <Widget>[
//           Center(
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 20),
//               width: 60,
//               height: 5,
//               decoration: BoxDecoration(
//                   color: Colors.grey, borderRadius: BorderRadius.circular(10)),
//             ),
//           ),
//           const SizedBox(height:30),

//           const Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Text(
//               'What type of template are you creating',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height:30),

//           Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     UtilityButtonO(
//                         url: 'assets/paint-roller.png',
//                         text: 'Service',
//                         onTap: () {
//                           print(widget.contractType);
//                           setState(() {
//                             Navigator.of(context).push(MaterialPageRoute(
//                         builder: (BuildContext context) => MerchantCreateService(user:widget.user, pin: widget.pin, merchantID: widget.merchantID)));
//                           });
//                         }),
//                     Visibility(
//                       visible: showService,
//                       child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
//                     )
//                   ],
//                 ),
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     UtilityButtonO(
//                         url: 'assets/shopping-bag.png',
//                         text: 'Product',
//                         onTap: () {
//                           setState(() {
//                             Navigator.of(context).push(MaterialPageRoute(
//                             builder: (BuildContext context) => MerchantCreateProduct(
//                                 merchantID: widget.merchantID, user: widget.user, pin: widget.pin)));
//                           });
//                         }),
//                     Visibility(
//                       visible: showProduct,
//                       child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),

//         ]));
//   }
// }
