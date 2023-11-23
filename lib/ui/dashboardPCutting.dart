import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/preparation/.chartDataPCutting.dart';

class DashboardPCutting extends StatefulWidget {
  const DashboardPCutting({super.key});

  @override
  State<DashboardPCutting> createState() => _DashboardPCuttingState();
}

class _DashboardPCuttingState extends State<DashboardPCutting> {
  ChartSeriesController? chartControllerCutting;
  Legend myLegend = const Legend(
      itemPadding: 3,
      // height: '40%',
      textStyle: TextStyle(
          fontSize: 11, fontWeight: FontWeight.normal, color: Colors.black),
      position: LegendPosition.left,
      isVisible: true,
      overflowMode: LegendItemOverflowMode.wrap);
  DataLabelSettings myDataLabelSettings = const DataLabelSettings(
    labelAlignment: ChartDataLabelAlignment.auto,
    labelPosition: ChartDataLabelPosition.outside,
    alignment: ChartAlignment.center,
    isVisible: false,
    textStyle: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  );
  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(minutes: g.refreshMinute), (timer) {
      refreshData();
      if (DateTime.now().hour == 16 && DateTime.now().minute >= 55) exit(0);
    });
    super.initState();
  }

  Future<void> refreshData() async {
    var temp = await g.sqlApp.sellectPCutting();
    if (temp.length != 0) {
      g.pCuttings = temp;
      g.chartDataPCuttings.clear();
      g.pCuttings.forEach((element) {
        var a = element.planQty as num;
        var b = element.actualQty as num;
        ChartDataPCutting temp = ChartDataPCutting(
            name:
                'Line: ${element.line} - ${element.band} - Style:${element.styleNo} -Color:  ${element.color} - Size: ${element.size}   #️⃣Process: ${element.actualQty}/${element.planQty}',
            actual: element.actualQty as num,
            remain: a - b);
        g.chartDataPCuttings.add(temp);
        setState(() {
          chartControllerCutting?.updateDataSource(
              updatedDataIndexes: List<int>.generate(
                  g.chartDataPInspection.length, (i) => i + 1));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 24,
        backgroundColor: Colors.blue,
        elevation: 6.0,
        leadingWidth: 95,
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              g.todayString,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
        leading: Image.asset(
          'assets/logo_white.png',
        ),
        centerTitle: true,
        title: const Text(
          'CUTTING',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: SfCartesianChart(
              // title: ChartTitle(text: 'CUTTING'),
              legend: myLegend,
              primaryXAxis: CategoryAxis(
                labelPosition: ChartDataLabelPosition.inside,
                labelStyle: TextStyle(
                  // fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              series: <ChartSeries>[
                StackedBar100Series<ChartDataPCutting, String>(
                    color: Colors.blue[300],
                    dataSource: g.chartDataPCuttings,
                    dataLabelSettings: myDataLabelSettings,
                    xValueMapper: (ChartDataPCutting data, _) => data.name,
                    yValueMapper: (ChartDataPCutting data, _) => data.actual,
                    name: "Actual",
                    width: 0.8,
                    spacing: 0.2),
                StackedBar100Series<ChartDataPCutting, String>(
                    color: Colors.black12,
                    dataSource: g.chartDataPCuttings,
                    dataLabelSettings: myDataLabelSettings,
                    xValueMapper: (ChartDataPCutting data, _) => data.name,
                    yValueMapper: (ChartDataPCutting data, _) => data.remain,
                    name: "Remain",
                    width: 0.8,
                    spacing: 0.2)
              ])),
    );
  }
}
