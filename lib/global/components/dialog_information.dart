import 'package:flutter/material.dart';
import 'dart:convert'; // Required for base64Decode
import 'package:qr_flutter/qr_flutter.dart';
import 'package:voting_system/admin/screen/voters_list.dart';

import '../../admin/admin_entry_point.dart';
import '../../assets/global/global.dart'; // Import the QR Flutter package
import 'package:http/http.dart' as http;

import '../../assets/global/global_variable.dart';


void showUserDetailsDialog(BuildContext context, Map<String, dynamic> userDetails, Function fetchVoters) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50, // Size of the circle
                backgroundImage: userDetails['image'].isNotEmpty
                    ? MemoryImage(base64Decode(userDetails['image'].split(',').last))
                    : null,
                child: userDetails['image'].isEmpty ? Icon(Icons.person, size: 50) : null, // Placeholder
              ),
              SizedBox(height: 10),
              Text(
                '${userDetails['firstName']} ${userDetails['lastName']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                '${userDetails['yearLevel']} - ${userDetails['course']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Age: ${userDetails['age']}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Email: ${userDetails['email']}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                'Vote Status: ${userDetails['isVoted'] == '0' ? 'None Voted' : 'Voted'}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              // Add the QR code image below the Vote Status
              QrImageView(
                data: userDetails['userID'], // The data to be encoded in the QR code
                version: QrVersions.auto,
                size: 100.0, // Set the size of the QR code
                gapless: false,
              ),
              Text(
                '${userDetails['userID']}',
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Close'),
                  ),
                  SizedBox(width: 16), // Add spacing between the buttons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Change background color to red
                    ),
                    onPressed: () {
                      _DeleteUser('${userDetails['userID']}', context, fetchVoters); // Pass fetchVoters as a callback

                    },
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

}

void _DeleteUser(String userID, BuildContext context, Function refreshVoters) async {
  final response = await http.post(
    DeleteUser, body: {'userID': userID}, // Send userID in the body
  );

  if (response.statusCode == 200) {
    Navigator.pop(
      context,
      MaterialPageRoute(
        builder: (context) => AdminEntryPoint(
          initialScreen: const VotersList(),
        ),
      ),
    );

    refreshVoters();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data Deleted successfully!")),
    );


  } else {
    refreshVoters();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to Delete data!")),
    );
  }
}
