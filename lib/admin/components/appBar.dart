import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../assets/global/global_variable.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {

  get base64Image => adminProfile;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: Container(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            adminEmail ?? 'No Email Provided',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 10),
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
