import 'dart:convert';

import 'package:flutter/material.dart';

import '../../assets/global/global.dart';
import '../classes/userClass.dart';
import 'package:http/http.dart' as https;

import '../components/Bottom_Sheets/alert.dart';


addCandidates(BuildContext context, String position, String platform) async {
  try {
    String? userID = UserData().getuserID();

    if (userID != null) {
      var response = await https.post(
        AddCandidateURL,
        body: {
          'userID': userID,
          'position': position,
          'platform': platform,
        },
      );

      var data = json.decode(response.body);
      print(data); // You should see something like {'statusCode': 409, 'msg': 'User ID already exists'}

      // Check if response is not empty and contains the statusCode
      if (data.containsKey('statusCode')) {
        // Handle error status code 409 (User ID already exists)
        if (data['statusCode'] == '200') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                icon: Icons.check,
                text: "Successfully Added!",
              );
            },
          );
        }
        // Handle other unexpected status codes
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Response: ${data['msg'] ?? 'No message'}')),
          );
        }
      } else {
        // Handle case where 'statusCode' key does not exist in the response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid response format: Missing statusCode')),
        );
      }
    } else {
      // Handle case where userID is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID is missing')),
      );
    }
  } catch (e) {
    // Handle network or URI error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Server error: $e")),
    );
    print("Error: $e");
  }
}
