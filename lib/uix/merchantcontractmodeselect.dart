import 'package:braketpay/classes/user.dart';
import 'package:braketpay/faqs.dart';
import 'package:braketpay/screen/createproduct.dart';
import 'package:braketpay/screen/createservice.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:braketpay/uix/utilitybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/createloanmerchant.dart';
import '../screen/createproductmerchant.dart';
import '../screen/createservicemerchant.dart';

class MerchantContractModeSelect extends StatefulWidget {
  MerchantContractModeSelect({Key? key, required this.user, required this.merchantID,required this.pin}) : super(key: key);

  int contractType = 0;
  int creatorType = 0;
  String merchantID;
  final User user;
  final String pin;

  @override
  State<MerchantContractModeSelect> createState() => _MerchantContractModeSelectState();
}

class _MerchantContractModeSelectState extends State<MerchantContractModeSelect> {
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
            decoration: ContainerBackgroundDecoration(),
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
                      'What type of template are you creating',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height:20),
                GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => MerchantCreateProduct(
                                      user: widget.user, pin: widget.pin, merchantID: widget.merchantID)));
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
                            Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => MerchantCreateService(
                                      user: widget.user, pin: widget.pin, merchantID: widget.merchantID)));
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
                    
                      // InkWell(
                      // onTap: () {
                      //         showDialog(context: context, builder: (context) {
                      //           return AlertDialog(
                      //             title: const Text('Not Available yet.'),
                      //             actions: [
                      //               TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                      //             ],
                      //             content: const Text('This Feature would be available in Public release V2.0'),
                      //           );
                      //         });
                      // },
                      //   child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,children:[
                          
                      //     Icon(
                      //       showInvestment ? Icons.landscape: 
                      //       Icons.landscape_outlined, size: 35, color: Colors.teal),
                      //     const SizedBox(height:10),
                      //     const Text('Investment',
                      //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                      //     )
                      //   ],),
                      // ),
                      InkWell(
                      onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => MerchantCreateLoan(
                                      user: widget.user, pin: widget.pin, merchantID: widget.merchantID)));
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
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
                    //           showDialog(context: context, builder: (context) {
                    //             return AlertDialog(
                    //               title: const Text('Not Available yet.'),
                    //               actions: [
                    //                 TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                    //               ],
                    //               content: const Text('This Feature would be available in Public release V2.0'),
                    //             );
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
                    //         showDialog(context: context, builder: (context) {
                    //             return AlertDialog(
                    //               title: const Text('Not Available yet.'),
                    //               actions: [
                    //                 TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                    //               ],
                    //               content: const Text('This Feature would be available in Public release V2.0'),
                    //             );
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
                    //         showDialog(context: context, builder: (context) {
                    //             return AlertDialog(
                    //               title: const Text('Not Available yet.'),
                    //               actions: [
                    //                 TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                    //               ],
                    //               content: const Text('This Feature would be available in Public release V2.0'),
                    //             );
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
                    //   InkWell(
                    //   onTap: () {
                    //      showDialog(context: context, builder: (context) {
                    //             return AlertDialog(
                    //               title: const Text('Not Available yet.'),
                    //               actions: [
                    //                 TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                    //               ],
                    //               content: const Text('This Feature would be available in Public release V2.0'),
                    //             );
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
                        child: Column(children:const [
                          Icon(Icons.person_pin_circle_rounded, size: 35, color: Colors.red),
                          SizedBox(height:10),
                          Text('Buyer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => MerchantCreateProduct(
                                      user: widget.user, pin: widget.pin, merchantID: widget.merchantID)));
                            },
                        child: Column(children:const [
                          Icon(Icons.delivery_dining_rounded, size: 35, color: Colors.red),
                          SizedBox(height:10),
                          Text('Seller',
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
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.person, size: 35, color: Colors.blue),
                          SizedBox(height:10),
                          Text('Company',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.account_circle, size: 35, color: Colors.blue),
                          SizedBox(height:10),
                          Text('Pensioneer',
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
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.person, size: 35, color: Colors.teal),
                          SizedBox(height:10),
                          Text('Business',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.account_circle, size: 35, color: Colors.teal),
                          SizedBox(height:10),
                          Text('Investor',
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
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.person, size: 35, color: Colors.purpleAccent),
                          SizedBox(height:10),
                          Text('Parastatal',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.account_circle, size: 35, color: Colors.purpleAccent),
                          SizedBox(height:10),
                          Text('Contractor',
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.person, size: 35, color: Colors.red),
                          SizedBox(height:10),
                          Text('Borrower',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.account_circle, size: 35, color: Colors.red),
                          SizedBox(height:10),
                          Text('Lender',
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
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.person, size: 35, color: Colors.indigo),
                          SizedBox(height:10),
                          Text('Employee',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                       onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.account_circle, size: 35, color: Colors.indigo),
                          SizedBox(height:10),
                          Text('Employer',
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
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.person, size: 35, color: Colors.blue),
                          SizedBox(height:10),
                          Text('Insurer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.account_circle, size: 35, color: Colors.blue),
                          SizedBox(height:10),
                          Text('Insured',
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
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.person, size: 35, color: Colors.red),
                          SizedBox(height:10),
                          Text('Owner',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          
                          )
                        ],),
                      ),
                      InkWell(
                        onTap: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Not Available yet.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Okay'))
                                  ],
                                  content: const Text('This Feature would be available in Public release V2.0'),
                                );
                              });
                            },
                        child: Column(children:const [
                          Icon(Icons.account_circle, size: 35, color: Colors.red),
                          SizedBox(height:10),
                          Text('Buyer',
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
                        child: Column(children:const [
                          Icon(Icons.boy_rounded, size: 35, color: Colors.teal),
                          SizedBox(height:10),
                          Text('Provider',
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
                        child: Column(children:const [
                          Icon(Icons.hail_outlined, size: 35, color: Colors.teal),
                          SizedBox(height:10),
                          Text('Client',
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
                children: const [
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
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                            minVerticalPadding: 0,
                              title: Text(item.headerValue, style: const TextStyle(fontSize: 15)),
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


class MerchantMerchantContractModeSelect extends StatefulWidget {
  MerchantMerchantContractModeSelect({Key? key, required this.user, required this.merchantID,required this.pin}) : super(key: key);

  int contractType = 0;
  int creatorType = 0;
  String merchantID;
  final User user;
  final String pin;

  @override
  State<MerchantMerchantContractModeSelect> createState() => _MerchantMerchantContractModeSelectState();
}

class _MerchantMerchantContractModeSelectState extends State<MerchantMerchantContractModeSelect> {
  bool showService = false;
  bool showProduct = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 40),
        child: Column(children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height:30),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'What type of template are you creating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height:30),

          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    UtilityButtonO(
                        url: 'assets/paint-roller.png',
                        text: 'Service',
                        onTap: () {
                          print(widget.contractType);
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MerchantCreateService(user:widget.user, pin: widget.pin, merchantID: widget.merchantID)));
                          });
                        }),
                    Visibility(
                      visible: showService,
                      child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    UtilityButtonO(
                        url: 'assets/shopping-bag.png',
                        text: 'Product',
                        onTap: () {
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => MerchantCreateProduct(
                                merchantID: widget.merchantID, user: widget.user, pin: widget.pin)));
                          });
                        }),
                    Visibility(
                      visible: showProduct,
                      child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ],
            ),
          ),
          
        ]));
  }
}
