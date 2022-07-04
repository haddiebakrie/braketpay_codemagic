import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:braketpay/api_callers/merchant.dart';
import 'package:convert/convert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/loan.dart';
import '../classes/user.dart';
import 'package:flutter/services.dart';

import '../ngstates.dart';
import '../uix/askpin.dart';
import '../uix/listitemseparated.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class MerchantCreateLoanFromScan extends StatefulWidget {
  const MerchantCreateLoanFromScan(
      {Key? key, required this.loan, required this.user, required this.pin})
      : super(key: key);

  final Map loan;
  final User user;
  final String pin;

  @override
  State<MerchantCreateLoanFromScan> createState() =>
      _MerchantCreateLoanFromScanState();
}

class _MerchantCreateLoanFromScanState extends State<MerchantCreateLoanFromScan> {
  double loanAmount = 0;
  late String nokName;
  late String nokNIN;
  late String useOfFunds;
  late String nokPhone;
  late String pOne;
  late String bvn;
  late String phone;
  late String pTwo;
  late String marital='';
  late String imageByte = '';
  late bool hasImage = false;
  late String address ='';
  late String paybackStatement ='';
  late String dependant ='';
  late String lga='';
  late String state='';
  late String employment='';
  late String eduLevel='';
  late String pThree;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  final TextEditingController _nokNINFieldController = TextEditingController();
  final TextEditingController _nokUseOfFundsFieldController = TextEditingController();
  final TextEditingController _nokPhoneFieldController = TextEditingController();
  final TextEditingController _shipDestFieldController =
      TextEditingController();
  String statementPDF= '';

  @override
  Widget build(BuildContext context) {
    _loginButtonController.reset();
    List<dynamic> ld =
        jsonDecode(utf8.decode(hex.decode(widget.loan['Payload']['loan_picture'])));
    List<int> image = ld.map((s) => s as int).toList();
    print(
        // decode(hex.decode(widget.loan['Payload']['Payload']['loan_picture']))
        (image.length));
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(elevation: 0),
        body: SingleChildScrollView(
          child: Container(
            decoration: ContainerBackgroundDecoration(),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: ContainerBackgroundDecoration(),child: Image.memory(Uint8List.fromList(image), height: 200,)),
                    Container(
                        decoration: ContainerDecoration(),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              widget.loan['Payload']['loan_title'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ListItemSeparated(
                                text: widget.loan['Payload']['merchant_name'],
                                title: 'Lender'),
                            ListItemSeparated(
                                text: 'LOAN CONTRACT',
                                title: 'Contract Type'),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal:20),
                          subtitle: Text(widget.loan['Payload']['loan_description']),
                          title: Text('Loan Description'),
                          
                        ),
                        Container(
              color:Colors.grey.withOpacity(.5),
              height: 1,
              width: double.infinity),
                            ListItemSeparated(
                                text: toTitleCase(widget.loan['Payload']['interest_rate'].toInt().toString()+'%'),
                                title: 'Interest Rate'),
                            ListItemSeparated(
                                text: toTitleCase(widget.loan['Payload']['loan_type']),
                                title: 'Loan Type'),
                            ListItemSeparated(
                                text: toTitleCase(widget.loan['Payload']['loan_period']),
                                title: 'Loan Peroid'),
                            ListItemSeparated(
                                text: formatAmount(widget.loan['Payload']['loan_amount_range']['min'].toString()),
                                title: 'Minimum Lending Amount'),
                            ListItemSeparated(
                                text: formatAmount(widget.loan['Payload']['loan_amount_range']['max'].toString()),
                                title: 'Maximum Lending Amount'),
                                ],
                              )),
                              // 72388217643
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: ContainerDecoration(),
                        child: Column(
                          children: [
                            Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                            const Text(
                              'Borrowing Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height:10),
                            Text('Please provide a detailed use of the money'),
                            const SizedBox(height:20),
                            
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Phase One',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. Buying of farm equipment\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                              onChanged: (text) {
                                pOne = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phase one detail is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                                           
                                            Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Phase Two',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. Paying Labourers\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                              onChanged: (text) {
                                pTwo = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phase two detail is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                                           Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Phase Three',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. Transporting farm product for sales\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                              onChanged: (text) {
                                pThree = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phase three detail is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                                 Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'How do you intend to payback',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Eg. Revenue from selling my farm products\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                              onChanged: (text) {
                                paybackStatement = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    widget.user.payload!.bvn!.toString().startsWith('2') ? 'NIN' : 'BVN',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 15),
                                  ),
                                ),    TextFormField(
                              maxLength: 11,
                              cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                hintMaxLines: 2,
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'XXXXXXXXXXX',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                bvn = text.trim();
                              },
                              validator: (value) {
                                if ( value == null || value.isEmpty || value.trim().length < 11) {
                                  return widget.user.payload!.bvn!.toString().startsWith('2') ? 'Invalid NIN' : 'Invalid BVN';
                                }
                                return null;
                              },
                            ),
                      
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Your Active Phone number',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 15),
                                  ),
                                ),    TextFormField(
                              maxLength: 11,
                              cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                hintMaxLines: 2,
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'XXXXXXXXXXX',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (text) {
                                phone = text.trim();
                              },
                              validator: (value) {
                                if ( value == null || value.isEmpty || value.trim().length < 11) {
                                  return widget.user.payload!.bvn!.toString().startsWith('2') ? 'Invalid NIN' : 'Invalid BVN';
                                }
                                return null;
                              },
                            ),
                      
                        ],
                      ),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Marital Status',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 15),
                                  ),
                                ), 
                          Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    margin: EdgeInsets.symmetric(vertical:10),

                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    // margin: EdgeInsets.symmetric(vertical:10),
                                    child: DropdownSearch<dynamic>(
                                        onChanged:(e) {
                                          marital = e;
                                        },
                                      dropdownSearchDecoration: InputDecoration(
                                        hintText: 'Select State',
                                        border: InputBorder.none,
                                        // filled: true,
                                      ),
                                      // showSearchBox: true,
                                      // showClearButton: true,
                                      mode: Mode.MENU,
                                      searchDelay: Duration.zero,
                                      items: ['Single', 'Married'],
                                      selectedItem: marital != '' ? marital : '--------'
                                    ),
                                  ),

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'How many people depend on your Income',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 15),
                                  ),
                                ),    TextFormField(
                              cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                hintMaxLines: 2,
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Eg. 3',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10,),
                              ),
                              onChanged: (text) {
                                dependant = text.trim();
                              },
                              validator: (value) {
                                if ( value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                      
                        ],
                      ),
                      SizedBox(height:15),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Education Level',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 15),
                                  ),
                                ), 
                          Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    margin: EdgeInsets.symmetric(vertical:10),
                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    // margin: EdgeInsets.symmetric(vertical:10),
                                    child: DropdownSearch<dynamic>(
                                        onChanged:(e) {
                                      setState(() {
                                          eduLevel = e;
                                          if (e == 'No Education') {
                                            eduLevel = 'None';
                                          }

                                      });
                                        },
                                      dropdownSearchDecoration: InputDecoration(
                                        hintText: 'Select Education Level',
                                        border: InputBorder.none,
                                        // filled: true,
                                      ),
                                      // showSearchBox: true,
                                      // showClearButton: true,
                                      mode: Mode.BOTTOM_SHEET,
                                      searchDelay: Duration.zero,
                                      items: ['No Education', 'Primary', 'Secondary', 'College of education', 'Polytechnique', 'University', 'Masters', 'PHD' ],
                                      selectedItem: eduLevel != '' ? eduLevel == 'None' ? 'No Education' : eduLevel : '--------'
                                    ),
                                  ),
                                  

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Employment Status',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 15),
                                  ),
                                ), 
                          Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    margin: EdgeInsets.symmetric(vertical:10),
                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    // margin: EdgeInsets.symmetric(vertical:10),
                                    child: DropdownSearch<dynamic>(
                                        onChanged:(e) {
                                          employment = e;
                                        },
                                      dropdownSearchDecoration: InputDecoration(
                                        hintText: 'Select Employment status',
                                        border: InputBorder.none,
                                        // filled: true,
                                      ),
                                      // showSearchBox: true,
                                      // showClearButton: true,
                                      mode: Mode.MENU,
                                      searchDelay: Duration.zero,
                                      items: ['Unemployed', 'Employed', 'Student', ],
                                      selectedItem: employment != '' ? employment : '--------'
                                    ),
                                  ),
                                  

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Bank Statement',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 15),
                                  ),
                                ), 
                          Container(
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    margin: EdgeInsets.symmetric(vertical:10),
                                    decoration: BoxDecoration(
                                    color: const Color.fromARGB(24, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    // margin: EdgeInsets.symmetric(vertical:10),
                                    child: TextButton(onPressed: () async {
                                      
                                      FilePickerResult? _image = await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf'],
                                      );
                                      if (_image == null) {
                                        return;
                                      }
                                      final _imageByte = await File(_image.paths.first ?? '').readAsBytes();
                                      print(_image.paths.first);
                                      setState(() {
                                        statementPDF = _image.names.first ?? '';
                                        imageByte = jsonEncode(_imageByte);
                                        hasImage = _image.paths.first == '' ? false : true;
                                        print(_imageByte);
                                        print(_imageByte.length);
                                      });
                                    }, child: 
                                    Row(
                                      children: [
                                    Icon(IconlyBold.paper_plus, ),
                                    SizedBox(width:10),
                                        Text(imageByte == '' ? 'Upload Bank statement' : statementPDF),
                                      ],
                                    ))
                                  ),
                          Text('Only PDF format is accepted', style: TextStyle(color: Colors.grey))
                                  

                        ],
                      ),
                      
                      
                      ])),
                      const SizedBox(height: 10),
                  const Text(
                    'Home address',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height:20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'State',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400, fontSize: 15),
                                    ),
                                  ), 
                            Container(
                                      padding: EdgeInsets.symmetric(horizontal:10),
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(24, 158, 158, 158),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      margin: EdgeInsets.symmetric(vertical:10),
                                      child: DropdownSearch<dynamic>(
                                          onChanged:(e) {
                                            setState(() {
                                            state = e;
                                            lga = '';
                                              
                                            });
                                          },
                                        dropdownSearchDecoration: InputDecoration(
                                          hintText: 'Select State',
                                          border: InputBorder.none,
                                          // filled: true,
                                        ),
                                        // showSearchBox: true,
                                        // showClearButton: true,
                                        mode: Mode.BOTTOM_SHEET,
                                        searchDelay: Duration.zero,
                                        items: ngStates.map((e) => e['name']).toList(),
                                        selectedItem: state != '' ? state : 'Select State'
                                      ),
                                    ),
                                    

                          ],
                        ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'LGA',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400, fontSize: 15),
                                    ),
                                  ), 
                            Container(
                                      padding: EdgeInsets.symmetric(horizontal:10),
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(24, 158, 158, 158),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      margin: EdgeInsets.symmetric(vertical:10),
                                      child: DropdownSearch<dynamic>(
                                          onChanged:(e) {
                                            setState(() {
                                            lga = e;
                                              
                                            });
                                          },
                                        dropdownSearchDecoration: InputDecoration(
                                          hintText: 'Select LGA',
                                          border: InputBorder.none,
                                          // filled: true,
                                        ),
                                        // showSearchBox: true,
                                        // showClearButton: true,
                                        mode: Mode.BOTTOM_SHEET,
                                        searchDelay: Duration.zero,
                                        items: state == '' ? [] : ngStates.where((element) => element['name'] == state).first['lgas'],
                                        selectedItem: lga != '' ? lga : 'Select LGA'
                                      ),
                                    ),
                                    Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Address',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),

                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              style: TextStyle(height: 1.5),
                              maxLines: null,
                              maxLength: 3000,
                              cursorColor: Colors.grey,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(24, 158, 158, 158),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText:
                                    'Your home address\n\n',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              onChanged: (text) {
                                address = text.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Home address is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                             

                          ],
                        ),
                      
                  const SizedBox(height: 10),
                  const Text(
                    'Next of Kin Details',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height:20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Next of KIN Name',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),
                          TextFormField(
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(24, 158, 158, 158),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: "Firstname Surname",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (text) {
                            nokName = text.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Next of Kin name is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Next of KIN NIN',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),
                          TextFormField(
                            controller: _nokNINFieldController,
                                maxLength: 11,
                                cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  hintMaxLines: 2,
                                  helperMaxLines: 2,
                                  errorMaxLines: 2,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: 'XXXXXXXXXXX',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (text) {
                                  nokNIN = text.trim();
                                },
                                validator: (value) {
                                  print(value);
                                  if ( value != null && value.isNotEmpty && value.trim().length < 11 || value!.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                              ),
                      ])),
                      Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Next of KIN Phone',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),
                          TextFormField(
                            controller: _nokPhoneFieldController,

                                cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  hintMaxLines: 2,
                                  helperMaxLines: 2,
                                  errorMaxLines: 2,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  hintText: '09012345678',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (text) {
                                  nokPhone = text.trim();
                                },
                                validator: (value) {
                                  print(value);
                                  if ( value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                              ),
                      ])),
                            
                            const SizedBox(height: 10),
                            const Text(
                              'Borrowing Amount',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height:20),
                            Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'You can borrow between\n ${formatAmount(widget.loan['Payload']['loan_amount_range']['min'].toString())} - ${formatAmount(widget.loan['Payload']['loan_amount_range']['max'].toString())}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),
                          TextFormField(
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                    // textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 60,
                                  ),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: InputDecoration(
                                    errorMaxLines: 2,
                                    icon: Text(nairaSign(), style:const TextStyle(fontSize: 40, color: Colors.grey)),
                                    prefixStyle: const TextStyle(color: Colors.grey),
                                    fillColor: const Color.fromARGB(24, 158, 158, 158),
                                    // filled: true,
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    hintText: '0.00',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey
                                    ),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    contentPadding: EdgeInsets.zero
                                  ),
                                  onChanged: (text) {
                                    loanAmount = text == '' ? 0 : double.parse(text.trim());
                                    // setState(() {                                    
                                    //   _priceTextController.text = price.toString();
                                    // });
                                  
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || 
                                    int.parse(value) < widget.loan['Payload']['loan_amount_range']['min'] || 
                                    int.parse(value) > widget.loan['Payload']['loan_amount_range']['max']
                                    ) {
                                      return 'The Loan amount must between the minimum and maximum amount';
                                    }
                                    return null;
                                  },
                                ),
                      ],
                    ),
                  ),
                  const SizedBox(height:30),

                            RoundedLoadingButton(
                                borderRadius: 10,
                                color: Theme.of(context).primaryColor,
                                elevation: 0,
                                controller: _loginButtonController,
                                child: const Text('Apply'),
                                onPressed: () async {
                                      
                              FocusManager.instance.primaryFocus?.unfocus();

                                  if (!_formKey.currentState!.validate()) {
                                    _loginButtonController.reset();
                                  } else {
                                    if (!hasImage) {
                            _loginButtonController.reset();
                            
                            showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
      
                                            },
                                          )
                                        ],
                                        title: const Text("Error"),
                                        content:  Text('Please upload Bank Statement!.'));
                                  });
                                      return;
                          }
                          if (lga == '') {
                            _loginButtonController.reset();
                            
                            showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
      
                                            },
                                          )
                                        ],
                                        title: const Text("Error"),
                                        content:  Text('Please Select your LGA!.'));
                                  });
                                      return;
                          }
                          if (marital=='') {
                            _loginButtonController.reset();
                            
                            showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
      
                                            },
                                          )
                                        ],
                                        title: const Text("Error"),
                                        content:  Text('Please select your Marital status!.'));
                                  });
                                      return;
                          }
                          if (eduLevel==''){
                            _loginButtonController.reset();
                            
                            showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                        actions: [
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
      
                                            },
                                          )
                                        ],
                                        title: const Text("Error"),
                                        content:  Text('Please select your Education Level!.'));
                                  });
                                      return;
                          }
                                    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                                  final _pinEditController = TextEditingController();
                                    Map? pin = await askPin(_pinEditController, _pinErrorController);
                                                          
                                    if (pin == null || !pin.containsKey('pin')) {
                                      return;
                                    };
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return AlertDialog(
                                  title: const Text(
                                    'Creating loan contract',
                                    textAlign: TextAlign.center,
                                  ),
                                  // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                                  content: Row(children: const [
                                    Padding(
                                      padding:  EdgeInsets.all(20.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                    Text('Please wait....', style: TextStyle(fontWeight: FontWeight.w500))
                                  ]));
                            });
                        _loginButtonController.reset();
                        print(widget.user.payload!.bvn);
                        Map a = await activateLoanContract(
                          widget.loan['Payload']['loan_id'],
                           widget.user.payload!.walletAddress ?? '',
                           pin['pin'],
                           bvn,
                           loanAmount.toString(),
                           {'phase_1':{'use_of_funds':pOne},'phase_2':{'use_of_funds':pTwo},'phase_3':{'use_of_funds':pThree}},
                           nokName,
                           nokNIN,
                           '234' + int.parse(nokPhone).toString(),
                           phone,
                           marital == 'Single',
                           eduLevel,
                           imageByte,
                           state,
                           lga,
                           address,
                           paybackStatement,
                           int.parse(dependant),
                           employment
                           );
                  
                  if (a.containsKey('Payload')) {
                          _loginButtonController.success();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                    actions: [
                                      TextButton(
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop(true);
                                        },
                                      )
                                    ],
                                    title: const Text("Contract created!"),
                                    content:  const Text('Your Loan Contract has been created.'));
                              });
                        } else {
                          _loginButtonController.reset();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                    actions: [
                                      TextButton(
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          // Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                    title: const Text("Can't activate Loan!"),
                                    content:  Text(toTitleCase(a['Message']??"")));
                              });

                        }
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
