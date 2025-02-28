import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/global/model/my_partylist.dart';
import 'package:voting_system/user/Service/addCandidate.dart';
import 'dart:convert';

import '../../../admin/services/fetchPositions.dart';


import 'alert.dart';

class ApplicationFormPage extends StatefulWidget {
  @override
  _ApplicationFormPageState createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  String selectedPartylist = '';
  List<PartyList> partyLists = [];
  bool isLoading = true;
  bool showPlatformTextField = false;
  bool showPartyListController = true;

  final TextEditingController platformController = TextEditingController();
  final TextEditingController selectedPosition = TextEditingController();
  final TextEditingController partylistController = TextEditingController();
  List<String> positionList = [];

  String Selected = '';

  @override
  void initState() {
    super.initState();
    fetchPosition();
    fetchPartyListData();
  }

  void fetchPosition() {
    fetchPositions(
          (fetchedPositions) {
        setState(() {
          positionList = fetchedPositions.map((position) => position.positionTitle).toList();
        });
      },
          (errorMessage) {
        print("Error Callback: $errorMessage");
      },
    );
  }


  void fetchPartyListData() async {
    try {
      PartyListService partyListService = PartyListService();
      List<PartyList> fetchedPartyLists = await partyListService.fetchPartylist();

      // Add N/A option
      fetchedPartyLists.insert(
        0,
        PartyList(
          id: '0',
          image: '',
          title: 'N/A',
          platform: 'No platform available', // Optional placeholder platform
        ),
      );

      setState(() {
        partyLists = fetchedPartyLists;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching party list: $e');
      setState(() {
        isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Candidate Application"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

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
                  Selected = newValue ?? '';
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
            isLoading
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
              value: selectedPartylist.isNotEmpty ? selectedPartylist : null,
              items: partyLists.map((partyList) {
                return DropdownMenuItem(
                  value: partyList.id,
                  child: Text(partyList.title),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPartylist = newValue ?? '';

                  if (selectedPartylist == '0') {
                    partylistController.text = '';
                    showPlatformTextField = true;
                    showPartyListController = false;
                  } else {
                    final selectedParty = partyLists.firstWhere(
                          (party) => party.id == selectedPartylist,
                      orElse: () => PartyList(id: '', image: '', title: '', platform: ''),
                    );
                    partylistController.text = selectedParty.platform;
                    showPlatformTextField = false;
                    showPartyListController = true;
                  }
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Select Partylist',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            if (showPartyListController)
              TextField(
                controller: partylistController,
                maxLines: 3,
                enabled: false,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
            SizedBox(height: 15),
            if (showPlatformTextField)
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
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    String platformText = platformController.text;

                    if (Selected.isNotEmpty) {

                      // Call addCandidates with the selected position and platform
                      addCandidates(context, Selected, platformText, selectedPartylist);


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
