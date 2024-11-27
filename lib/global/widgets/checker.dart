// checker.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus

class Checker {
  // Method to check connectivity and show loading dialog
  static Future<Timer?> checkConnectivityAndShowLoader(BuildContext context) async {
    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No internet connection! Please check your connection.")),
      );
      return null; // Exit the function if there's no internet connection
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Create a timer to close the dialog after 60 seconds
    Timer? timer;
    timer = Timer(const Duration(minutes: 1), () {
      // Close the loading dialog
      Navigator.pop(context);
      // Show snackbar indicating server is unreachable
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The server is unreachable, please contact the administrator. Thank you!")),
      );
    });

    // Return the timer to allow the caller to cancel it if needed
    return timer;
  }
}
