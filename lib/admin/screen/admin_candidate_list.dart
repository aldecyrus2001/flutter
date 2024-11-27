import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voting_system/global/components/candidate_details.dart';
import 'package:voting_system/global/model/my_candidates.dart';
import 'package:voting_system/global/widgets/candidates_card.dart';
import 'package:http/http.dart' as http;
import 'package:voting_system/user/components/userAppbar.dart';
import '../../assets/global/global.dart';
import '../../global/model/my_position.dart';
import '../components/appBar.dart';
import '../services/fetchPositions.dart';

class AdminCandidateList extends StatefulWidget {
  final bool showButton;
  final bool isForAdminAppBar;
  const AdminCandidateList({super.key, this.showButton = false, this.isForAdminAppBar = false});

  @override
  State<AdminCandidateList> createState() => _AdminCandidateListState();
}

class _AdminCandidateListState extends State<AdminCandidateList> {
  int isSelected = 0;
  List<Position> positions = [];
  List<Candidate> candidatesForPosition = [];
  late bool showSubmitButton;

  @override
  void initState() {
    super.initState();
    showSubmitButton = widget.showButton;
    fetchPositions(
          (fetchedPositions) {
        // Update the positions list with the fetched data
        setState(() {
          positions = fetchedPositions;
          // Optionally, you can fetch candidates for the first position
          if (positions.isNotEmpty) {
            fetchCandidatesForPosition(positions[0].positionTitle);
          }
        });
      },
          (errorMessage) {
        // Handle error (e.g., show a snackbar or alert)
        print(errorMessage); // Or use a dialog/snackbar to show the error message
      },
    );

  }



  Future<void> fetchCandidatesForPosition(String position) async {
    try {
      var response = await http.post(FetchCandidates, body: {
        'position': position
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
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
      bottomNavigationBar: showSubmitButton // Conditional rendering of the button
          ? Container(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Add your submit or vote action here
            print('Vote submitted!');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen,
            padding: const EdgeInsets.symmetric(vertical: 15), // Button padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
          ),
          child: const Text(
            'Submit Vote',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color
            ),
          ),
        ),
      )
          : null, // No button if showSubmitButton is false
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
              builder: (context) => DetailsScreen(candidate: candidate, showRemoveButton: false),
            ),
          ),
          child: CandidatesCard(candidate: candidate, isForVoting: false),
        );
      },
    );
  }
}
