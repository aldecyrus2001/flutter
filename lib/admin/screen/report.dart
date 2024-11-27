import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../assets/global/global_variable.dart';
import '../components/appBar.dart';

class ResultPerCourse extends StatefulWidget {
  const ResultPerCourse({super.key});

  @override
  State<ResultPerCourse> createState() => _ChartState();
}

class _ChartState extends State<ResultPerCourse> {

  String? selectedPosition;
  List<String> positions = ["President", "Vice President", "Secretary"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20), // Optional space at the top
              Center(
                child: Text(
                  "Voter's Report",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: backgroundColor,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between the title and the chart

              // Dropdown to filter candidates by position
              DropdownButton<String>(
                value: selectedPosition,
                hint: Text("Select Position"),
                items: positions.map((position) {
                  return DropdownMenuItem<String>(
                    value: position,
                    child: Text(position),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPosition = value!;

                  });
                },
              ),

              SizedBox(height: 20),

              // Candidate Table displaying filtered candidates
              SizedBox(
                height: 200, // Set a fixed height for the table
                child: CandidateVoteTable(position: selectedPosition),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CandidateVoteTable extends StatelessWidget {
  final String? position;

  CandidateVoteTable({this.position});

  final List<Map<String, dynamic>> candidates = [
    {
      "name": "John Doe",
      "courseVotes": {"BSIT": 100, "BSCS": 50, "BSHM": 30},
      "totalVotes": 180,
    },
    {
      "name": "Jane Smith",
      "courseVotes": {"BSIT": 80, "BSCS": 60, "BSHM": 40},
      "totalVotes": 180,
    },
    // Add more candidates as needed
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCandidates = candidates.where((candidate) {
      // Filter based on selected position if needed
      return true; // Modify this line according to your data structure
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("BSIT")),
          DataColumn(label: Text("BSCS")),
          DataColumn(label: Text("BSHM")),
          DataColumn(label: Text("Total Votes")),
        ],
        rows: filteredCandidates.map((candidate) {
          return DataRow(cells: [
            DataCell(Text(candidate["name"])),
            DataCell(Text(candidate["courseVotes"]["BSIT"].toString())),
            DataCell(Text(candidate["courseVotes"]["BSCS"].toString())),
            DataCell(Text(candidate["courseVotes"]["BSHM"].toString())),
            DataCell(Text(candidate["totalVotes"].toString())),
          ]);
        }).toList(),
      ),
    );
  }
}
