import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:voting_system/admin/components/qr_overlay.dart';

class Qr_Scanner extends StatefulWidget {
  const Qr_Scanner({super.key});

  @override
  State<Qr_Scanner> createState() => _Qr_ScannerState();
}

class _Qr_ScannerState extends State<Qr_Scanner> {

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
          "Scanner",
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
          QrOverlay(overlayColour: Colors.black.withOpacity(0.5))
        ],
      ),
    );
  }

  void _foundBarCode(Barcode barcode, MobileScannerArguments? args) async {
    if (!_screenOpened) {
      _screenOpened = true;
      final String code = barcode.rawValue ?? "";

      // Return scanned code back to the previous screen
      Navigator.pop(context, code);
    }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
