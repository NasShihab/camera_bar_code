import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GetLocationAddress extends StatefulWidget {
  const GetLocationAddress({super.key});

  @override
  State<GetLocationAddress> createState() => _GetLocationAddressState();
}

class _GetLocationAddressState extends State<GetLocationAddress> {
  String locationMessage = '';
  //
  // void fetchLocation1() async {
  //   // Check and request location permissions
  //   var status = await Permission.location.status;
  //   if (status.isDenied) {
  //     await Permission.location.request();
  //   }
  //
  //   if (status.isGranted) {
  //     fetchLocation();
  //   } else {
  //     fetchLocation();
  //   }
  // }

  void fetchLocation() async {
    // Check and request location permissions
    var status = await Permission.location.status;
    if (status.isDenied) {
      final bool isPermanentlyDenied = await openAppSettings(); // Open app settings if permission is permanently denied.
      if (isPermanentlyDenied) {
        setState(() {
          locationMessage = 'Location permissions are permanently denied. Please enable them in your device settings.';
        });
      } else {
        setState(() {
          locationMessage = 'Location permissions are denied. Please enable them to use this feature.';
        });
      }
    } else if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
      ),
      body: Center(
        child: Text(locationMessage),
      ),
    );
  }
}
