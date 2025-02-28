import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:voting_system/admin/components/appBar.dart';
import 'package:http/http.dart' as http;
import 'package:voting_system/assets/global/global.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  late List<_ChartData> votesrating = [];

  late TooltipBehavior _tooltip;
  bool isLoading = false;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();

    fetchRating();
  }

  Future<void> fetchRating() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(fetchRatings);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        List<_ChartData> chartData = [];
        int overallTotalUsers = 0;

        for (var item in data) {
          String courseTitle = item['courseTitle'];
          double percentage =
              item['percentage'].toDouble(); // Ensure percentage is double
          int totalUsers = item['totalUsers'];

          chartData.add(_ChartData(courseTitle, percentage, totalUsers));
        }

        setState(() {
          votesrating = chartData;
          isLoading = false;
        });
      } else {
        print("Error: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching courses: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
      body: isLoading
          ? Center(
          child: CircularProgressIndicator()) // Show loader while fetching
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              height: 400,
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'Total Vote Rating',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  alignment: ChartAlignment.center,
                ),
                primaryXAxis: CategoryAxis(
                  isVisible: true,
                  majorGridLines: MajorGridLines(width: 0),
                  labelRotation: 90,
                  autoScrollingDelta: 4,
                  autoScrollingMode: AutoScrollingMode.start,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 20,
                  isVisible: true,
                ),
                tooltipBehavior: _tooltip,
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  alignment: ChartAlignment.center,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                  zoomMode: ZoomMode.x,
                ),
                series: <CartesianSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                    dataSource: votesrating,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Vote Ratings',
                    color: Colors.blueAccent,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.outer,
                      angle: -45,
                      builder: (dynamic data,
                          dynamic point,
                          dynamic series,
                          int pointIndex,
                          int seriesIndex) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${data.y.toStringAsFixed(1)}%', // Display percentage text
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '(${data.totalStudents})', // Display total number of students
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Course")),
                    DataColumn(label: Text("Voted Users")),
                    DataColumn(label: Text("Unvoted Users")),
                    DataColumn(label: Text("Total Voters")),
                  ],
                  rows: votesrating.map((data) {
                    int totalVoted = (data.y * data.totalStudents / 100).toInt();
                    int unvotedUsers = data.totalStudents - totalVoted;

                    return DataRow(cells: [
                      DataCell(Text(data.x)),
                      DataCell(Text(totalVoted.toString())),
                      DataCell(Text(unvotedUsers.toString())),
                      DataCell(Text(data.totalStudents.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _ChartData {
  final String x; // Represents courseTitle
  final double y; // Represents percentage
  final int totalStudents; // Represents totalUsers

  _ChartData(this.x, this.y, this.totalStudents);
}
