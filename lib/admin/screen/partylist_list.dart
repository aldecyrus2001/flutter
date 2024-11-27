import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/admin/components/appBar.dart';
import 'package:voting_system/assets/global/global_variable.dart';

import '../../assets/global/global.dart';
import '../../global/components/partylist_dialog_information.dart';
import '../../global/model/my_partylist.dart';

import 'package:http/http.dart' as http;

import '../subscreens/addPartylist.dart';


class PartylistList extends StatefulWidget {
  const PartylistList({super.key});

  @override
  State<PartylistList> createState() => _PartylistListState();
}

class _PartylistListState extends State<PartylistList> {
  double width = 0;
  bool myAnimation = false;
  List<PartyList> partyList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      setState(() {
        myAnimation = true;
      });
    });
    fetchPartyList();
  }

  Future<void> fetchPartyList() async {
    try {
      PartyListService partylistService = PartyListService();
      List<PartyList> fetchPartyList = await partylistService.fetchPartylist();
      setState(() {
        partyList = fetchPartyList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching partylist: $e');
      setState(() {
        isLoading = false; // Update loading state even if there's an error
      });
    }
  }

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
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Partylist List",
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
                        itemCount: partyList.length,
                        itemBuilder: (context, index) {
                          final myPartyList = partyList[index];
                          return GestureDetector(
                            onTap: () {
                              _showPartyListDetails(
                                myPartyList.id
                              );
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
                                    myAnimation ? 0 : width, 0, 0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundImage:
                                            myPartyList.image.isNotEmpty
                                                ? MemoryImage(base64Decode(
                                                    myPartyList.image
                                                        .split(',')
                                                        .last))
                                                : null,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            myPartyList.id,
                                            style: TextStyle(
                                                fontSize:
                                                    myPartyList.id.length >
                                                            15
                                                        ? 10
                                                        : 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            myPartyList.title,
                                            style: TextStyle(
                                              fontSize: myPartyList.title.length > 18 ? 14 : 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
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
                showDialog(
                  context: context,
                  builder: (context) => const Addpartylist(), // Display Addpartylist as a dialog
                );
              },
            ),
          ))
        ],
      ),
    );
  }

  void _showPartyListDetails(String id) async {
    print(id);
    try {
      final response = await http.post(
        ShowPartylist, body: {'partylistID' : id},
      );

      if(response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print(data['data']);

        if(data['data'] != null && data['data'].isNotEmpty) {
          final partylistDetails = data['data'][0];

          showPartyListdetails(context, partylistDetails, fetchPartyList);
        }
        else {
          print('No partylist found with the given ID');
        }
      }
      else{
        throw Exception('Failed to load partylist details');
      }
    }
    catch (e) {
      print('Error fetching user details');
    }
  }
}
