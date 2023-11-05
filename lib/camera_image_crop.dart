import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CameraImageCrop extends StatefulWidget {
  const CameraImageCrop({super.key});

  @override
  CameraImageCropState createState() => CameraImageCropState();
}

class CameraImageCropState extends State<CameraImageCrop> {
  File? pickedIimage;

  Future<void> takePicture() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Decode the image using the image package
      final imageBytes = img.decodeImage(imageFile.readAsBytesSync())!;

      // Calculate the crop parameters
      var cropSize = imageBytes.width > imageBytes.height ? imageBytes.height : imageBytes.width;
      int offsetX = (imageBytes.width - cropSize) ~/ -80;
      int offsetY = (imageBytes.height - cropSize) ~/ 20;

      // Get the documents directory for saving the cropped image
      final directory = await getApplicationDocumentsDirectory();
      final croppedFilePath = '${directory.path}/cropped_image.png';

      // Crop the image
      img.Image croppedImage = img.copyCrop(
        imageBytes,
        x: offsetX,
        y: offsetY,
        width: cropSize,
        height: cropSize,
      );

      File croppedFile = File(croppedFilePath);
      croppedFile.writeAsBytesSync(img.encodePng(croppedImage));

      setState(() {
        pickedIimage = croppedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Image Crop'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pickedIimage != null) Image.file(pickedIimage!) else const Text('No image selected'),
            ElevatedButton(
              onPressed: takePicture,
              child: const Text('Take Picture and Crop'),
            ),
          ],
        ),
      ),
    );
  }
}
