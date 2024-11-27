import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/user/Service/addCandidate.dart';
import 'dart:convert';

import '../../../admin/services/fetchPositions.dart';
import '../../../assets/global/global.dart';
import '../../../global/model/my_position.dart';
import '../../classes/userClass.dart';


import 'alert.dart';

class ApplicationFormPage extends StatefulWidget {
  @override
  _ApplicationFormPageState createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  final TextEditingController platformController = TextEditingController();
  final TextEditingController selectedPosition = TextEditingController();
  List<String> positionList = [];

  String Selected = '';

  @override
  void initState() {
    super.initState();
    // Fetch positions when the widget is initialized
    fetchPositions(
      (fetchedPositions) {
        setState(() {
          positionList = fetchedPositions
              .map((position) => position.positionTitle)
              .toList();
          print(
              "Position Titles List: $positionList"); // Print position titles list
        });
      },
      (errorMessage) {
        print("Error Callback: $errorMessage"); // Print any error messages
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Candidate Application"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown for selecting position
            positionList.isEmpty
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
              value: Selected.isNotEmpty ? Selected : null,
              items: positionList.map((position) {
                return DropdownMenuItem(
                  value: position,
                  child: Text(position),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  Selected = newValue ?? ''; // Update selected position
                  selectedPosition.text = Selected;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Select Position',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            // TextField for inputting platform/missions
            TextField(
              controller: platformController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Enter your platform/missions",
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            // Submit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the page without saving
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    String platformText = platformController.text;

                    if (Selected.isNotEmpty && platformText.isNotEmpty) {

                      // Call addCandidates with the selected position and platform
                      addCandidates(context, Selected, platformText);

                      platformController.clear();
                      setState(() {
                        Selected = '';
                      });

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please complete the form")),
                      );
                    }
                  },
                  child: Text('Submit Application'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
