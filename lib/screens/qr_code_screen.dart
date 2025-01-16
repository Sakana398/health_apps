import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class QRCodeScreen extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const QRCodeScreen({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    String qrData = jsonEncode(userInfo); // Convert user info to JSON

    return Scaffold(
      appBar: AppBar(title: Text('User QR Code')),
      body: Center(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        )
      ),
    );
  }
}
