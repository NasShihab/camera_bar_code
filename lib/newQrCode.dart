import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late ScanController _controller;
  String _barcodeResult = '';

  @override
  void initState() {
    super.initState();

    _controller = ScanController();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      String? barcodeResult = await Scan.parse(image.path);

      setState(() {
        _barcodeResult = barcodeResult!;
      });
      Future.delayed(const Duration(milliseconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(
              barcode: _barcodeResult,
              imagePath: image.path,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scan Barcode'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScanView(controller: _controller),
                Text(_barcodeResult),
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text('Pick Image'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key, required this.barcode, required this.imagePath}) : super(key: key);
  final String barcode;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(barcode),
              SizedBox(height: 20),
              Image.file(File(imagePath)), // Display the image
            ],
          ),
        ),
      ),
    );
  }
}
