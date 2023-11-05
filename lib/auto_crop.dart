import 'dart:io';

import 'package:camera_bar_code/auto_crop/display_crop_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AutoCrop extends StatefulWidget {
  const AutoCrop({super.key});

  @override
  AutoCropState createState() => AutoCropState();
}

class AutoCropState extends State<AutoCrop> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _croppedImage; // Store the cropped image file

  Future<void> _captureAutoCropAndDisplayImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (croppedImage != null) {
        _displayCroppedImage(File(croppedImage.path));
      }
    }
  }

  void _displayCroppedImage(File croppedImage) {
    setState(() {
      _croppedImage = croppedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture, Auto Crop, and Display Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _captureAutoCropAndDisplayImage,
              child: const Text('Capture, Auto Crop, and Display Image'),
            ),
            const SizedBox(height: 20),
            if (_croppedImage != null)
              Image.file(
                _croppedImage!,
              ),
          ],
        ),
      ),
    );
  }
}
