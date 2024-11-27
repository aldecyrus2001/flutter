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
            SingleChildScrollView(  // Wrap the content with SingleChildScrollView
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
                    isPass: true,  // Hides the text as the user types
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
                                onScanComplete: _onScanComplete, // Pass callback here
                              ),
                            ),
                          );

                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Image.asset(
                          "lib/assets/icons/qr-code.png",
                          width: 50,
                          height: 50,
                        ),
                      ),
                      // const SizedBox(width: 20),
                      // GestureDetector(
                      //   onTap: () async {
                      //     if (Platform.isAndroid) {
                      //       PermissionStatus cameraPermission = await Permission.camera.request();
                      //
                      //       if (cameraPermission.isGranted) {
                      //         _imgFromCamera();
                      //       }
                      //       else {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(
                      //               content: Text("Camera permission denied")),
                      //         );
                      //       }
                      //     }
                      //   },
                      //   child: Image.asset(
                      //     "lib/assets/icons/electronics.png",
                      //     width: 50,
                      //     height: 50,
                      //   ),
                      // ),
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
                    },
                    child: Text(
                      "Set Ipaddress",
                      style: TextStyle(
                        color: Colors.blue, // Optional: change text color to indicate it's clickable
                        decoration: TextDecoration.underline, // Optional: underline text
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




  void _onScanComplete() {
    setState(() {
      isLoading = false;  // Set loading state to false after scan is complete
    });
  }

}
