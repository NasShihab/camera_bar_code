import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class QQrCodeScanView extends StatefulWidget {
  const QQrCodeScanView({super.key});

  @override
  State<QQrCodeScanView> createState() => _QQrCodeScanViewState();
}

class _QQrCodeScanViewState extends State<QQrCodeScanView> {
  String scanValue = '';
  Future qrScanner() async {
    var camaraPermission = await Permission.camera.status;
    if (camaraPermission.isGranted) {
      String? qrCode = await scanner.scan();
      if (qrCode != null) {
        setState(() {
          scanValue = qrCode;
        });
        // getQrScanData(qrCode, 1);
      } else {}
    } else {
      var isGrandt = await Permission.camera.request();
      if (isGrandt.isGranted) {
        String? qrCode = await scanner.scan();
        if (qrCode != null) {
          setState(() {
            scanValue = qrCode;
          });
          // getQrScanData(qrCode, 1);
        } else {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(scanValue.toString()),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  qrScanner();
                },
                child: Text('QQ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
