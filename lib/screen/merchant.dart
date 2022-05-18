import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';
import 'package:braketpay/screen/merchanttemplateproduct.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../api_callers/merchant.dart';
import '../uix/contractmodeselect.dart';
import '../uix/listitemseparated.dart';
import 'merchanttemplateservice.dart';

class Merchant extends StatefulWidget {
  Merchant({Key? key, required this.user, required this.pin}) : super(key: key);

  final User user;
  final String pin;
  @override
  State<Merchant> createState() => _MerchantState();
}

class _MerchantState extends State<Merchant> {
  final _formKey = GlobalKey<FormState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  // String _errorMessage = '';
  String bizName = '';
  String merchantName = 'Merchant';
  late String merchantID;
  String bizLoc = '';
  String website = '';
  // late Map merchant;
  List _templates = [];
  String email = '';
  String password = '';
  bool hasMerchant = false;
  bool hasTemplate = false;
  bool hasProduct = false;
  bool hasService = false;
  late Future<Map> merchant = getMerchant(
    widget.user.payload!.walletAddress ?? '',
    widget.pin,
  );
  late Future<Map> templates = fetchMerchantContract('', '', merchantID,
      widget.user.payload!.walletAddress ?? '', widget.pin, 'all');

  void refreshPage() {
    print('HI Refe');
    _refreshKey.currentState!.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 5,
          toolbarHeight: 65,
          leading: Container(),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
          ],
          title: Text(merchantName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        floatingActionButton: hasMerchant ? Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrange),
          child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.add),
              onPressed: () {
                contractMode();
              }),
        ) : Container(),
        body: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20), bottom: Radius.zero),
              color: Colors.white,
            ),
            child: RefreshIndicator(
              key: _refreshKey,
                onRefresh: () async {
                  final _merchant = await getMerchant(
                    widget.user.payload!.walletAddress ?? '',
                    widget.pin,
                  );
                  final _templates = await fetchMerchantContract(
                      '',
                      '',
                      '',
                      widget.user.payload!.walletAddress ?? '',
                      widget.pin,
                      'all');

                  setState(() {
                    merchant = Future.value(_merchant);
                    templates = Future.value(_templates);
                  });
                  // if (merchant.containsKey('Status')) {
                  //   if (merchant['Status'] == 'successful') {
                  //     setState(() {
                  //       merchant = merchant['Payload'];
                  //       hasMerchant = true;
                  //     });
                  //     Map templates = await fetchMerchantContract(
                  //       '',
                  //       '',
                  //         merchant['merchant_id'],
                  //         widget.user.payload!.walletAddress ?? '',
                  //         widget.pin,
                  //         'all');
                  //     if (templates.containsKey('Product')) {
                  //       print(templates['Service'].length);
                  //       if (templates['Product'].length != 0) {
                  //         hasProduct = true;
                  //       }
                  //       if (templates['Service'].length != 0) {
                  //         hasService = true;
                  //       }
                  //       if (hasProduct || hasService) {
                  //         setState(() {
                  //           hasTemplate = true;
                  //           final ___templates = templates['Product'];
                  //           ___templates.addAll(templates['Service']);
                  //           _templates = ___templates;
                  //           // _templates.addAll(templates['Service']);
                  //           _templates.forEach((e) => log(e.toString()));
                  //           print(_templates);
                  //         });
                  //       }
                  //     }
                  //   }
                  // }
                  // setState(() {
                  //   _transactions = Future.value(transactions);
                  // });
                },
                child: ListView(
                  children: [
                    SingleChildScrollView(
                        child: FutureBuilder<Map>(
                            future: merchant,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      {
                                        return Container(
                                          margin: EdgeInsets.all(20),
                                            decoration: const BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                      bottom: Radius.zero),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                                child: Text(
                                                    "Please wait...")));
                                      }
                                    case ConnectionState.done:
                                      {
                              if (snapshot.hasData && snapshot.data.containsKey('Status')) {
                                print(snapshot.data);
                                if (snapshot.data.containsKey('Status') &&
                                    snapshot.data['Status'] == 'successful') {
                                  merchantID =
                                      snapshot.data['Payload']['merchant_id'];
                                      hasMerchant = true;

                                  return Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 3,
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 0),
                                                  )
                                                ]),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Text(
                                                  'Business Detail',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                ListItemSeparated(
                                                    text:
                                                        snapshot.data['Payload']
                                                            ['merchant_id'],
                                                    title: 'Business ID'),
                                                ListItemSeparated(
                                                    text:
                                                        snapshot.data['Payload']
                                                            ['business_email'],
                                                    title: 'Business Email'),
                                                ListItemSeparated(
                                                    text: snapshot
                                                            .data['Payload']
                                                        ['business_location'],
                                                    title: 'Business Website',
                                                    isLast: true),
                                              ],
                                            )),
                                        SizedBox(height: 20),

                                        Container(
                                            width: double.infinity,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Your saved templates',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        FutureBuilder(
                                          future: templates,
                                          builder: (BuildContext context,
                                              AsyncSnapshot template_snapshot) {
                                            if (template_snapshot.hasData &&
                                                template_snapshot.data
                                                    .containsKey('Product')) {
                                              final _dummytemplates = [];
                                              _dummytemplates.addAll(
                                                  template_snapshot
                                                      .data['Product']);
                                              _dummytemplates.addAll(
                                                  template_snapshot
                                                      .data['Service']);
                                              // print("${_templates.length}, 99999999999999999999 ${template_snapshot.data['Product'].length}");
                                              if (template_snapshot.data
                                                      .containsKey('Product') &&
                                                  _dummytemplates.isNotEmpty) {
                                                _templates = _dummytemplates;
                                                return GridView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          mainAxisExtent: 220),
                                                  itemCount: _templates.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    List<int> image;
                                                    try {
                                                      List<dynamic> ld = jsonDecode(
                                                          utf8.decode(hex.decode(
                                                              _templates[index][
                                                                      'Payload']
                                                                  [
                                                                  'product_picture'])));
                                                      image = ld
                                                          .map((s) => s as int)
                                                          .toList();
                                                    } catch (e) {
                                                      List<dynamic> ld = jsonDecode(
                                                          utf8.decode(hex.decode(
                                                              _templates[index][
                                                                      'Payload']
                                                                  [
                                                                  'service_picture'])));
                                                      image = ld
                                                          .map((s) => s as int)
                                                          .toList();
                                                    }
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => _templates[index]
                                                                            [
                                                                            'Payload']
                                                                        [
                                                                        'contract_type'] ==
                                                                    'product'
                                                                ? MerchantProductDetail(
                                                                    product:
                                                                        _templates[
                                                                            index])
                                                                : MerchantServiceDetail(
                                                                    product:
                                                                        _templates[
                                                                            index]['Payload'])));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    spreadRadius:
                                                                        3,
                                                                    blurRadius:
                                                                        10,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            0),
                                                                  )
                                                                ]),
                                                            child: Column(
                                                              children: [
                                                                Text(_templates[index]
                                                                            [
                                                                            'Payload']
                                                                        [
                                                                        'contract_type']
                                                                    .toUpperCase()),
                                                                SizedBox(
                                                                    height: 5),
                                                                Container(
                                                                  clipBehavior:
                                                                      Clip.antiAliasWithSaveLayer,
                                                                  decoration: BoxDecoration(
                                                                  color: Colors.black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  child: Image.memory(Uint8List.fromList(image)),
                                                                  height: 130,
                                                                  width: 130,
                                                                ),
                                                                Text(
                                                                    !_templates[index]['Payload'].containsKey(
                                                                            'about_service_delivery_stages')
                                                                        ? _templates[index]['Payload']['product_name']
                                                                            .toUpperCase()
                                                                        : _templates[index]['Payload']['contract_title']?.toUpperCase() ??
                                                                            '',
                                                                    maxLines: 2,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                                Text(
                                                                    !_templates[index]['Payload'].containsKey(
                                                                            'about_service_delivery_stages')
                                                                        ? formatAmount(_templates[index]['Payload']['product_amount']
                                                                            .toString())
                                                                        : '',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            '')),
                                                              ],
                                                            )),
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                return Container(
                                                    margin: EdgeInsets.all(40),
                                                    child: Center(
                                                        child: Text(
                                                            'You have not created any template.')));
                                              }
                                            } else {
                                              return Center(
                                                  child:
                                                      Container(
                                                        margin: EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(20),
                                                        bottom: Radius.zero),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                  child: Column(
                                                    
                                                    children: [
                                                      Image.asset('assets/sammy-no-connection.gif'),
                                                      Text(
                                                          "No internet access\nCoudn't Load Contract Templates!",
                                                          textAlign: TextAlign.center
                                                          
                                                          ),
                                                    ],
                                                  ))));
                                            }
                                          },
                                        )
                                        // :
                                      ]));
                                } else {
                                  hasMerchant = false;

                                  return Form(
                                    key: _formKey,
                                    child: Container(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Create a Merchant account',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                                color: Colors.grey,
                                                height: 1,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20)),
                                            Text(
                                              'With a Merchant account, you can create and reuse contract templates to share with your customers.',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(height: 20),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: Text(
                                                      'Business Name*',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    cursorColor: Colors.black,
                                                    decoration:
                                                        const InputDecoration(
                                                      fillColor: Color.fromARGB(
                                                          24, 158, 158, 158),
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      hintText: 'Ex King store',
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                    ),
                                                    onChanged: (text) {
                                                      bizName = text.trim();
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Business name is required';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            'Business Email*',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .emailAddress,
                                                          cursorColor:
                                                              Colors.black,
                                                          decoration:
                                                              const InputDecoration(
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    24,
                                                                    158,
                                                                    158,
                                                                    158),
                                                            filled: true,
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            10))),
                                                            hintText:
                                                                'Ex king@store.com',
                                                            border: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            10))),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
                                                          ),
                                                          onChanged: (text) {
                                                            email = text.trim();
                                                          },
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Business email is required';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 120,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: Text(
                                                          'Location*',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .streetAddress,
                                                        cursorColor:
                                                            Colors.black,
                                                        decoration:
                                                            const InputDecoration(
                                                          fillColor:
                                                              Color.fromARGB(
                                                                  24,
                                                                  158,
                                                                  158,
                                                                  158),
                                                          filled: true,
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          10))),
                                                          hintText: 'Ex Epe',
                                                          border: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          10))),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                        ),
                                                        onChanged: (text) {
                                                          bizLoc = text.trim();
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Business Location is required';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: Text(
                                                      'Business Website',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.url,

                                                    cursorColor: Colors.black,
                                                    decoration:
                                                        const InputDecoration(
                                                      fillColor: Color.fromARGB(
                                                          24, 158, 158, 158),
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      hintText:
                                                          'Ex www.mybusiness.com',
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                    ),
                                                    onChanged: (text) {
                                                      website = text.trim();
                                                    },
                                                    // validator: (value) {
                                                    //   if (value == null || value.isEmpty) {
                                                    //     return 'Business name is required';
                                                    //   }
                                                    //   return null;
                                                    // },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: RoundedLoadingButton(
                                                  borderRadius: 10,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  elevation: 0,
                                                  controller:
                                                      _loginButtonController,
                                                  onPressed: () async {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      // print('$username, $pin, $password');
                                                      Map a = await createMerchant(
                                                          website,
                                                          email,
                                                          widget.user.payload!
                                                                  .password ??
                                                              '',
                                                          bizName,
                                                          widget.user.payload!
                                                                  .accountNumber ??
                                                              '',
                                                          widget.pin,
                                                          bizLoc);

                                                      if (a.containsKey(
                                                          'Payload')) {
                                                        _loginButtonController
                                                            .success();
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                  actions: [
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'Okay'),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        final _merchant =
                                                                            await getMerchant(
                                                                          widget.user.payload!.walletAddress ??
                                                                              '',
                                                                          widget
                                                                              .pin,
                                                                        );

                                                                        final _templates = await fetchMerchantContract(
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            widget.user.payload!.walletAddress ??
                                                                                '',
                                                                            widget.pin,
                                                                            'all');

                                                                        setState(
                                                                            () {
                                                                          merchant =
                                                                              Future.value(_merchant);
                                                                          templates =
                                                                              Future.value(_templates);
                                                                        });
                                                                      },
                                                                    )
                                                                  ],
                                                                  title: const Text(
                                                                      "Success!"),
                                                                  content:
                                                                      const Text(
                                                                          'Your Merchant account was created successfully, you can now create contract templates.'));
                                                            });
                                                      } else {
                                                        _loginButtonController
                                                            .reset();
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                  actions: [
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'Okay'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        // Navigator.of(context).pop();
                                                                        // Navigator.of(context).pop();
                                                                      },
                                                                    )
                                                                  ],
                                                                  title: const Text(
                                                                      "Can't create Merchant Account!\nPull down to refresh"),
                                                                  content: Text(
                                                                      a['Message']));
                                                            });
                                                      }
                                                    } else {
                                                      _loginButtonController
                                                          .reset();
                                                    }
                                                  },
                                                  child: const Text('Create')),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else{
                                          return Container(
                                            margin: EdgeInsets.all(30),
                                              decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(20),
                                                        bottom: Radius.zero),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                  child: Column(
                                                    children: [
                                                      Image.asset('assets/sammy-no-connection.gif'),
                                                      Text(
                                                          "No internet access"),
                                                      SizedBox(height:10),
                                                      RoundButton(
                                                        text: 'Retry',
                                                        color1: Colors.black,
                                                        color2: Colors.black,
                                                        onTap: () {
                                                          _refreshKey.currentState!.show();
                                                        }
                                                        
                                                      )
                                                    ],
                                                  )));
                                        }
                                        
                                      }}
  })),
                  ],
                ))));
  }

  Future<dynamic> contractMode() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (context) {
          return MerchantContractModeSelect(
              user: widget.user, pin: widget.pin, merchantID: merchantID);
        });
  }
  //       // child:
}
