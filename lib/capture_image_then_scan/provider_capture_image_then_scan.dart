import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class CaptureImageThenScanProvider extends ChangeNotifier {
  var selectedImagePath = '';
  var extractedBarcode = '';

  getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      selectedImagePath = pickedFile.path;
      notifyListeners();
    } else {
      debugPrint("Error 1");
    }
  }

  ///recognise image text method
  Future<void> recognizedText(String pickedImage) async {
    if (pickedImage == null) {
      debugPrint("Error 2");
    } else {
      extractedBarcode = '';
      notifyListeners();
      var barCodeScanner = GoogleMlKit.vision.barcodeScanner();
      final visionImage = InputImage.fromFilePath(pickedImage);
      try {
        var barcodeText = await barCodeScanner.processImage(visionImage);

        for (Barcode barcode in barcodeText) {
          extractedBarcode = barcode.displayValue!;
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error 3");
      }
    }
  }
}
