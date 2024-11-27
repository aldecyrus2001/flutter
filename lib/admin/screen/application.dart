import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../assets/global/global.dart';
import '../../global/components/candidate_details.dart';
import '../../global/model/my_candidates.dart';
import '../../global/model/my_position.dart';
import '../../global/widgets/candidates_card.dart';
import '../components/appBar.dart';


class CandidateApplication extends StatefulWidget {
  const CandidateApplication({super.key});

  @override
  State<CandidateApplication> createState() => _CandidateApplicationState();
}

class _CandidateApplicationState extends State<CandidateApplication> {

  List<Position> positions = [];
  List<Candidate> candidatesForPosition = [];
  int isSelected = 0;

  @override
  void initState() {
    super.initState();
    fetchPositions();
  }

  Future<void> fetchPositions() async {
    try {
      final response = await http.get(FetchPosition);

      if (response.statusCode == 200) {
        List<dynamic> fetchedData = jsonDecode(response.body)['data'];

        if (fetchedData is List) {
          setState(() {
            positions = fetchedData.map((data) => Position.fromJson(data)).toList();
            // Fetch candidates for the first position if available
            if (positions.isNotEmpty) {
              fetchCandidatesForPosition(positions[0].positionTitle);
            }
          });
        } else {
          print("Expected a list, but got: ${fetchedData.runtimeType}");
        }
      } else {
        print("Failed to load positions, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching positions: $error");
    }
  }

  Future<void> fetchCandidatesForPosition(String position) async {
    try {
      var response = await http.post(FetchApplication, body: {
        'position': position
      });



      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        List<dynamic> fetchedCandidates = jsonResponse['data'];
        setState(() {
          candidatesForPosition = fetchedCandidates.map((data) {
            return Candidate.fromJson(data);
          }).toList();
        });
      } else {
        print("Failed to load candidates for $position, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching candidates: $error");
    }
  }

  void onPositionSelected(int index) {
    setState(() {
      isSelected = index;
      fetchCandidatesForPosition(positions[index].positionTitle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
      appBar: AdminAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: positions.length,
                    itemBuilder: (context, index) => _buildCandidateCategory(
                      index: index,
                      name: positions[index].positionTitle,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(child: _buildCandidatesGrid()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCandidateCategory({required int index, required String name}) => GestureDetector(
    onTap: () => onPositionSelected(index),
    child: Container(
      width: 100,
      height: 40,
      margin: const EdgeInsets.only(top: 10, right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected == index ? Colors.red : Colors.red.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );

  _buildCandidatesGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (100 / 140),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: candidatesForPosition.length,
      itemBuilder: (context, index) {
        final candidate = candidatesForPosition[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(candidate: candidate, showRemoveButton: true),
            ),
          ),
          child: CandidatesCard(candidate: candidate, isForVoting: false),
        );
      },
    );
  }
}
