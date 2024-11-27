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

  final VoidCallback onScanComplete;

  const QRScanner({super.key, required this.isForLogin, required this.onScanComplete});

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

        _imgFromCamera(code);

        print(code);
      } else {
        Navigator.pop(context, code); // Return the scanned code
      }
    }

  }

  final picker = ImagePicker();

  Future<void> _imgFromCamera(code) async {
    try {

      print("Starting image capture for verification...");

      // Capture image from the camera
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

      if (pickedFile != null) {
        // Send the captured image to the server
        final request = https.MultipartRequest('POST', Facial_Recognition);
        request.files.add(await https.MultipartFile.fromPath('image', pickedFile.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final decodedResponse = json.decode(responseBody);

          final imageName = decodedResponse['message'];

          if (imageName == code) {
            // If the image name matches the scanned QR code, proceed to login
            QR_Face login_QR_Face = QR_Face();
            login_QR_Face.Login_QR_Face(context, imageName);
          } else {
            // Display error if the image doesn't match
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('The Uploaded Image Is Not Face, Please Upload Again!')),
            );
          }
        } else {
          // Handle authentication failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Failed, Please Try Again!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No image captured.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error capturing image from camera: $e")),
      );
    } finally {
      widget.onScanComplete(); // Call the callback here
    }
  }




  void _screenWasClosed() {
    _screenOpened = false;
  }
}
