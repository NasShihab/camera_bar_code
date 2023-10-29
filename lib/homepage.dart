import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'camera_overlay.dart';
import 'capture_image_then_scan/capture_image_then_scan.dart';
import 'crop_image.dart';
import 'get_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  Future<AndroidDeviceInfo> getDeviceInfo2() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationPermission();
  }

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
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // getDeviceInfo();
                    AndroidDeviceInfo androidInfo;
                    BuildContext currentContext = context;
                    getDeviceInfo2().then((androidInfo) {
                      androidInfo = androidInfo;
                      Navigator.push(
                        currentContext, // Use the captured context
                        MaterialPageRoute(
                          builder: (context) => SecondClass(androidInfo: androidInfo),
                        ),
                      );
                      debugPrint(androidInfo.host);
                    });
                  },
                  child: const Text("Device Info"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GetLocationAddress()));
                  },
                  child: const Text("Get Location"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondClass extends StatefulWidget {
  final AndroidDeviceInfo androidInfo;

  const SecondClass({super.key, required this.androidInfo});

  @override
  State<SecondClass> createState() => _SecondClassState();
}

class _SecondClassState extends State<SecondClass> {
  String ipAddress = '';

  Future<void> getIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          if (address.type == InternetAddressType.IPv4 && !address.address.startsWith('127.')) {
            setState(() {
              ipAddress = address.address;
            });
            return;
          }
        }
      }
    } catch (e) {
      print('Error fetching IP address: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getIpAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Info')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'IP Address: $ipAddress, \n'
                  'Device Name: ${widget.androidInfo.device}, \n'
                  'Model: ${widget.androidInfo.model}, \n'
                  'System Version: ${widget.androidInfo.version.release}, \n'
                  'Hardware: ${widget.androidInfo.hardware}, \n'
                  'ID: ${widget.androidInfo.id}, \n'
                  'Is Physical Device: ${widget.androidInfo.isPhysicalDevice}, \n'
                  'Host: ${widget.androidInfo.host}, \n'
                  'Brand: ${widget.androidInfo.brand}, \n'
                  'Product: ${widget.androidInfo.product}, \n'
                  'Display: ${widget.androidInfo.display}, \n'
                  'Device Time: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())}, ',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
