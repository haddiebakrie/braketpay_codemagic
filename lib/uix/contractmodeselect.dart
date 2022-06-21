import 'package:braketpay/classes/user.dart';
import 'package:braketpay/faqs.dart';
import 'package:braketpay/screen/createloanmerchant.dart';
import 'package:braketpay/screen/createproduct.dart';
import 'package:braketpay/screen/createservice.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


import '../api_callers/contracts.dart';
import '../api_callers/merchant.dart';
import '../brakey.dart';
import '../screen/createproductmerchant.dart';
import '../screen/createservicemerchant.dart';
import '../screen/merchantcreateloan.dart';
import '../utils.dart';

class ContractModeSelect extends StatefulWidget {
  ContractModeSelect({Key? key, required this.user, required this.pin}) : super(key: key);

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
  final List<FAQs> _faqs = generateFAQs(FAQItems.length);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Column(
          children: [
            // Icon(CupertinoIcons.doc_plaintext, size: 40),
            Image.asset('assets/stamp.png', width: 70),
            const SizedBox(height:10),
            const Text('Create Payment contracts'),
          ],
        ),
        elevation: 0,
        toolbarHeight: 150,
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Container(
            decoration:ContainerBackgroundDecoration(),
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 40),
            child: Column(children: <Widget>[
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                ),
              ),
          
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: ContainerDecoration(),
                child: Column(
                  children: [
                    const Text(
                      'What type of contract are you creating',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height:10),
                GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    InkWell(
                      onTap: () {
                              setState(() {
                                if (showProduct) {
                                  showProduct = false;
                                  return;
                                }
                                showProduct = true;
                                showService = false;
                                showLoan = false;
                                showEmployment = false;
                                showInsurance = false;
                                showInvestment = false;

                                showRealEstate = false;
                                showPension = false;
                                showGovernment = false;
                              });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        Icon(showProduct ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined, size: 35, color: Colors.red),
                        const SizedBox(height:10),
                        const Text('Buying & Selling', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        
                        )
                      ],),
                    ),
                    InkWell(
                      onTap: () {
                              setState(() {
                                if (showService) {
                                  showService = false;
                                  return;
                                }
                                showProduct = false;
                                showLoan = false;
                                showEmployment = false;
                                showInsurance = false;
                                showRealEstate = false;
                                showInvestment = false;

                                showService = true;
                                showPension = false;
                                showGovernment = false;
                              });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        Icon(showService ? CupertinoIcons.paintbrush_fill : CupertinoIcons.paintbrush, size: 35, color: Colors.teal),
                        const SizedBox(height:10),
                        const Text('Service',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        
                        )
                      ],),
                    ),
                                          InkWell(
                      onTap: () {
                              setState(() {
                                if (showLoan) {
                                  showLoan = false;
                                  return;
                                }
                                showProduct = false;
                                showLoan = true;
                                showEmployment = false;
                                showInsurance = false;
                                showRealEstate = false;
                                showService = false;
                                showInvestment = false;

                                showPension = false;
                                showGovernment = false;
                              });
                      },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        Icon(showLoan ? Icons.store_mall_directory : Icons.store_mall_directory_outlined, size: 35, color: Colors.red),
                        const SizedBox(height:10),
                        const Text('Loan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        
                        )
                      ],),),
                  InkWell(
                      onTap: () {
                              setState(() {
                                if (showEmployment) {
                                  showEmployment = false;
                                  return;
                                }
                                showProduct = false;
                                showLoan = false;
                                showEmployment = true;
                                showInsurance = false;
                                showRealEstate = false;
                                showInvestment = false;

                                showService = false;
                                showPension = false;
                                showGovernment = false;
                              });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        Icon(showEmployment ? Icons.people_alt : Icons.people_alt_outlined, size: 35, color: Colors.indigo),
                        const SizedBox(height:10),
                        const Text('Employment',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        
                        )
                      ],),),
                     
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
                    //       const Text('Real Estate',
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                // margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: ContainerDecoration(),
                child: Column(
                  children: [
                    Visibility(
                      visible: 
                      showService == true || 
                      showProduct == true || 
                      showLoan == true || 
                      showRealEstate == true || 
                      showInsurance == true || 
                      showInvestment == true || 
                      showPension == true || 
                      showGovernment == true || 
                      showEmployment == true ? true : false,
                      child: const Text(
                        'Which one describes you?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => CreateProduct(
                                      creatorType: 'Buyer', user: widget.user, pin: widget.pin)));
                            },
                        child: Column(children:[
                          Icon(Icons.person_pin_circle_rounded, size: 35, color: Colors.red),
                          const SizedBox(height:10),
                          const Text('Buyer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => CreateProduct(
                                      creatorType: 'Seller', user: widget.user, pin: widget.pin)));
                            },
                        child: Column(children:[
                          Icon(Icons.delivery_dining_rounded, size: 35, color: Colors.red),
                          const SizedBox(height:10),
                          const Text('Seller',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.person, size: 35, color: Colors.blue),
                          const SizedBox(height:10),
                          const Text('Company',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.account_circle, size: 35, color: Colors.blue),
                          const SizedBox(height:10),
                          const Text('Pensioneer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.person, size: 35, color: Colors.teal),
                          const SizedBox(height:10),
                          const Text('Business',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.account_circle, size: 35, color: Colors.teal),
                          const SizedBox(height:10),
                          const Text('Investor',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.person, size: 35, color: Colors.purpleAccent),
                          const SizedBox(height:10),
                          const Text('Parastatal',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.account_circle, size: 35, color: Colors.purpleAccent),
                          const SizedBox(height:10),
                          const Text('Contractor',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                              createLoan();
                            },
                        child: Column(children:[
                          Icon(Icons.person, size: 35, color: Colors.red),
                          const SizedBox(height:10),
                          const Text('Borrower',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              Get.to(() => MerchantCreateLoan(merchantID: '', pin: '', user: widget.user));
                            },
                        child: Column(children:[
                          Icon(Icons.account_circle, size: 35, color: Colors.red),
                          const SizedBox(height:10),
                          const Text('Lender',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.person, size: 35, color: Colors.indigo),
                          const SizedBox(height:10),
                          const Text('Employee',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                       onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.account_circle, size: 35, color: Colors.indigo),
                          const SizedBox(height:10),
                          const Text('Employer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.person, size: 35, color: Colors.blue),
                          const SizedBox(height:10),
                          const Text('Insurer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.account_circle, size: 35, color: Colors.blue),
                          const SizedBox(height:10),
                          const Text('Insured',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.person, size: 35, color: Colors.red),
                          const SizedBox(height:10),
                          const Text('Owner',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
                                  ],
                                  content: Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:[
                          Icon(Icons.account_circle, size: 35, color: Colors.red),
                          const SizedBox(height:10),
                          const Text('Buyer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => CreateService(creatorType: 'Provider', user:widget.user, pin: widget.pin)
                          ));
                        },
                        child: Column(children:[
                          Icon(Icons.boy_rounded, size: 35, color: Colors.teal),
                          const SizedBox(height:10),
                          const Text('Provider',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => CreateService(creatorType: 'Client', user:widget.user, pin: widget.pin)
                          ));
                        },
                        child: Column(children:[
                          Icon(Icons.hail_outlined, size: 35, color: Colors.teal),
                          const SizedBox(height:10),
                          const Text('Client',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
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
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: ContainerDecoration(),
                child: Column(
                  children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width:5),
                  Text(
                        'Frequently asked Questions',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ],
              ),
                    ExpansionPanelList(
                      elevation: 0,
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _faqs.forEach((e) => e.isExpanded = false);
                          _faqs[index].isExpanded = !isExpanded;
                        });
                      },
                      children: _faqs.map<ExpansionPanel>((FAQs item) {
                        return ExpansionPanel(
                          backgroundColor: Colors.transparent,
                          canTapOnHeader: true,
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                            minVerticalPadding: 0,
                              title: Text(item.headerValue, style: TextStyle(fontSize: 15)),
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
                )
                
              )
                      
            ])),
      ),
    );
  }
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
        headerValue: FAQItems.keys.toList()[index],
        expandedValue: FAQItems.values.toList()[index].runtimeType != String ? FAQItems.values.toList()[index].toString().replaceAll('[', '●  ').replaceAll(',', '.\n\n●  ').replaceAll(']', '') : FAQItems.values.toList()[index],
      );
    });
}

createLoan() async {
  final _formKey = GlobalKey<FormState>();
  Brakey brakey = Get.put(Brakey());
  final RoundedLoadingButtonController _sendOTPButtonController =
      RoundedLoadingButtonController();
    String loanID = '';
    Get.bottomSheet(
          BottomSheet(
            backgroundColor: Colors.transparent,
            onClosing: () {}, builder: (context) {
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
        const SizedBox(height:10),
        const SizedBox(height:15),
        Text('Enter Loan ID'),
        const SizedBox(height:20),
        Form(
          key: _formKey,
          child: TextFormField(
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(24, 158, 158, 158),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'LONXXXXXXXXXX',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
            TextButton(onPressed: () {
              Navigator.of(context).pop();

            }, child: const Text('Cancel')),
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
            brakey.user.value!.payload!.walletAddress??'',
            brakey.user.value!.payload!.pin??'',
             'single',
            );
            print(a);
            if (a.containsKey('Status')) {
                    if (a['Status'] == 'successfull' || a['Response Code'] == 202 || a['Response Code'] == 422 || a.containsKey('Payload') || a['Status'] == 'successful') {
                      _sendOTPButtonController.success();
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
                                          _sendOTPButtonController.reset();
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
                                          _sendOTPButtonController.reset();
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


        }, child: Text('View', style: TextStyle(color: Theme.of(context).primaryColor))),
          ],
        ),
                  ],
                )

            );
          })

        );
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
