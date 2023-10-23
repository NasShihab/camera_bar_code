import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

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
    final image = img.decodeImage(await file.readAsBytes())!;

    const overlayWidth = 600;
    const overlayHeight = 400;
    final overlayX = (image.width - overlayWidth) ~/ 2;
    final overlayY = (image.height - overlayHeight) ~/ 2 + 80;

    final startX = overlayX.clamp(0, image.width - overlayWidth);
    final startY = overlayY.clamp(0, image.height - overlayHeight);

    final croppedImage = img.copyCrop(image, x: startX, y: startY, width: overlayWidth, height: overlayHeight);

    final croppedImagePath = imagePath.replaceFirst('.jpg', '_cropped.jpg');
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

  const DisplayCapturedImage({super.key, required this.imagePath});

  @override
  DisplayCapturedImageState createState() => DisplayCapturedImageState();
}

class DisplayCapturedImageState extends State<DisplayCapturedImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cropped Image'),
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
