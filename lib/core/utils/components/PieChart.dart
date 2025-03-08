// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class PieChartComponent extends StatelessWidget {
//   final List<PieChartData> data;

//   const PieChartComponent({Key? key, required this.data}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SfCircularChart(
//       series: <CircularSeries>[
//         PieSeries<PieChartData, String>(
//           dataSource: data,
//           xValueMapper: (PieChartData data, _) => data.category,
//           yValueMapper: (PieChartData data, _) => data.value,
//           dataLabelSettings: DataLabelSettings(isVisible: true),
//           explode: true,
//         ),
//       ],
//     );
//   }
// }

// class PieChartData {
//   final String category;
//   final double value;

//   PieChartData(this.category, this.value);
// }
