import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    return SizedBox(
      height: 200,
      width: 300,
      child: AspectRatio(
        aspectRatio: 16 / 9, // 3x1 aspect ratio
        child: CameraPreview(_cameraController),
      ),
    );
  }
}
