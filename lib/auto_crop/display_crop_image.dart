import 'dart:io';

import 'package:flutter/material.dart';

class ViewImageScreen extends StatelessWidget {
  final File imageFile;

  const ViewImageScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Image'),
      ),
      body: Center(
        child: Image.file(
          imageFile,
          width: 200, // Adjust width as needed
          height: 200, // Adjust height as needed
        ),
      ),
    );
  }
}
