import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:voting_system/Utils/rive_utils.dart';
import 'package:voting_system/admin/models/menu_btn.dart';
import 'package:voting_system/admin/models/rive_asset.dart';
import 'package:voting_system/user/components/Bottom_Sheets/announcement.dart';
import 'package:voting_system/user/components/Bottom_Sheets/result.dart';
import 'package:voting_system/user/screen/userDashboard.dart';

import 'package:http/http.dart' as http;

import '../assets/global/global.dart';
import 'classes/Schedule.dart';



class UserEntryPoint extends StatefulWidget {
  final Widget initialScreen;

  const UserEntryPoint({super.key, required this.initialScreen});

  @override
  State<UserEntryPoint> createState() => _UserEntryPointState();
}

class _UserEntryPointState extends State<UserEntryPoint>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    fetchSechedule();
  }

  Future<void> fetchSechedule() async {
    try {
      final response = await http.get(fetchSched);


      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Extract the 'data' list and convert it into a list of Schedule objects
        List<Schedule> schedules = (jsonResponse['data'] as List)
            .map((scheduleJson) => Schedule.fromJson(scheduleJson))
            .toList();

        checkFilingSchedule(schedules);
      } else {
        print("Failed to load schedule, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching schedules: $error");
    }
  }

  void checkFilingSchedule(List<Schedule> schedules) {
    DateTime currentDate = DateTime.now();

    // Find the Filing of Candidacy schedule
    Schedule filingSchedule = schedules.firstWhere(
          (schedule) => schedule.schedTitle == "Filing of Candidacy",
      orElse: () => Schedule(schedID: -1, schedTitle: '', schedStart: '', schedEnd: ''),
    );

    if (filingSchedule.schedID != -1) {
      DateTime schedStart = DateTime.parse(filingSchedule.schedStart);
      DateTime schedEnd = DateTime.parse(filingSchedule.schedEnd);

      // Check if the Filing of Candidacy is ongoing or ended
      if (currentDate.isBefore(schedEnd) && currentDate.isAfter(schedStart)) {
        showDialog(context: context, builder: (BuildContext context) {
          return AnnouncementDialog();
        });
      } else {
        checkVotingSchedule(schedules);
      }
    } else {
      print('Filing of Candidacy schedule not found.');
    }
  }

  void checkVotingSchedule(List<Schedule> schedules) {
    DateTime currentDate = DateTime.now();

    Schedule voteSchedule = schedules.firstWhere(
          (schedule) => schedule.schedTitle == "Vote Time",
      orElse: () => Schedule(schedID: -1, schedTitle: '', schedStart: '', schedEnd: ''),
    );

    if (voteSchedule.schedID != -1) {
      DateTime schedStart = DateTime.parse(voteSchedule.schedStart);
      DateTime schedEnd = DateTime.parse(voteSchedule.schedEnd);

      if (currentDate.isBefore(schedEnd)) {

      } else {
        showDialog(context: context, builder: (BuildContext context) {
          // return SetServer();
          return Result();
        });
      }
    } else {
      print('Vote Time schedule not found.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: widget.initialScreen, // Directly use the userHomeScreen widget here
    );
  }
}
