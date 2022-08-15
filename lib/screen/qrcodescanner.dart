import 'dart:convert';
import 'dart:io';
import 'package:braketpay/screen/merchantcreateproduct.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../api_callers/merchant.dart';
import '../brakey.dart';
import '../classes/user.dart';
import 'merchantcreateservice.dart';

class QRScanner extends StatefulWidget {
  QRScanner({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Brakey brakey = Get.put(Brakey());
  @override
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildQrView(context),
          IconButton(
              onPressed: () {},
              icon: FloatingActionButton(
                  onPressed: () => Navigator.of(context).pop(context),
                  child: Icon(Icons.close, size: 30)))
          // Text('${result?.code}')
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).primaryColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    print('HI');
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      setState(() {
        result = scanData;
      });
      print(result!.code);
      try { 
        final Map data = jsonDecode(
            scanData.code.toString().replaceAll('"', '').replaceAll("'", '"'));
      if (data.containsKey('data_type')) {
        if (data['data_type'] == 'product_contract_data') {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                    title: const Text(
                      'Fetching contract from template',
                      textAlign: TextAlign.center,
                    ),
                    // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                    content: Row(children: const [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                      Text('Please wait....',
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]));
              });
          String mi = data['product_link'].split('/')[2];
          String pi = data['product_link'].split('/')[3];
          Map a = await fetchMerchantContract(
              pi,
              'product',
              mi,
              widget.user.payload!.walletAddress ?? '',
              widget.pin,
              'single',
              brakey.user.value?.payload?.password??'',
              
              );
          print(a);

          if (a.containsKey('Payload')) {
            a['Payload'].addEntries({'merchant_id':mi, 'product_id':pi}.entries);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => MerchantCreateProductFromScan(
                    product: a['Payload'], user: widget.user, pin: widget.pin))));
          } else {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (prompt) {
                  return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                      actions: [
                        TextButton(
                          child: const Text('Okay'),
                          onPressed: () {
                            Navigator.of(prompt).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            controller.resumeCamera();
                            // Navigator.of(context).pop();
                          },
                        )
                      ],
                      title: const Text("Can't fetch Template!"),
                      content: Text(a['Message']));
                });
          }
        } 
        else if (data['data_type'] == 'service_contract_data') {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                    title: const Text(
                      'Fetching contract from template',
                      textAlign: TextAlign.center,
                    ),
                    // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                    content: Row(children: const [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                      Text('Please wait....',
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]));
              });
          String mi = data['service_contract_link'].split('/')[2];
          String pi = data['service_contract_link'].split('/')[3];
          Map a = await fetchMerchantContract(
              pi,
              'service',
              mi,
              widget.user.payload!.walletAddress ?? '',
              widget.pin,
              'single',
              brakey.user.value?.payload?.password??'',
              
              );
          print(a);

          if (a.containsKey('Payload')) {
            a['Payload'].addEntries({'merchant_id':mi, 'service_id':pi}.entries);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => MerchantCreateServiceFromScan(
                    product: a['Payload'], user: widget.user, pin: widget.pin))));
          } else {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (prompt) {
                  return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                      actions: [
                        TextButton(
                          child: const Text('Okay'),
                          onPressed: () {
                            Navigator.of(prompt).pop();
                            Navigator.of(context).pop();
                            // Navigator.of(context).pop();
                            controller.resumeCamera();
                            // Navigator.of(context).pop();
                          },
                        )
                      ],
                      title: const Text("Can't fetch Template!"),
                      content: Text(a['Message']));
                });
          }
        }
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (prompt) {
            return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                actions: [
                  TextButton(
                    child: const Text('Okay'),
                    onPressed: () {
                      Navigator.of(prompt).pop();
                      controller.resumeCamera();
                      // Navigator.of(context).pop();
                    },
                  )
                ],
                title: const Text("Invalid QR code detected!"),
                content: Text('Please scan a valid Braket QRcode'));
                });
      }
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (prompt) {
            return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                actions: [
                  TextButton(
                    child: const Text('Okay'),
                    onPressed: () {
                      Navigator.of(prompt).pop();
                      Navigator.of(prompt).pop();
                      controller.resumeCamera();
                      // Navigator.of(context).pop();
                    },
                  )
                ],
                title: const Text("Invalid QR code detected!"),
                content: Text('Please scan a valid Braket QRcode'));
                });
      }
      // Navigator.of(context).push(

      // )
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
