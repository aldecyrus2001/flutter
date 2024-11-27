import 'package:flutter/material.dart';
import 'package:voting_system/login/login.dart';
import 'package:voting_system/user/components/Bottom_Sheets/application_form.dart';

class AnnouncementDialog extends StatelessWidget {
  const AnnouncementDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text("Announcement", style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dear users, we would like to inform you that the official "
              "voting period has not yet begun. We are diligently "
              "working to finalize all necessary preparations to "
              "ensure a smooth and secure voting experience for everyone. "
              "We appreciate your patience and encourage you to stay tuned for "
              "further updates on the voting schedule, which will be announced soon.\n\n"
              "In the meantime, we would like to remind anyone interested in making a "
              "difference within our community that applications are open for those who "
              "wish to run as candidates. This is a wonderful opportunity to represent your "
              "fellow members, voice important issues, and help shape the future.\n\n"
              "Thank you for your understanding and enthusiasm. We look forward "
              "to an exciting election period, and we wish the best of luck to all potential candidates!",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false, // This removes all previous routes
            );
          },
          child: const Text('Logout'),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ApplicationFormPage()), // Replace with your actual screen
            );
          },
          child: const Text('Apply as Candidate'),
        ),
      ],
    );
  }
}
