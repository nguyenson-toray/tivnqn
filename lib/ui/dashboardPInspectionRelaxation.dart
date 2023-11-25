import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/connection/sqlApp.dart';
import 'package:tivnqn/model/preparation/chartDataPInspection.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/preparation/chartDataPRelaxation.dart';

class DashBoardPInspectionRelaxation extends StatefulWidget {
  const DashBoardPInspectionRelaxation({super.key});

  @override
  State<DashBoardPInspectionRelaxation> createState() =>
      _DashBoardPInspectionRelaxationState();
}

class _DashBoardPInspectionRelaxationState
    extends State<DashBoardPInspectionRelaxation> {
  ChartSeriesController? chartControllerInspection;
  ChartSeriesController? chartControllerRelaxation;
  Legend myLegend = const Legend(
      itemPadding: 3,
      // height: '40%',
      textStyle: TextStyle(
          fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
      position: LegendPosition.bottom,
      isVisible: true,
      overflowMode: LegendItemOverflowMode.wrap);
  DataLabelSettings myDataLabelSettings = const DataLabelSettings(
    labelAlignment: ChartDataLabelAlignment.middle,
    isVisible: false,
    textStyle: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  );
  Future<void> refreshData() async {
    var temp1 = await g.sqlApp.sellectPInspectionFabric();
    if (temp1.length != 0) {
      g.pInspectionFabrics.clear();
      g.chartDataPInspection.clear();
      g.pInspectionFabrics = temp1;
      g.pInspectionFabrics.forEach((element) {
        var a = element.planQty as num;
        var b = element.actualQty as num;
        ChartDataPInspection temp = ChartDataPInspection(
            name:
                '${element.kindOfFabric} - ${element.customer}\nArtNo: ${element.artNo} - LotNo: ${element.lotNo}\n🎨 ${element.color} #️⃣ Process:${element.actualQty}/${element.planQty}',
            actual: element.actualQty as num,
            remain: a - b);
        g.chartDataPInspection.add(temp);
      });
    }

    var temp2 = await g.sqlApp.sellectPRelaxationFabric();
    if (temp2.length != 0) {
      g.pRelaxationFabrics.clear();
      g.chartDataPRelaxation.clear();
      g.pRelaxationFabrics = temp2;
      g.pRelaxationFabrics.forEach((element) {
        var a = element.planQty as num;
        var b = element.actualQty as num;
        ChartDataPRelaxation temp = ChartDataPRelaxation(
            name:
                '${element.kindOfFabric} - ${element.customer}\nArtNo: ${element.artNo} - LotNo: ${element.lotNo}\n🎨 ${element.color} #️⃣ Process:${element.actualQty}/${element.planQty}',
            actual: element.actualQty as num,
            remain: a - b);
        g.chartDataPRelaxation.add(temp);
      });
    }

    setState(() {
      chartControllerInspection?.updateDataSource(
          updatedDataIndexes:
              List<int>.generate(g.chartDataPInspection.length, (i) => i + 1));
      chartControllerRelaxation?.updateDataSource(
          updatedDataIndexes:
              List<int>.generate(g.chartDataPRelaxation.length, (i) => i + 1));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(seconds: g.appSetting.getTimeReload), (timer) {
      DateTime time = DateTime.now();
      if (time.hour == 16 && time.minute >= 55)
        exit(0);
      else
        refreshData();
    });
    super.initState();
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
            'PREPARATION',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Row(
          children: [
            Container(
                padding: EdgeInsets.all(2),
                width: g.screenWidth / 2 - 12,
                child: SfCartesianChart(
                    title: ChartTitle(text: 'INSPECTION FABRIC'),
                    legend: myLegend,
                    primaryXAxis: CategoryAxis(
                      labelAlignment: LabelAlignment.center,
                      labelPosition: ChartDataLabelPosition.inside,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    series: <ChartSeries>[
                      StackedBar100Series<ChartDataPInspection, String>(
                          dataSource: g.chartDataPInspection,
                          dataLabelSettings: myDataLabelSettings,
                          xValueMapper: (ChartDataPInspection data, _) =>
                              data.name,
                          yValueMapper: (ChartDataPInspection data, _) =>
                              data.actual,
                          name: "Actual",
                          width: 0.8,
                          spacing: 0.2),
                      StackedBar100Series<ChartDataPInspection, String>(
                          color: Colors.black12,
                          dataSource: g.chartDataPInspection,
                          dataLabelSettings: myDataLabelSettings,
                          xValueMapper: (ChartDataPInspection data, _) =>
                              data.name,
                          yValueMapper: (ChartDataPInspection data, _) =>
                              data.remain,
                          name: "Remain",
                          width: 0.8,
                          spacing: 0.2)
                    ])),
            VerticalDivider(
              thickness: 2,
            ),
            Container(
                padding: EdgeInsets.all(2),
                width: g.screenWidth / 2 - 12,
                child: SfCartesianChart(
                    title: ChartTitle(text: 'RELAXATION FABRIC'),
                    legend: myLegend,
                    primaryXAxis: CategoryAxis(
                      labelAlignment: LabelAlignment.center,
                      labelPosition: ChartDataLabelPosition.inside,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    series: <ChartSeries>[
                      StackedBar100Series<ChartDataPRelaxation, String>(
                          dataSource: g.chartDataPRelaxation,
                          color: Colors.blue[200],
                          dataLabelSettings: myDataLabelSettings,
                          xValueMapper: (ChartDataPRelaxation data, _) =>
                              data.name,
                          yValueMapper: (ChartDataPRelaxation data, _) =>
                              data.actual,
                          name: "Actual",
                          width: 0.8,
                          spacing: 0.2),
                      StackedBar100Series<ChartDataPRelaxation, String>(
                          dataSource: g.chartDataPRelaxation,
                          color: Colors.black12,
                          dataLabelSettings: myDataLabelSettings,
                          xValueMapper: (ChartDataPRelaxation data, _) =>
                              data.name,
                          yValueMapper: (ChartDataPRelaxation data, _) =>
                              data.remain,
                          name: "Remain",
                          width: 0.8,
                          spacing: 0.2)
                    ])),
          ],
        ));
  }
}
