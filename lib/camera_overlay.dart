import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  XFile? capturedImage;

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh); // Adjust the resolution accordingly
    await controller!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> captureCard() async {
    try {
      final image = await controller!.takePicture();
      // final croppedImage = await cropImage(image.path);
      // setState(() {
      //   capturedImage = XFile(croppedImage);
      // });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DisplayCapturedImage(imagePath: image.path),
        ),
      );
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        CameraPreview(controller!),
        if (capturedImage == null)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                    child: Text(
                  'দয়াকরে কার্ডটি ফ্রেমের ভিতরে রাখুন',
                  style: TextStyle(fontSize: 16, color: Colors.yellow),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: screenSize.width * 0.90,
                  height: screenSize.height * 0.25,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 3.0,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                FloatingActionButton(
                  onPressed: () {
                    captureCard();
                  },
                  child: const Icon(Icons.camera),
                ),
              ],
            ),
          )
        else
          const SizedBox.shrink()
      ],
    );
  }
}

class DisplayCapturedImage extends StatefulWidget {
  final String imagePath;

  const DisplayCapturedImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  DisplayCapturedImageState createState() => DisplayCapturedImageState();
}

class DisplayCapturedImageState extends State<DisplayCapturedImage> {
  String extractedBarcode = '';

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
            // extractedBarcode = barcode.displayValue!;
            extractedBarcode += "${barcode.displayValue!}\n";
          });
        }
        // if (barcodeText.isEmpty) {
        //   debugPrint("No barcodes found in the image");
        // }
        // else {
        //   for (Barcode barcode in barcodeText) {
        //     if (barcode.displayValue != null && barcode.displayValue!.length == 26) {
        //       setState(() {
        //         extractedBarcode = barcode.displayValue!;
        //       });
        //     }
        //   }
        // }
      } catch (e) {
        debugPrint("Error");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recognizedText(widget.imagePath);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cropped Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.file(
              File(widget.imagePath),
              height: MediaQuery.of(context).size.height * .45,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
          extractedBarcode.isEmpty
              ? const Text("No data found in barcode")
              : Text(
                  extractedBarcode,
                  textAlign: TextAlign.center,
                ),
          ElevatedButton(
              onPressed: () {
                recognizedText(widget.imagePath);
              },
              child: Text("QR"))
        ],
      ),
    );
  }
}
