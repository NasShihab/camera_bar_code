import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class BarCodeScan extends StatefulWidget {
  const BarCodeScan({super.key});

  @override
  State<BarCodeScan> createState() => _BarCodeScanState();
}

class _BarCodeScanState extends State<BarCodeScan> {
  String? scanValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (scanValue != null ) {
            }
            if (scanValue != null) {
              // convertData();

            } else {
              return QrCamera(
                qrCodeCallback: (value) {
                  try {
                    setState(() {
                      scanValue = value;
                    });
                    debugPrint("Call back try");
                  } catch (e) {
                    debugPrint("Call back catch");
                  }
                },
                onError: (context, error) {
                  return Center(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Something is wrong\nTry Again",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  );
                },
                formats: const [BarcodeFormats.PDF417],
                fit: BoxFit.cover,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.yellow.withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text("জাতীয় পরিচয়পত্রের পিছনের পৃষ্ঠার বারকোড স্ক্যান করুন",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        width: 1,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
