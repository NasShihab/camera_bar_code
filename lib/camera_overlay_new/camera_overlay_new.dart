import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_overlay_new/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay_new/model.dart';
import 'package:image_cropper/image_cropper.dart';

class CameraOverLayNew extends StatefulWidget {
  const CameraOverLayNew({super.key});

  @override
  State<CameraOverLayNew> createState() => _CameraOverLayNewState();
}

class _CameraOverLayNewState extends State<CameraOverLayNew> {
  late List<CameraDescription> cameras;

  Future<void> initializeCameras() async {
    // await Permission.camera.request();
    cameras = await availableCameras();
    setState(() {}); // Refresh the widget tree after obtaining cameras
  }

  @override
  void initState() {
    initializeCameras();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CameraOverlay(
        cameras.first,
        CardOverlay.byFormat(
          OverlayFormat.cardID2,
        ),
        (XFile file) async {
          print(file.path);

          String imagePath = '';
          if (file.path != null) {
            CroppedFile? cropped = await ImageCropper().cropImage(sourcePath: file.path, aspectRatioPresets: [
              // CropAspectRatioPreset.square,
              // CropAspectRatioPreset.ratio3x2,
              // CropAspectRatioPreset.original,
              // CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
              // CropAspectRatioPreset.ratio5x3,
              // CropAspectRatioPreset.ratio7x5,
            ], uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Crop',
                  cropGridColor: Colors.black,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              IOSUiSettings(title: 'Crop')
            ]);

            if (cropped != null) {
              setState(() {
                imagePath = cropped.path;
                // selectedImagePath = cropped.path;
              });
            }
          }

          Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayCameraOverLayNew(imagePath: imagePath)));
        },
        label: 'Capturing ID Card',
        infoMargin: EdgeInsets.symmetric(horizontal: 15),
      ),
    );
  }
}

class DisplayCameraOverLayNew extends StatelessWidget {
  const DisplayCameraOverLayNew({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.file(
              File(imagePath),
              height: 250,
              width: 300,
            ),
          ],
        ),
      ),
    );
  }
}
