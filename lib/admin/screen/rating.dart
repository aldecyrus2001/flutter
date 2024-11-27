import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:voting_system/admin/components/appBar.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {

  late List<_ChartData> candidate1Data;
  late List<_ChartData> candidate2Data;
  late List<_ChartData> candidate3Data;
  late List<_ChartData> candidate4Data;
  late List<_ChartData> votesrating;

  late TooltipBehavior _tooltip;

  @override
  void initState() {
    // candidate1Data = [
    //   _ChartData('CBM', calculatePercentage(239, 500)),
    //   _ChartData('CE', calculatePercentage(123, 430)),
    //   _ChartData('CA', calculatePercentage(129, 230)),
    //   _ChartData('CET', calculatePercentage(129, 560)),
    //   _ChartData('CPR', calculatePercentage(123, 560)),
    // ];
    //
    // candidate2Data = [
    //   _ChartData('CBM', calculatePercentage(123, 500)),
    //   _ChartData('CE', calculatePercentage(145, 430)),
    //   _ChartData('CA', calculatePercentage(165, 230)),
    //   _ChartData('CET', calculatePercentage(142, 560)),
    //   _ChartData('CPR', calculatePercentage(53, 560))
    //
    // ];
    //
    // candidate3Data = [
    //   _ChartData('CBM', calculatePercentage(133, 500)),
    //   _ChartData('CE', calculatePercentage(125, 430)),
    //   _ChartData('CA', calculatePercentage(155, 230)),
    //   _ChartData('CET', calculatePercentage(112, 560)),
    //   _ChartData('CPR', calculatePercentage(112, 560))
    //
    // ];
    //
    // candidate4Data = [
    //   _ChartData('CBM', calculatePercentage(239, 500)),
    //   _ChartData('CE', calculatePercentage(123, 430)),
    //   _ChartData('CA', calculatePercentage(129, 230)),
    //   _ChartData('CET', calculatePercentage(129, 560)),
    //   _ChartData('CPR', calculatePercentage(123, 560))
    //
    // ];

    votesrating = [
      _ChartData('Overall', calculatePercentage(239 + 123 + 129 + 129 + 123, 500 + 430 + 230 + 560 + 560), 500 + 430 + 230 + 560 + 560),
      _ChartData('BSIT', calculatePercentage(239, 500), 500),
      _ChartData('BSCS', calculatePercentage(123, 430), 430),
      _ChartData('BMMA', calculatePercentage(129, 230), 230),
      _ChartData('BSBA', calculatePercentage(129, 560), 560),
      _ChartData('BSTM', calculatePercentage(123, 560), 560)

    ];

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  double calculatePercentage(int getVotes, int totalStudents){
    return (getVotes / totalStudents) * 100;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: 400,
            //   child: SfCartesianChart(
            //     title: ChartTitle(
            //       text: 'President Rating',
            //       textStyle: TextStyle(
            //         color: Colors.black,
            //         fontSize: 15,
            //       ),
            //       alignment: ChartAlignment.center,
            //     ),
            //     primaryXAxis: CategoryAxis(
            //       isVisible: true,
            //       majorGridLines: MajorGridLines(width: 0),
            //       labelRotation: 90,
            //       autoScrollingDelta: 4,
            //       autoScrollingMode: AutoScrollingMode.start,
            //     ),
            //     primaryYAxis: NumericAxis(
            //       minimum: 0,
            //       maximum: 100,
            //       interval: 20,
            //       isVisible: true,
            //     ),
            //     tooltipBehavior: _tooltip,
            //     legend: Legend(
            //       isVisible: true,
            //       position: LegendPosition.bottom,
            //       alignment: ChartAlignment.center,
            //       overflowMode: LegendItemOverflowMode.wrap,
            //     ),
            //     zoomPanBehavior: ZoomPanBehavior(
            //       enablePanning: true,
            //       zoomMode: ZoomMode.x,
            //     ),
            //     series: <CartesianSeries<_ChartData, String>>[
            //
            //       ColumnSeries<_ChartData, String>(
            //         dataSource: candidate1Data,
            //         xValueMapper: (_ChartData data, _) => data.x,
            //         yValueMapper: (_ChartData data, _) => data.y,
            //         name: 'Candidate 1',
            //         color: Colors.blue,
            //         dataLabelSettings: DataLabelSettings(
            //           isVisible: true,
            //           labelAlignment: ChartDataLabelAlignment.outer,
            //           angle: -45,
            //           builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
            //             return Text(
            //               '${data.y.toStringAsFixed(1)}%',
            //               style: TextStyle(
            //                 color: Colors.blue,
            //                 fontSize: 5,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //       // Series for Candidate 2
            //       ColumnSeries<_ChartData, String>(
            //         dataSource: candidate2Data,
            //         xValueMapper: (_ChartData data, _) => data.x,
            //         yValueMapper: (_ChartData data, _) => data.y,
            //         name: 'Candidate 2',
            //         color: Colors.orange,
            //         dataLabelSettings: DataLabelSettings(
            //           isVisible: true,
            //           labelAlignment: ChartDataLabelAlignment.outer,
            //           labelIntersectAction: LabelIntersectAction.none,
            //           builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
            //             return Text(
            //               '${data.y.toStringAsFixed(1)}%',
            //               style: TextStyle(
            //                 color: Colors.orange,
            //                 fontSize: 5,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //       ColumnSeries<_ChartData, String>(
            //         dataSource: candidate3Data,
            //         xValueMapper: (_ChartData data, _) => data.x,
            //         yValueMapper: (_ChartData data, _) => data.y,
            //         name: 'Candidate 3',
            //         color: Colors.pink,
            //         dataLabelSettings: DataLabelSettings(
            //           isVisible: true,
            //           labelAlignment: ChartDataLabelAlignment.outer,
            //           labelIntersectAction: LabelIntersectAction.none,
            //           builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
            //             return Text(
            //               '${data.y.toStringAsFixed(1)}%',
            //               style: TextStyle(
            //                 color: Colors.pink,
            //                 fontSize: 5,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //       ColumnSeries<_ChartData, String>(
            //         dataSource: candidate4Data,
            //         xValueMapper: (_ChartData data, _) => data.x,
            //         yValueMapper: (_ChartData data, _) => data.y,
            //         name: 'Candidate 4',
            //         color: Colors.green,
            //         dataLabelSettings: DataLabelSettings(
            //           isVisible: true,
            //           labelAlignment: ChartDataLabelAlignment.outer,
            //           labelIntersectAction: LabelIntersectAction.none,
            //           builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
            //             return Text(
            //               '${data.y.toStringAsFixed(1)}%',
            //               style: TextStyle(
            //                 color: Colors.green,
            //                 fontSize: 5,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 30,),
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
                      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                        return Column(
                          mainAxisSize: MainAxisSize.min, // Minimize the vertical space taken by the Column
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
                                color: Colors.grey, // Adjust color if needed
                                fontSize: 8,
                                fontWeight: FontWeight.bold// Smaller font for the total students
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
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.totalStudents);
  final String x;
  final double y;
  final int totalStudents;
}

