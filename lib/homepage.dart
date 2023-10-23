import 'package:flutter/material.dart';
import 'camera_overlay.dart';
import 'capture_image_then_scan/capture_image_then_scan.dart';
import 'crop_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CaptureThenScan()));
                  },
                  child: const Text("Capture Then Scan"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen()));
                  },
                  child: const Text("Camera Overlay"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CropImage()));
                  },
                  child: const Text("Crop Capture Then Scan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
