import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http;

import '../../assets/global/global.dart';

class Voter {
  final String userID; // Changed ID to userID to match the JSON
  final String name; // Combine firstName and lastName
  final String section; // Map this as needed from your data
  final String image;

  Voter({
    required this.userID,
    required this.name,
    required this.section,
    required this.image,
  });
}

class VoterService {
  Future<List<Voter>> fetchVoters() async {
    final response = await http.get(FetchUsers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      List<Voter> votersList = data.map((item) {
        String userID = item['userID'];
        String name = '${item['firstName']} ${item['lastName']}';
        String section = '${item['yearLevel']} ${item['course']}'; // Adjust as needed
        String image = item['image']; // Ensure this path is accessible

        return Voter(
          userID: userID,
          name: name,
          section: section,
          image: image,
        );
      }).toList();

      return votersList;
    } else {
      throw Exception('Failed to load voters');
    }
  }
}
