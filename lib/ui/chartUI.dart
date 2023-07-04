import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/model/chartData.dart';
import 'package:tivnqn/global.dart';

class ChartUI {
  static Legend myLegend = Legend(
      itemPadding: 5,
      // height: '40%',
      textStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
      position: LegendPosition.bottom,
      isVisible: true,
      overflowMode: LegendItemOverflowMode.wrap);
  late String catalogue;
  late DateTime date;

  static Widget createChartUI(List<ChartData> dataInput, String title) {
    return SfCartesianChart(
      margin: EdgeInsets.all(5),
      backgroundColor: Colors.white,
      // title: ChartTitle(
      //   text: title,
      //   textStyle: TextStyle(
      //       fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
      // ),
      legend: myLegend,
      axes: <ChartAxis>[
        NumericAxis(
          opposedPosition: true,
          name: 'yAxis1',
          majorGridLines: const MajorGridLines(width: 0),
          labelFormat: '{value}%',
          minimum: 0,
          maximum: 30,
          // interval: 10
        )
      ],
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        opposedPosition: false,
        minimum: 0,
        // maximum: 150,
        // interval: 50,
        // labelFormat: '{value}Pcs',
      ),
      series: getSeries(dataInput),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  static getSeries(List<ChartData> dataInput) {
    var myDataLabelSettings = DataLabelSettings(
      labelAlignment: ChartDataLabelAlignment.middle,
      isVisible: true,
    );
    return <ChartSeries<ChartData, String>>[
      StackedColumnSeries<ChartData, String>(
        dataSource: dataInput,
        xValueMapper: (ChartData data, _) =>
            DateFormat.Md().format(DateTime.parse(data.getDate)),
        yValueMapper: (ChartData data, _) => data.getQty1stOK,
        dataLabelSettings: myDataLabelSettings,
        name: '''初回検品合格数 - SL kiểm lần 1 đạt''',
        color: Colors.blueAccent,
      ),
      StackedColumnSeries<ChartData, String>(
        dataSource: dataInput,
        xValueMapper: (ChartData data, _) =>
            DateFormat.Md().format(DateTime.parse(data.getDate)),
        yValueMapper: (ChartData data, _) => data.getQty1stNOK,
        dataLabelSettings: myDataLabelSettings,
        name: '補修後検品合格数 - SL kiểm lần 1 lỗi',
        color: Colors.orangeAccent,
      ),
      StackedColumnSeries<ChartData, String>(
        dataSource: dataInput,
        xValueMapper: (ChartData data, _) =>
            DateFormat.Md().format(DateTime.parse(data.getDate)),
        yValueMapper: (ChartData data, _) => data.getQtyAfterRepaire,
        dataLabelSettings: myDataLabelSettings,
        name: '補修後検品数 - SL sửa sau kiểm hàng',
        color: Colors.redAccent,
      ),
      LineSeries<ChartData, String>(
          markerSettings:
              MarkerSettings(isVisible: true, shape: DataMarkerType.rectangle),
          dataSource: dataInput,
          yAxisName: 'yAxis1',
          xValueMapper: (ChartData data, _) =>
              DateFormat.Md().format(DateTime.parse(data.getDate)),
          yValueMapper: (ChartData data, _) => data.getRationDefect1st * 100,
          dataLabelSettings: myDataLabelSettings,
          name: '初回不良率 - TL lần 1 lỗi',
          color: Colors.pink,
          width: 2),
      LineSeries<ChartData, String>(
          markerSettings: MarkerSettings(isVisible: true),
          dataSource: dataInput,
          yAxisName: 'yAxis1',
          xValueMapper: (ChartData data, _) =>
              DateFormat.Md().format(DateTime.parse(data.getDate)),
          yValueMapper: (ChartData data, _) => data.getRationDefectAfterRepaire,
          dataLabelSettings: myDataLabelSettings,
          name: '補修後不良率 - TL lỗi sau sửa',
          color: Colors.green,
          width: 2)
    ];
  }
}
