import 'dart:io';
import 'package:camera_bar_code/capture_image_then_scan/provider_capture_image_then_scan.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CaptureThenScan extends StatefulWidget {
  const CaptureThenScan({super.key});

  @override
  State<CaptureThenScan> createState() => _CaptureThenScanState();
}

class _CaptureThenScanState extends State<CaptureThenScan> {


  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<CaptureImageThenScanProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            provider.selectedImagePath == ''
                ? const Center(child: Text("Select an image from Gallery / camera"))
                : Image.file(
                    File(provider.selectedImagePath),
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
                          provider.getImage(ImageSource.gallery);
                        },
                        child: const Text('Pick Image'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          provider.getImage(ImageSource.camera);
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
                        provider.recognizedText(provider.selectedImagePath);
                      },
                      child: const Text('Scan')),
                ),
              ],
            ),
            SizedBox(height: 30),
            provider.extractedBarcode.isEmpty ? Text("No data found in barcode") : Text(provider.extractedBarcode)
          ],
        ),
      )),
    );
  }
}
