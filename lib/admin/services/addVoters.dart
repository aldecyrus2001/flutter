import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:voting_system/admin/screen/voters_list.dart';

import '../../assets/global/global.dart';
import '../admin_entry_point.dart';


class AddVoters {
  final String studentId;
  final String firstName;
  final String lastName;
  final String yearLevel;
  final String course;
  final String age;
  final String email;
  final File? imageFile;
  final VoidCallback onSuccess; // Callback to trigger upon success

  const AddVoters({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.yearLevel,
    required this.course,
    required this.age,
    required this.email,
    this.imageFile,
    required this.onSuccess, // Pass callback function
  });

  Future<void> submitData(BuildContext context) async {
    final request = https.MultipartRequest('POST', AddUsers);

    request.fields['student_id'] = studentId;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['year_level'] = yearLevel;
    request.fields['course'] = course;
    request.fields['age'] = age;
    request.fields['email'] = email;

    if (imageFile != null) {
      request.files.add(await https.MultipartFile.fromPath('image', imageFile!.path));
    }

    final response = await request.send();

    // Get the response body as a string
    final responseString = await response.stream.bytesToString();

    // Decode the JSON response
    final Map<String, dynamic> responseData = json.decode(responseString);


    if (responseData['statusCode'] == 200) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminEntryPoint(
            initialScreen: const VotersList(), // Pass the initial screen here
          ),
        ),
      );
    } else {
      print("Failed to submit data, Status Code: ${response.statusCode}");
    }
  }

}
