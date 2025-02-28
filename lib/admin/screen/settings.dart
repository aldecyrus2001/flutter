import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/admin/components/appBar.dart';
import '../../assets/global/global.dart';
import '../../global/model/my_position.dart';
import '../services/fetchPositions.dart';
import 'package:http/http.dart' as https;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<Position> positions = [];
  Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    fetchPositions(
      (fetchedPositions) {
        setState(() {
          positions = fetchedPositions;

          // Initialize controllers for each position
          for (var position in positions) {
            _controllers[position.positionID] = TextEditingController(
              text: position.maxCandidate.toString(),
            );
          }
        });
      },
      (errorMessage) {
        print(errorMessage);
      },
    );
  }

  void _increment(String positionID) {
    setState(() {
      int currentValue = int.parse(_controllers[positionID]!.text);
      currentValue++;
      _controllers[positionID]!.text = currentValue.toString();
    });
  }

  void _decrement(String positionID) {
    setState(() {
      int currentValue = int.parse(_controllers[positionID]!.text);
      if (currentValue > 0) {
        currentValue--;
      }
      _controllers[positionID]!.text = currentValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AdminAppBar(),
      body: positions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: positions.length,
                      itemBuilder: (context, index) {
                        var position = positions[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  position.positionTitle,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    iconSize: 15.0,
                                    onPressed: () =>
                                        _decrement(position.positionID),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: TextField(
                                      controller: _controllers[position
                                          .positionID], // Bind controller
                                      textAlign: TextAlign.center,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: TextStyle(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    iconSize: 15.0,
                                    onPressed: () =>
                                        _increment(position.positionID),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Convert the map to a JSON string for sending to the server
                        Map<String, String> positionData = {};
                        _controllers.forEach((positionID, controller) {
                          positionData[positionID.toString()] = controller.text;
                        });

                        // Directly use positionData as the value of 'positions'
                        Map<String, dynamic> requestBody = {
                          'positions':
                              positionData, // Correct structure: positions contains the map directly
                        };

                        String jsonData = jsonEncode(
                            requestBody); // Encode the entire body as JSON

                        if (jsonData.isNotEmpty) {
                          saveSettings(
                              requestBody); // Pass the map directly, no need to re-encode here
                        } else {
                          print('No data to send');
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> saveSettings(Map<String, dynamic> data) async {
    try {
      // Send the POST request with the position data
      var response = await https.post(
        UpdateMaxCount,
        body: jsonEncode(
            data), // Send the request body as JSON with positions directly
        headers: {
          'Content-Type': 'application/json', // Ensure it's sent as JSON
        },
      );

      print(data); // Print the request body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Check if the response status is OK
      if (response.statusCode == 200) {
        try {
          // Attempt to parse the response body as JSON
          var responseData = jsonDecode(response.body);

          // Check the "success" field to confirm if the update was successful
          if (responseData['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Settings updated successfully")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to update settings")),
            );
          }
        } catch (e) {
          // Handle the case where the response is not valid JSON
          print("Error decoding JSON: $e");
          print("Response body was: ${response.body}");
        }
      } else {
        // Handle if the server responded with an error
        print('Server error: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error sending data: $e');
    }
  }
}
