import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voting_system/assets/global/global.dart';


class PartyList {
  final String id;
  final String image;
  final String title;
  final String platform;

  PartyList({
    required this.id,
    required this.image,
    required this.title,
    required this.platform
});
}

class PartyListService {
  Future<List<PartyList>> fetchPartylist() async {
    final response = await http.get(FetchPartyList);

    if(response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];


      List<PartyList> partyList = data.map((item) {
        String partylistID = item['partylistID'];
        String image = item['partylistImage'];
        String partyListName = item['partylistName'];
        String platform = item['partylistPlatform'];

        return PartyList(id: partylistID, image: image, title: partyListName, platform: platform);

      }).toList();

      return partyList;
    }
    else {
      throw Exception('Failed to load voters');
    }
  }
}