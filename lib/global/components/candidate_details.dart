import 'dart:convert'; // Import for base64 decoding
import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/material.dart';
import 'package:voting_system/admin/screen/application.dart';
import 'package:voting_system/global/model/my_candidates.dart';
import 'package:http/http.dart' as http;

import '../../admin/admin_entry_point.dart';
import '../../assets/global/global.dart';


class DetailsScreen extends StatefulWidget {
  final Candidate candidate;
  final bool showRemoveButton;

  const DetailsScreen({super.key, required this.candidate, this.showRemoveButton = true});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // Convert Base64 image string to Uint8List
    Uint8List imageBytes = base64Decode(
        widget.candidate.image.split(',').last); // Remove data URL prefix if present

    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidate Information"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 36,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade100,
                ),
                child: Image.memory(
                  imageBytes, // Use Image.memory to display Base64 image
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 36,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: 400,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.candidate.userID.toUpperCase(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.candidate.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.candidate.position.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.candidate.section.toUpperCase(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  widget.candidate.motto,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: widget.showRemoveButton // Conditional rendering
          ? BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space between buttons
          children: [
            GestureDetector(
              onTap: () => _showAcceptDialog(widget.candidate.userID),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.4, // Button width
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: _showRejectDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.4, // Button width
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Reject',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      )
          : null, // No bottom sheet if showAcceptRejectButtons is false
    );
  }

  void _showAcceptDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50, // Increased size for better visibility
              ),
              const SizedBox(height: 10), // Space between icon and text
              const Text(
                'Confirm Acceptance',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Styling for the title
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to accept this candidate?',
            textAlign: TextAlign.center, // Center the warning statement
            style: TextStyle(fontSize: 16), // Optionally adjust font size for clarity
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                // Add your accept action
                _AcceptCandidate(widget.candidate.userID);
              },
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 50, // Increased size for better visibility
              ),
              const SizedBox(height: 10), // Space between icon and text
              const Text(
                'Confirm Rejection',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Styling for the title
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to reject this candidate?',
            textAlign: TextAlign.center, // Center the warning statement
            style: TextStyle(fontSize: 16), // Optionally adjust font size for clarity
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Reject'),
              onPressed: () {
                // Add your reject action here
                _rejectCandidate(widget.candidate.userID);
              },
            ),
          ],
        );
      },
    );
  }

  _AcceptCandidate(String userID) async {
    try {
      var response = await http.post(AcceptCandidate, body: {
        'userID': userID,
      });

      // Check the statusCode from the response body
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['statusCode'] == 200) { // Check the statusCode from PHP response
          // Show Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['msg']), // Displaying the message from the PHP response
              duration: Duration(seconds: 2),
            ),
          );

          // Pop the current screen to go back to AdminCandidateList
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminEntryPoint(
                initialScreen: CandidateApplication(), // Pass the initial screen here
              ),
            ),
          );// Pass true to indicate a refresh is needed
        } else {
          // Handle other status codes from the PHP response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['msg']),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        print("Failed to load candidates, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching candidates: $error");
    }
  }

  _rejectCandidate(String userID) async {
    try {
      var response = await http.post(RejectCandidate, body: {
        'userID': userID,
      });

      // Check the statusCode from the response body
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['statusCode'] == 200) { // Check the statusCode from PHP response
          // Show Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['msg']), // Displaying the message from the PHP response
              duration: Duration(seconds: 2),
            ),
          );

          // Pop the current screen to go back to AdminCandidateList
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminEntryPoint(
                initialScreen: CandidateApplication(), // Pass the initial screen here
              ),
            ),
          );// Pass true to indicate a refresh is needed
        } else {
          // Handle other status codes from the PHP response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['msg']),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        print("Failed to load candidates, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching candidates: $error");
    }
  }



}
