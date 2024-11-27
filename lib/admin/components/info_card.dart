import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.profession,
    required this.base64Image,
  });

  final String name, profession, base64Image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white24,
        child: ClipOval(
          child: base64Image.isNotEmpty
              ? Image.memory(
            base64Decode(base64Image.split(',').last), // Decode the Base64 string
            width: 40, // Adjust this to match the size of the icon
            height: 40, // Adjust this to match the size of the icon
            fit: BoxFit.cover, // Ensure the image covers the avatar
          )
              : Icon(
            CupertinoIcons.person,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        profession,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
