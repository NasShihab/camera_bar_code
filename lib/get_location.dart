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

  void fetchLocation() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      });
    } else {
      setState(() {
        locationMessage = 'Permission denied to access location';
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
