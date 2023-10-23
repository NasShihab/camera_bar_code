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

  Future<void> _captureCard() async {
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
                const Center(child: Text('দয়াকরে কার্ডটি ফ্রেমের ভিতরে রাখুন', style: TextStyle(fontSize: 16, color: Colors.yellow),textAlign: TextAlign.center,)),
                const SizedBox(height: 20,),
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
