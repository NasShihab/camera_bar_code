import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_scan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _pickedImage;

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_pickedImage != null)
                Image.file(
                  _pickedImage!,
                ),
              Center(
                child: ElevatedButton(
                  onPressed: _pickImageFromCamera,
                  child: const Text("Pick Image from Camera"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("2nd"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const QQrCodeScanView()));
                  },
                  child: const Text("3rd"),
                ),

              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CaptureThenScan()));
                  },
                  child: const Text("CaptureThenScan"),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
