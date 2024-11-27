import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../assets/global/global.dart';
import '../../assets/global/global_variable.dart';
import '../components/appBar.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class Scheduler extends StatefulWidget {
  const Scheduler({super.key});

  @override
  State<Scheduler> createState() => _SchedulerState();
}

class _SchedulerState extends State<Scheduler> {
  TextEditingController CandidacyStartDateController = TextEditingController();
  TextEditingController CandidacyStartTimeController = TextEditingController();
  TextEditingController CandidacyEndDateController = TextEditingController();
  TextEditingController CandidacyEndTimeController = TextEditingController();

  TextEditingController VotingStartDateController = TextEditingController();
  TextEditingController VotingStartTimeController = TextEditingController();
  TextEditingController VotingEndDateController = TextEditingController();
  TextEditingController VotingEndTimeController = TextEditingController();

  bool isLoading = true;

  DateTime? candidacyDateStart,
      candidacyDateEnd,
      votingDateStart,
      votingDateEnd;
  var candidacyTimeStart, candidacyTimeEnd;
  var votingTimeStart, votingTimeEnd;

  @override
  void initState() {
    super.initState();

    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    final response = await http.get(FetchSchedules); // Ensure FetchSchedules is a valid URL.

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Access the schedules data
      List<dynamic> schedules = jsonResponse["data"];

      // Iterate through the schedules and assign data to controllers
      for (var schedule in schedules) {
        if (schedule["schedID"] == "1") {
          // Candidacy Schedule
          DateTime startDateTime = DateTime.parse(schedule["schedStart"]);
          DateTime endDateTime = DateTime.parse(schedule["schedEnd"]);

          CandidacyStartDateController.text = "${startDateTime.year}-${startDateTime.month.toString().padLeft(2, '0')}-${startDateTime.day.toString().padLeft(2, '0')}";
          CandidacyStartTimeController.text = "${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}";
          CandidacyEndDateController.text = "${endDateTime.year}-${endDateTime.month.toString().padLeft(2, '0')}-${endDateTime.day.toString().padLeft(2, '0')}";
          CandidacyEndTimeController.text = "${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}";
        } else if (schedule["schedID"] == "2") {
          // Voting Schedule
          DateTime startDateTime = DateTime.parse(schedule["schedStart"]);
          DateTime endDateTime = DateTime.parse(schedule["schedEnd"]);

          VotingStartDateController.text = "${startDateTime.year}-${startDateTime.month.toString().padLeft(2, '0')}-${startDateTime.day.toString().padLeft(2, '0')}";
          VotingStartTimeController.text = "${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}";
          VotingEndDateController.text = "${endDateTime.year}-${endDateTime.month.toString().padLeft(2, '0')}-${endDateTime.day.toString().padLeft(2, '0')}";
          VotingEndTimeController.text = "${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}";
        }
      }

      setState(() {
        isLoading = false; // Set loading to false after fetching data
      });
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<void> _saveCandidacySched(String startCandidacy, String endCandidacy) async {
    var response = await http.post(SaveCandidacySched, body: {
      'startCandidacy': startCandidacy,
      'endCandidacy': endCandidacy
    });

    if (response.statusCode == 200) {
      // If the server returns an OK response
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Show the Snackbar with the response message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['msg']),
          backgroundColor: responseData['statusCode'] == 200 ? Colors.green : Colors.red,
        ),
      );
    } else {
      // Handle error case if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save schedule"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveVotingSched(String startVoting, String endVoting) async {
    var response = await http.post(SaveVotingSched, body: {
      'startVoting': startVoting,
      'endVoting': endVoting
    });

    if (response.statusCode == 200) {
      // If the server returns an OK response
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Show the Snackbar with the response message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['msg']),
          backgroundColor: responseData['statusCode'] == 200 ? Colors.green : Colors.red,
        ),
      );
    } else {
      // Handle error case if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save schedule"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AdminAppBar(),
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator()) // Show loading indicator
              :
          const SizedBox(height: 20),
          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Scheduler",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(
                        16.0), // Add some margin if desired
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: 2), // Outline border
                      borderRadius:
                          BorderRadius.circular(8), // Optional rounded corners
                    ),
                    child: Stack(
                      clipBehavior:
                          Clip.none, // Allows overflow for the positioned text
                      children: [
                        Positioned(
                          top: -12, // Adjust this to control overlap
                          left: 8, // Adjust as needed
                          child: Container(
                            color: backgroundColor, // Background for the label
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0), // Adds space around text
                            child: const Text(
                              "Candidacy Schedule",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Padding inside the container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Please select start date and time:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex:
                                        2, // Give more space to the Date picker
                                    child: TextField(
                                      controller: CandidacyStartDateController,
                                      decoration: const InputDecoration(
                                        labelText: "Date",
                                        hintText: "YYYY-MM-DD",
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      readOnly: true,
                                      onTap: () async {
                                        candidacyDateStart =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2001),
                                                lastDate: DateTime(2050));

                                        if (candidacyDateStart != null) {
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(candidacyDateStart!);

                                          setState(() {
                                            CandidacyStartDateController.text =
                                                formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    flex:
                                        1, // Give less space to the Time picker
                                    child: TextField(
                                      controller: CandidacyStartTimeController,
                                      decoration: const InputDecoration(
                                        labelText: "Time",
                                        hintText: "HH:MM",
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      readOnly: true,
                                      onTap: () async {
                                        candidacyTimeStart =
                                            await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now());

                                        if (candidacyTimeStart != null) {
                                          setState(() {
                                            CandidacyStartTimeController.text =
                                                candidacyTimeStart
                                                    .format(context);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              const Text(
                                "Please select end date and time:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex:
                                        2, // Give more space to the Date picker
                                    child: TextField(
                                      controller: CandidacyEndDateController,
                                      decoration: const InputDecoration(
                                        labelText: "Date",
                                        hintText: "YYYY-MM-DD",
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.white),
                                      readOnly: true,
                                      onTap: () async {
                                        candidacyDateEnd =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2001),
                                            lastDate: DateTime(2050));

                                        if (candidacyDateEnd != null) {
                                          String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(candidacyDateEnd!);

                                          setState(() {
                                            CandidacyEndDateController.text =
                                                formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    flex:
                                        1, // Give less space to the Time picker
                                    child: TextField(
                                      controller: CandidacyEndTimeController,
                                      decoration: const InputDecoration(
                                        labelText: "Time",
                                        hintText: "HH:MM",
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.white),
                                      readOnly: true,
                                      onTap: () async {
                                        candidacyTimeEnd =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now());

                                        if (candidacyTimeEnd != null) {
                                          setState(() {
                                            CandidacyEndTimeController.text =
                                                candidacyTimeEnd
                                                    .format(context);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height:
                                      16), // Space between Row and Save button
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String startCandidacy = CandidacyStartDateController.text + ' ' + CandidacyStartTimeController.text;
                                      String endCandidacy = CandidacyEndDateController.text + ' ' + CandidacyEndTimeController.text;

                                      _saveCandidacySched(startCandidacy, endCandidacy);
                                    },
                                    child: Text("Save"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(
                        16.0), // Add some margin if desired
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: 2), // Outline border
                      borderRadius:
                          BorderRadius.circular(8), // Optional rounded corners
                    ),
                    child: Stack(
                      clipBehavior:
                          Clip.none, // Allows overflow for the positioned text
                      children: [
                        Positioned(
                          top: -12, // Adjust this to control overlap
                          left: 8, // Adjust as needed
                          child: Container(
                            color: backgroundColor, // Background for the label
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0), // Adds space around text
                            child: Text(
                              "Voting Schedule",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Padding inside the container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Please select start date and time:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex:
                                        2, // Give more space to the Date picker
                                    child: TextField(
                                      controller: VotingStartDateController,
                                      decoration: InputDecoration(
                                        labelText: "Date",
                                        hintText: "YYYY-MM-DD",
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.white),
                                      readOnly: true,
                                      onTap: () async {
                                        votingDateStart =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2001),
                                            lastDate: DateTime(2050));

                                        if (votingDateStart != null) {
                                          String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(votingDateStart!);

                                          setState(() {
                                            VotingStartDateController.text =
                                                formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    flex:
                                        1, // Give less space to the Time picker
                                    child: TextField(
                                      controller: VotingStartTimeController,
                                      decoration: InputDecoration(
                                        labelText: "Time",
                                        hintText: "HH:MM",
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.white),
                                      readOnly: true,
                                      onTap: () async {
                                        votingTimeStart =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now());

                                        if (votingTimeStart != null) {
                                          setState(() {
                                            VotingStartTimeController.text =
                                                votingTimeStart
                                                    .format(context);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Text(
                                "Please select end date and time:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex:
                                        2, // Give more space to the Date picker
                                    child: TextField(
                                      controller: VotingEndDateController,
                                      decoration: InputDecoration(
                                        labelText: "Date",
                                        hintText: "YYYY-MM-DD",
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.white),
                                      readOnly: true,
                                      onTap: () async {
                                        votingDateEnd =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2001),
                                            lastDate: DateTime(2050));

                                        if (votingDateEnd != null) {
                                          String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(votingDateEnd!);

                                          setState(() {
                                            VotingEndDateController.text =
                                                formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    flex:
                                        1, // Give less space to the Time picker
                                    child: TextField(
                                      controller: VotingEndTimeController,
                                      decoration: InputDecoration(
                                        labelText: "Time",
                                        hintText: "HH:MM",
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.white),
                                      readOnly: true,
                                      onTap: () async {
                                        votingTimeEnd =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now());

                                        if (votingTimeEnd != null) {
                                          setState(() {
                                            VotingEndTimeController.text =
                                                votingTimeEnd
                                                    .format(context);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height:
                                      16), // Space between Row and Save button
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String startVoting = VotingStartDateController.text + " " + VotingStartTimeController.text;
                                      String endVoting = VotingEndDateController.text + " " + VotingEndTimeController.text;

                                      _saveVotingSched(startVoting, endVoting);
                                    },
                                    child: Text("Save"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
