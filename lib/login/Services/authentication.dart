import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/admin/screen/adminDashboard.dart';
import 'package:voting_system/assets/global/global.dart';
import 'package:http/http.dart' as https;
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus
import 'package:voting_system/user/classes/userClass.dart';
import 'package:voting_system/user/screen/userDashboard.dart';
import 'package:voting_system/user/user_entry_point.dart';
import 'dart:io'; // Import dart:io for SocketException
import '../../admin/admin_entry_point.dart';
import '../../assets/global/global_variable.dart';
import '../../global/widgets/checker.dart';


class Authentication {
  // Function to handle login
  Future<void> login(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please input data in the textfield!")),
      );
      return;
    }

    Timer? timer = await Checker.checkConnectivityAndShowLoader(context);

    if (timer == null) return;

    try {
      var response = await https.post(LoginUrl, body: {
        'email': emailController.text,
        'pass': passwordController.text,
        'action': 'LoginEmail',
      });

      // Cancel the timer when a response is received
      timer.cancel();

      // Close the loading dialog once the response is received
      Navigator.pop(context);

      var data = json.decode(response.body);
      if (data['statusCode'] == '200' && response.body.isNotEmpty) {
        if (data['status'] == "success(admin)") {
          adminID = data['admin_ID'];
          adminEmail = data['email'];
          adminProfile = data['profile'];
          total_users = data['total_users'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminEntryPoint(
                initialScreen: const adminHomeScreen(),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login failed: ${data['msg']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: Please Check Server Address")),
        );
      }
    } catch (e) {
      // Handle network or URI error
      Navigator.pop(context); // Close loading dialog if an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server is down or invalid Server: $e")),
      );
      print("Error: $e");
    }
  }
}

class QR_Face {
  Future<void> Login_QR_Face(
    BuildContext context,
    String userID,
  ) async {
    if (userID.isEmpty || userID == '404') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Authentication Please Try Again!'),
      ));
    } else {
      try {
        final response =
        await https.post(Login_QR_FACE, body: {'userID': userID});

        var data = json.decode(response.body);
        if (data['statusCode'] == '200') {

          UserData().setuserID(data['userID']);
          UserData().setUsername(data['name']);
          UserData().setCourse(data['course']);
          UserData().setYearLevel(data['yearLevel']);
          UserData().setuserEmail(data['email']);
          UserData().setIsVoted(data['isVoted']);
          UserData().setuserProfile(data['profile']);


          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserEntryPoint(
                initialScreen: userHomeScreen(),
              ),
            ),
          );


        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Server error: Please Check Server Address")),
          );
        }
      }
      catch (e) {
        // Handle network or URI error
        Navigator.pop(context); // Close loading dialog if an error occurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server is down or invalid Server: $e")),
        );
        print("Error: $e");
      }
    }
  }


}
