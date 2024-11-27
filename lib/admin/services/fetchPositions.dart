import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../assets/global/global.dart';
import '../../global/model/my_position.dart';

Future<void> fetchPositions(
    Function(List<Position>) onSuccess,  // Callback for successful fetch
    Function(String) onError,            // Callback for error
    ) async {
  try {
    final response = await http.get(FetchPosition);

    if (response.statusCode == 200) {
      List<dynamic> fetchedData = jsonDecode(response.body)['data'];

      if (fetchedData is List) {
        List<Position> positions = fetchedData
            .map((data) => Position.fromJson(data))
            .toList();

        // Pass positions to onSuccess callback
        onSuccess(positions);
      } else {
        onError("Expected a list, but got: ${fetchedData.runtimeType}");
      }
    } else {
      print("Failed to load positions, Status Code: ${response.statusCode}");
    }
  } catch (error) {
    print("Error fetching positions: $error");
  }
}