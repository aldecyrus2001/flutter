import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/assets/widget/item_dashboard.dart';
import 'package:voting_system/user/classes/userClass.dart';
import 'package:voting_system/user/components/Bottom_Sheets/result.dart';
import 'package:voting_system/user/components/userAppbar.dart';
import 'package:voting_system/user/screen/user_candidate_list.dart';
import 'package:voting_system/user/screen/vote.dart';
import 'package:voting_system/user/user_entry_point.dart';

import '../../admin/admin_entry_point.dart';
import '../../admin/screen/admin_candidate_list.dart';
import '../components/Bottom_Sheets/announcement.dart';

class userHomeScreen extends StatelessWidget {
  const userHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // UserData userData = UserData();
    // final base64Image = userData.getuserProfile();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Sample ",// userData.getUsername(),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 10),

            CircleAvatar(
              backgroundColor: Colors.white24,
              // child: ClipOval(
              //   child: base64Image.isNotEmpty
              //       ? Image.memory(
              //     base64Decode(base64Image.split(',').last),
              //     width: 40,
              //     height: 40,
              //     fit: BoxFit.cover,
              //   )
              //       : const Icon(
              //     CupertinoIcons.person,
              //     color: Colors.white,
              //   ),

              child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            ItemDashboard(
              title: 'Candidates List',
              image: 'candidate-checklist.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserEntryPoint(
                      initialScreen: UserCandidateList(), // Pass the initial screen here
                    ),
                  ),
                );
              },
            ),
            ItemDashboard(
              title: 'Vote',
              image: 'candidate-checklist.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserEntryPoint(
                      initialScreen: VoteBallot(), // Pass the initial screen here
                    ),
                  ),
                );
              },
            ),
            ItemDashboard(
              title: 'Announcement',
              image: 'candidate-checklist.png',
              onTap: () {
                showDialog(context: context, builder: (BuildContext context) {
                  // return SetServer();
                  return AnnouncementDialog();
                });
              },
            ),
            ItemDashboard(
              title: 'Result',
              image: 'candidate-checklist.png',
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
    );
  }
}
