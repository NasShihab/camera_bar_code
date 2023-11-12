import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CropImage extends StatefulWidget {
  const CropImage({Key? key}) : super(key: key);

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  File? imageFile;
  var selectedImagePath = '';
  var extractedBarcode = '';

  Future pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
        selectedImagePath = pickedImage.path;
      });
    }
  }

  Future cropImage() async {
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(sourcePath: imageFile!.path, aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9,
        // CropAspectRatioPreset.ratio5x3,
        // CropAspectRatioPreset.ratio7x5,
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop',
            cropGridColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Crop')
      ]);

      if (cropped != null) {
        setState(() {
          imageFile = File(cropped.path);
          selectedImagePath = cropped.path;
        });
      }
    }
  }

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

  void clearImage() {
    setState(() {
      imageFile = null;
      extractedBarcode = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black, title: const Text("Crop Your Image")),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: imageFile != null
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.file(imageFile!))
                  : const Center(
                      child: Text("Add a picture"),
                    ),
            ),
            extractedBarcode.isEmpty
                ? const Text("No data found in barcode")
                : Text(
                    extractedBarcode,
                    textAlign: TextAlign.center,
                  ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIconButton(icon: Icons.add, onPressed: pickImage),
                    _buildIconButton(icon: Icons.crop, onPressed: cropImage),
                    _buildIconButton(icon: Icons.clear, onPressed: clearImage),
                    _buildIconButton(
                        icon: Icons.qr_code,
                        onPressed: () {
                          recognizedText(selectedImagePath);
                        }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildIconButton({required IconData icon, required void Function()? onPressed}) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: Colors.white,
        ));
  }
}
