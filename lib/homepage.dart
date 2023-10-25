import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      debugPrint('Device Name: ${androidInfo.device}');
      debugPrint('Model: ${androidInfo.model}');
      debugPrint('System Version: ${androidInfo.version.release}');
      debugPrint('serialNumber: ${androidInfo.serialNumber}');
      debugPrint('hardware: ${androidInfo.hardware}');
      debugPrint('id: ${androidInfo.id}');
      debugPrint('isPhysicalDevice?: ${androidInfo.isPhysicalDevice}');
      debugPrint('host: ${androidInfo.host}');
      debugPrint('brand: ${androidInfo.brand}');
      debugPrint('product: ${androidInfo.product}');

      debugPrint(DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()));
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      debugPrint('Device Name: ${iosInfo.name}');
      debugPrint('Model: ${iosInfo.utsname.machine}');
      debugPrint('System Version: ${iosInfo.systemVersion}');
    }
  }

  Future<AndroidDeviceInfo> getDeviceInfo2() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo;
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
                    Row(
                      children: <Widget>[
                        const Text(
                          'IP Address:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          ipAddress,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Device Name:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.device,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Model:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.model,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'System Version:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.version.release,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Serial Number:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.serialNumber,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Hardware:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.hardware,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'ID:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.id,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Is Physical Device:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '${widget.androidInfo.isPhysicalDevice}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Host:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.host,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Brand:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.brand,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Product:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.product,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Display:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          widget.androidInfo.display,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Device Time:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }
}
