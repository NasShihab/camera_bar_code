import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class CaptureThenScan extends StatefulWidget {
  const CaptureThenScan({super.key});

  @override
  State<CaptureThenScan> createState() => _CaptureThenScanState();
}

class _CaptureThenScanState extends State<CaptureThenScan> {
  var selectedImagePath = '';
  var extractedBarcode = '';

  getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        selectedImagePath = pickedFile.path;
      });
    } else {
      debugPrint("Error 1");
    }
  }

  ///recognise image text method
  Future<void> recognizedText(String pickedImage) async {
    if (pickedImage == null) {
      debugPrint("Error 2");
    } else {
      setState(() {
        extractedBarcode = '';
      });
      var barCodeScanner = GoogleMlKit.vision.barcodeScanner();
      final visionImage = InputImage.fromFilePath(pickedImage);
      try {
        var barcodeText = await barCodeScanner.processImage(visionImage);

        for (Barcode barcode in barcodeText) {
          setState(() {
            extractedBarcode = barcode.displayValue!;
          });
        }
      } catch (e) {
        debugPrint("Error 3");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImagePath == ''
                ? const Center(child: Text("Select an image from Gallery / camera"))
                : Image.file(
                    File(selectedImagePath),
                    height: 400,
                    width: 200,
                  ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: const Text('Pick Image'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        child: const Text('Camera Capture'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        recognizedText(selectedImagePath);
                      },
                      child: const Text('Scan')),
                ),
              ],
            ),
            SizedBox(height: 30),
            extractedBarcode.isEmpty ? Text("No data found in barcode") : Text(extractedBarcode)
          ],
        ),
      )),
    );
  }
}
