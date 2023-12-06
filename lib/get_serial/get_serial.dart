import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unique_identifier/unique_identifier.dart';

class GetSerial extends StatefulWidget {
  const GetSerial({super.key});

  @override
  State<GetSerial> createState() => _GetSerialState();
}

class _GetSerialState extends State<GetSerial> {
  String _identifier = 'Unknowsn';

  @override
  void initState() {
    super.initState();
    initUniqueIdentifierState();
  }

  Future<void> initUniqueIdentifierState() async {
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Text('on device with id: $_identifier\n'),
      ),
    );
  }
}
