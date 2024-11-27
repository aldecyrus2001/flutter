import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/admin/components/appBar.dart';
import 'package:voting_system/admin/screen/admin_candidate_list.dart';
import 'package:voting_system/admin/screen/application.dart';
import 'package:voting_system/admin/screen/partylist_list.dart';
import 'package:voting_system/admin/screen/rating.dart';
import 'package:voting_system/admin/screen/report.dart';
import 'package:voting_system/admin/screen/scheduler.dart';
import 'package:voting_system/admin/screen/settings.dart';
import 'package:voting_system/admin/screen/voters_list.dart';
import 'package:voting_system/assets/widget/item_dashboard.dart';

import '../../assets/global/global_variable.dart';
import '../../user/components/Bottom_Sheets/result.dart';
import '../admin_entry_point.dart';

class adminHomeScreen extends StatelessWidget {
  const adminHomeScreen({super.key});

  get base64Image => adminProfile;

  @override
  Widget build(BuildContext context) {

    String totalUsersString = (total_users != null) ? total_users.toString() : "0";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
      appBar: AdminAppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
              totalUsersString,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.person,
                color: Colors.green.shade600,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Total Users',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.green.shade600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Colors.white,
              ),
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  ItemDashboard(
                    title: 'Candidates',
                    image: 'candidate-checklist.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEntryPoint(
                            initialScreen: const AdminCandidateList(showButton: false), // Pass the initial screen here
                          ),
                        ),
                      );
                    },
                  ),
                  ItemDashboard(
                    title: 'Voters',
                    image: 'voter.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEntryPoint(
                            initialScreen: const VotersList(), // Pass the initial screen here
                          ),
                        ),
                      );
                    },
                  ),
                  ItemDashboard(
                    title: 'Application',
                    image: 'driver-license.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEntryPoint(
                            initialScreen: const CandidateApplication(), // Pass the initial screen here
                          ),
                        ),
                      );
                    },
                  ),

                  ItemDashboard(
                    title: 'Partylist',
                    image: 'driver-license.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEntryPoint(
                            initialScreen: const PartylistList(), // Pass the initial screen here
                          ),
                        ),
                      );
                    },
                  ),

                  ItemDashboard(
                    title: 'Schedule',
                    image: 'schedule.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEntryPoint(
                            initialScreen: const Scheduler(), // Pass the initial screen here
                          ),
                        ),
                      );
                    },
                  ),

                  ItemDashboard(
                    title: 'Report',
                    image: 'report.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEntryPoint(
                            initialScreen: const ResultPerCourse(), // Pass the initial screen here
                          ),
                        ),
                      );
                    },
                  ),

                  ItemDashboard(
                    title: 'Ratings',
                    image: 'report.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEntryPoint(
                            initialScreen: const Rating(), // Pass the initial screen here
                          ),
                        ),
                      );
                    },
                  ),
                  ItemDashboard(
                    title: 'Settings',
                    image: 'announcement.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEntryPoint(
                            initialScreen: const Settings(), // Pass the initial screen here
                          ),
                        ),
                      );
                    },
                  ),

                  ItemDashboard(
                    title: 'Result',
                    image: 'announcement.png',
                    onTap: () {
                      showDialog(context: context, builder: (BuildContext context) {
                        // return SetServer();
                        return Result();
                      });
                    },
                  ),
                ],
              ),

            ),
          )
        ],
      ),
    );
  }
}
