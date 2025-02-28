import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voting_system/assets/widget/button.dart';
import 'package:voting_system/assets/widget/text_field.dart';
import 'package:voting_system/login/Services/authentication.dart';
import 'package:voting_system/login/sign-up.dart';
import 'package:http/http.dart' as http;
import 'package:voting_system/user/components/Bottom_Sheets/announcement.dart';
import 'package:voting_system/user/components/Bottom_Sheets/application_form.dart';
import 'package:voting_system/user/components/Bottom_Sheets/result.dart';
import 'package:voting_system/user/components/Bottom_Sheets/setServer.dart';

import '../assets/global/global.dart';
import 'Services/qr_scanner.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // for Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Authentication auth = Authentication();

  bool isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              // Wrap the content with SingleChildScrollView
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: height / 2.7,
                    child: Image.asset("lib/assets/images/vote.jpg"),
                  ),
                  TextFieldInput(
                      textEditingController: emailController,
                      hintText: "Enter Your Email",
                      icon: Icons.email),
                  TextFieldInput(
                    textEditingController: passwordController,
                    hintText: "Enter Your Password",
                    icon: Icons.lock,
                    isPass: true, // Hides the text as the user types
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                  MyButton(
                    onTab: () {
                      auth.login(context, emailController, passwordController);
                    },
                    text: "Log in",
                  ),
                  SizedBox(height: height / 100),
                  const Text(
                    "Or Sign In With",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: height / 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final scannedId = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRScanner(
                                isForLogin: true,
                              ),
                            ),
                          );
                          if (scannedId != null) {
                            setState(() {
                              isLoading = true;
                            });
                            _imgFromCamera(scannedId);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Image.asset(
                          "lib/assets/icons/qr-code.png",
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: (BuildContext context) {
                        return SetServer();
                      });

                      // QuickAlert.show(
                      //     context: context,
                      //     type: QuickAlertType.success,
                      //     text: "Transaction Completed Successfully");
                    },
                    child: Text(
                      "Set Ipaddress",
                      style: TextStyle(
                        color: Colors
                            .blue, // Optional: change text color to indicate it's clickable
                        decoration: TextDecoration
                            .underline, // Optional: underline text
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();

  Future<void> _imgFromCamera(code) async {
    try {
      print("Starting image capture for verification...");

      // Capture image from the camera
      final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

      if (pickedFile != null) {
        // Send the captured image to the server
        final request = http.MultipartRequest('POST', Facial_Recognition);
        request.files
            .add(await http.MultipartFile.fromPath('image', pickedFile.path));

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
              SnackBar(
                  content: Text(
                      'The Uploaded Image Is Not Face, Please Upload Again!')),
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
    }
  }
}
