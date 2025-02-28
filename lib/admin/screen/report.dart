import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../../assets/global/global.dart';
import '../../assets/global/global_variable.dart';
import '../components/appBar.dart';
import '../services/fetchPositions.dart';

class ResultPerCourse extends StatefulWidget {
  const ResultPerCourse({super.key});

  @override
  State<ResultPerCourse> createState() => _ResultPerCourseState();
}

class _ResultPerCourseState extends State<ResultPerCourse> {
  List<String> positionList = [];
  String selectedPosition = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchPosition();
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



  @override
  void dispose() {
    _timer.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }

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
              positionList.isEmpty
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                value: selectedPosition.isNotEmpty ? selectedPosition : null,
                items: positionList.map((position) {
                  return DropdownMenuItem(
                    value: position,
                    child: Text(position),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPosition = newValue ?? '';
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: 'Select Position',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

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

class CandidateVoteTable extends StatefulWidget {
  final String? position;

  const CandidateVoteTable({this.position});

  @override
  State<CandidateVoteTable> createState() => _CandidateVoteTableState();
}

class _CandidateVoteTableState extends State<CandidateVoteTable> {
  List<Map<String, dynamic>> candidates = [];
  List<dynamic> courses = [];
  bool isLoading = false;


  @override
  void didUpdateWidget(CandidateVoteTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.position != widget.position && widget.position != null) {
      fetchCandidates(widget.position!);
      fetchCourses();
    }
  }

  Future<void> fetchCourses() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(fetchCourse);

      if (response.statusCode == 200) {
        final List<dynamic> fetchedCourses = jsonDecode(response.body);
        setState(() {
          courses = fetchedCourses;
          isLoading = false;
        });
      } else {
        print("Failed to fetch courses. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching courses: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCandidates(String position) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(fetchResultPerCourse,
        body: {"position": position},
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = jsonDecode(response.body);
        setState(() {
          candidates = fetchedData.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        print("Failed to fetch candidates. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching candidates: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (candidates.isEmpty) {
      return Center(child: Text("No candidates found for the selected position."));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text("Name")),
          ...courses.map((course) {
            return DataColumn(label: Text(course['courseTitle']));  // Dynamic column for each course
          }).toList(),
          DataColumn(label: Text("Total Votes")),
        ],
        rows: candidates.map((candidate) {
          return DataRow(cells: [
            DataCell(Text(candidate["name"])),
            ...courses.map((course) {
              final courseTitle = course['courseTitle'];
              final courseVotes = candidate['courseVotes'][courseTitle] ?? 0;
              return DataCell(Text(courseVotes.toString()));
            }).toList(),
            DataCell(Text(candidate["totalVotes"].toString())),
          ]);
        }).toList(),
      ),
    );
  }
}
