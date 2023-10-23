import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;


class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  XFile? capturedImage;

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
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

  Future<void> _captureCard() async {
    try {
      final image = await controller!.takePicture();
      final croppedImage = await cropImage(image.path);
      setState(() {
        capturedImage = XFile(croppedImage);
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayCapturedImage(imagePath: croppedImage),
        ),
      );
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  Future<String> cropImage(String imagePath) async {
    final file = File(imagePath);
    final image = img.decodeImage(await file.readAsBytes())!; // Load the image using the image package
    const overlayWidth = 600; // Adjust based on your overlay size
    const overlayHeight = 400;
    // Define the exact dimensions and position of the overlay
    final overlayX = (image.width - overlayWidth) ~/ 2; // Adjust based on overlay position
    final overlayY = (image.height - overlayHeight) ~/ 2 +80; // Adjust based on overlay position
    // Adjust based on your overlay size

    // Ensure that the overlay stays within the image boundaries
    final startX = overlayX.clamp(0, image.width - overlayWidth);
    final startY = overlayY.clamp(0, image.height - overlayHeight);

    final croppedImage = img.copyCrop(image, x: startX, y: startY, width: overlayWidth, height: overlayHeight);

    final croppedImagePath = imagePath.replaceFirst('.jpg', '_cropped.jpg'); // Change the file name if needed
    File(croppedImagePath).writeAsBytesSync(img.encodeJpg(croppedImage));
    return croppedImagePath;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: <Widget>[
        CameraPreview(controller!),
        if (capturedImage == null)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 3.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    _captureCard();
                  },
                  child: const Icon(Icons.camera),
                ),
              ],
            ),
          )
        else
          const SizedBox.shrink()
          // Center(
          //   child: Image.file(
          //     File(capturedImage!.path),
          //     fit: BoxFit.cover,
          //   ),
          // ),
      ],
    );
  }
}

class DisplayCapturedImage extends StatefulWidget {
  final String imagePath;

  DisplayCapturedImage({required this.imagePath});

  @override
  _DisplayCapturedImageState createState() => _DisplayCapturedImageState();
}

class _DisplayCapturedImageState extends State<DisplayCapturedImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cropped Image'),
      ),
      body: Center(
        child: Image.file(
          File(widget.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

