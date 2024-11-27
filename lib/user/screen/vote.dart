import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../assets/global/global.dart';
import '../../assets/global/global_variable.dart';

class VoteBallot extends StatefulWidget {
  const VoteBallot({super.key});

  @override
  State<VoteBallot> createState() => _VoteBallotState();
}

class _VoteBallotState extends State<VoteBallot> {
  String userID = '123432';
  // Store the positions fetched from the server
  List<Map<String, dynamic>> positions = [];

  // Store the selected candidates for each position
  Map<String, List<String?>> selectedCandidates = {};

  @override
  void initState() {
    super.initState();
    fetchCandidatesForVote();
  }

  // Fetch candidates data from the server
  Future<void> fetchCandidatesForVote() async {
    try {
      var response = await http.post(fetchCandidateForVote);

      if (response.statusCode == 200) {
        // Parse the response body
        var responseData = json.decode(response.body);

        if (responseData is Map && responseData.containsKey('error')) {
          // Handle the case where no data was found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['error'])),
          );
          return; // Stop further processing
        }

        if (responseData is List) {
          setState(() {
            positions = responseData.map((positionData) {
              return {
                "positionTitle": positionData['positionTitle'],
                "maxVotes": positionData['maxVotes'],
                "candidates": positionData['candidates']
              };
            }).toList();

            // Initialize selectedCandidates with empty values
            for (var position in positions) {
              selectedCandidates[position['positionTitle']] =
              List<String?>.filled(position['maxVotes'], null);
            }
          });
        } else {
          // Handle unexpected data structure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unexpected data format received.")),
          );
        }
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch data. Please try again later.")),
        );
      }
    } catch (error) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching candidates: $error")),
      );
    }
  }


  Future<void> _SubmitVote(String userID, Map<String, List<String?>> selectedCandidates) async {
    try {
      // Flatten the selected candidates into a list of maps
      List<Map<String, String>> votes = [];
      selectedCandidates.forEach((positionTitle, candidates) {
        for (var candidate in candidates) {
          if (candidate != null) {
            votes.add({
              "position": positionTitle,
              "candidate": candidate, // Include all selected candidates
            });
          }
        }
      });

      // Construct the request payload
      var payload = {
        "userID": userID,
        "votes": votes,
      };

      print(payload);

      var response = await http.post(submitVote,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Vote submitted successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Note : ${responseBody['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Failed to submit vote. Try again later.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: Container(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              adminEmail ?? 'No Email Provided',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: ClipOval(
                child: const Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: positions.isEmpty
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator while fetching data
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Loop through positions dynamically
                      for (var position in positions)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select ${position['positionTitle']} Candidate",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Generate dynamic dropdowns based on maxVotes
                              for (int i = 0;
                                  i < position['maxVotes'];
                                  i++) ...[
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  value: selectedCandidates[
                                      position['positionTitle']]?[i],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCandidates[
                                              position['positionTitle']]?[i] =
                                          newValue;
                                    });
                                  },
                                  items: position['candidates']
                                      .map<DropdownMenuItem<String>>(
                                          (candidate) {
                                    return DropdownMenuItem<String>(
                                      value:
                                          candidate['candidateID'].toString(),
                                      child: Text(
                                        candidate['candidateName'],
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                if (i < position['maxVotes'] - 1)
                                  const SizedBox(
                                      height: 10), // Space between dropdowns
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                print(userID);

                // Flatten all selected candidates into a list
                List<String?> allSelectedCandidates = [];
                selectedCandidates.forEach((positionTitle, candidates) {
                  for (var candidate in candidates) {
                    if (candidate != null) {
                      allSelectedCandidates.add(candidate);
                    }
                  }
                });

                // Check for duplicates
                var duplicates = allSelectedCandidates
                    .where((candidate) =>
                        allSelectedCandidates
                            .where((c) => c == candidate)
                            .length >
                        1)
                    .toSet();

                if (duplicates.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Error: The following candidates are selected more than once. Please select only once.",
                      ),
                    ),
                  );
                } else {
                  _SubmitVote(userID, selectedCandidates);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Vote',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
