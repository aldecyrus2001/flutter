import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/user/classes/userClass.dart';

class Userappbar extends StatelessWidget implements PreferredSizeWidget {
  const Userappbar({super.key});


  @override
  Widget build(BuildContext context) {

    UserData userData = UserData();
    final base64Image = userData.getuserProfile();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button icon
        onPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
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
            child: ClipOval(
              child: base64Image.isNotEmpty
                  ? Image.memory(
                base64Decode(base64Image.split(',').last),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              )
                  : const Icon(
                CupertinoIcons.person,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
