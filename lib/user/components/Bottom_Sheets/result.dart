import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../assets/global/global.dart';
import '../../../login/login.dart';


class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}



class _ResultState extends State<Result> {

  Map<String, List<Map<String, dynamic>>> groupedResults = {};

  Future<void> fetchResults() async {
    try {
      final response = await http.get(fetchResult);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(response.body);
        List<dynamic> data = jsonResponse['data'];

        // Grouping candidates by positionTitle
        Map<String, List<Map<String, dynamic>>> tempGroupedResults = {};

        for (var item in data) {
          String positionTitle = item['positionTitle'];
          if (!tempGroupedResults.containsKey(positionTitle)) {
            tempGroupedResults[positionTitle] = [];
          }
          tempGroupedResults[positionTitle]!.add(item);
        }

        // Update the state with the grouped results
        setState(() {
          groupedResults = tempGroupedResults;
        });
      } else {
        // Handle any error in response
        print("Failed to fetch results, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching results: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchResults(); // Call fetchResults when the widget is initialized
  }


  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Voting Results'),
      content: Container(
        width: 400, // Set the desired width here
        height: 800, // Set the desired height here
        child: Align(
          alignment: Alignment.topLeft, // Align the content to the top left
          child: groupedResults.isEmpty
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
              : SingleChildScrollView( // Add scroll view to handle large content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var positionTitle in groupedResults.keys)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Position Title
                            Text(
                              positionTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // List of Candidates
                            ...groupedResults[positionTitle]!.map((candidate) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align text to both ends
                                  children: [
                                    Text(
                                      candidate['candidateName'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${candidate['totalVotes']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false, // This removes all previous routes
            );
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }

}
