import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as https;
import '../../admin/admin_entry_point.dart';
import '../../admin/screen/adminDashboard.dart';
import '../../assets/global/global.dart';
import 'Qr_Overlay.dart';
import 'authentication.dart';

class QRScanner extends StatefulWidget {
  final bool isForLogin;

  const QRScanner({super.key, required this.isForLogin});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  void initState() {
    _screenWasClosed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          "QR Scanner",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: _foundBarCode,
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
        ],
      ),
    );
  }

  void _foundBarCode(Barcode barcode, MobileScannerArguments? args) async {
    if (!_screenOpened) {
      final String code = barcode.rawValue ?? "";
      _screenOpened = true;

      if (widget.isForLogin) {
        // Call image capture for face recognition
        // QR_Face login_QR_Face = new QR_Face();
        //
        // login_QR_Face.Login_QR_Face(context, code);

        Navigator.pop(context, code);

        print(code);
      } else {
        Navigator.pop(context, code); // Return the scanned code
      }
    }

  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
