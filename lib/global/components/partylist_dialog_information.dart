import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voting_system/admin/admin_entry_point.dart';
import 'package:voting_system/admin/screen/partylist_list.dart';

import '../../assets/global/global.dart';

void showPartyListdetails(BuildContext context,
    Map<String, dynamic> partylistDetails, Function fetchPartyList) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: partylistDetails['partylistImage'].isNotEmpty
                      ? MemoryImage(base64Decode(
                          partylistDetails['partylistImage'].split(',').last))
                      : null,
                  child: partylistDetails['partylistImage'].isEmpty
                      ? Icon(
                          Icons.person,
                          size: 50,
                        )
                      : null,
                ),
                SizedBox(height: 10),
                Text(
                  '${partylistDetails['partylistName']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  'Platform: ${partylistDetails['partylistPlatform']}',
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Close'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        _DeletePartyList('${partylistDetails['partylistID']}', context,
                            fetchPartyList);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            )),
      );
    },
  );
}

void _DeletePartyList(
    String id, BuildContext context, Function refreshPartyList) async {
  final response = await http.post(
    DeletePartyList,
    body: {'id': id},
  );

  final Map<String, dynamic> responseData = json.decode(response.body);

  if (responseData['statusCode'] == 200) {
    Navigator.pop(context);

    refreshPartyList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(responseData['msg'])),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(responseData['msg'] ?? 'Failed to Delete Data!')),
    );
  }
}

