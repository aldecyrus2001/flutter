import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voting_system/assets/global/global_variable.dart';
import 'package:voting_system/global/model/my_voters.dart';

import '../../assets/global/global.dart';
import '../../global/components/dialog_information.dart';
import '../../global/components/dropdownlist.dart';
import '../../login/Services/qr_scanner.dart';
import '../components/appBar.dart';
import '../components/qr_scanner.dart';
import '../services/addVoters.dart'; // Import your VoterService

import 'package:http/http.dart' as http;

import '../subscreens/addVoters.dart';

class VotersList extends StatefulWidget {
  const VotersList({super.key});

  @override
  State<VotersList> createState() => _VotersListState();
}

class _VotersListState extends State<VotersList> {



  double width = 0;
  bool myAnimation = false;
  List<Voter> voters = []; // List to hold the fetched voters
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      setState(() {
        myAnimation = true;
      });
    });
    fetchVoters();
  }

  Future<void> fetchVoters() async {
    try {
      VoterService voterService = VoterService();
      List<Voter> fetchedVoters = await voterService.fetchVoters();
      setState(() {
        voters = fetchedVoters; // Set the fetched voters
        isLoading = false; // Update loading state
      });
    } catch (e) {
      print('Error fetching voters: $e');
      setState(() {
        isLoading = false; // Update loading state even if there's an error
      });
    }
  }

  get base64Image => adminProfile;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AdminAppBar(),
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator()) // Show loading indicator
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Voter's List",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: voters.length,
                      itemBuilder: (context, index) {
                        final myVoter = voters[index];
                        return GestureDetector(
                          onTap: () {
                            _showUserDetails(
                                myVoter.userID); // Call the method when tapped
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              duration:
                                  Duration(milliseconds: 300 + (index * 250)),
                              curve: Curves.decelerate,
                              transform: Matrix4.translationValues(
                                myAnimation ? 0 : width,
                                0,
                                0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: myVoter.image.isNotEmpty
                                          ? MemoryImage(base64Decode(
                                              myVoter.image.split(',').last))
                                          : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          myVoter.userID,
                                          style: TextStyle(
                                              fontSize: myVoter.userID.length > 18 ? 12 : 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                        Text(
                                          myVoter.name,
                                          style: TextStyle(
                                            fontSize: myVoter.name.length > 18 ? 14 : 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(myVoter.section),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
          Positioned(
            bottom: 80,
            right: 10,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.add, size: 30, color: Colors.white),
                onPressed: () {
                  // Navigate to addVotersScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const addVotersScreen()), // Replace with your actual screen widget
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showUserDetails(String userId) async {
    try {
      // Construct the URL with the userID as a query parameter
      final response = await http.post(
        ShowUser, body: {'userID': userId}, // Send userID in the body
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if data is not null and contains the user details
        if (data['data'] != null && data['data'].isNotEmpty) {
          final userDetails = data['data'][0]; // Get the first user details

          showUserDetailsDialog(context, userDetails, fetchVoters);
        } else {
          print('No user found with the given ID.');
        }
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
}
