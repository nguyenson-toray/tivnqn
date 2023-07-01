import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/footer.dart';
import 'package:tivnqn/ui/today.dart';
import 'package:tivnqn/global.dart';
import 'package:marquee/marquee.dart';

class DashboardSewingLine extends StatefulWidget {
  const DashboardSewingLine({super.key});
  @override
  State<DashboardSewingLine> createState() => _DashboardSewingLineState();
}

class _DashboardSewingLineState extends State<DashboardSewingLine> {
  final lines = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  ChartSeriesController? _chartSeriesController;

  @override
  void initState() {
    if (DateTime.now().hour > 3)
      setState(() {
        g.showETS = true;
      });
    ;
    Timer.periodic(new Duration(seconds: g.secondsAutoGetData), (timer) {
      refreshData();
      if (DateTime.now().hour > 17) exit(0);
    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> refreshData() async {
    await MyFuntions.getSqlData();
    setState(() {
      g.workSummary = MyFuntions.summaryDailyDataETS();
      g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);
      g.chartUi = ChartUI.createChartUI(
          g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
      _chartSeriesController?.updateDataSource(
          updatedDataIndexes:
              List<int>.generate(g.chartData.length, (i) => i + 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          actions: [
            Text(
              'LINE : ',
              style: TextStyle(fontSize: 8),
            ),
            DropdownButton<String>(
              value: g.currentLine.toString(),
              items: lines.map<DropdownMenuItem<String>>((int value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(
                    value.toString(),
                    style: TextStyle(fontSize: 8),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  g.currentLine = int.parse(newValue!);
                  g.sharedPreferences.setInt('currentLine', g.currentLine);
                  refreshData();
                  // changeSetting();
                });
              },
            ),
            Row(
              children: [
                Text("ETS"),
                Switch(
                  value: g.showETS,
                  onChanged: (value) {
                    setState(() {
                      g.showETS = value;
                    });
                  },
                ),
              ],
            ),
          ],
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logo_white.png'),
              CircleAvatar(
                maxRadius: 24,
                backgroundColor: Colors.white,
                child: Center(
                  child: Text(
                    g.currentLine.toString(),
                    style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                g.showETS ? 'SẢN LƯỢNG HÔM NAY - ETS' : 'SẢN LƯỢNG & TỈ LỆ LỖI',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ],
          ),
          toolbarHeight: g.appBarH,
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(2),
          child: g.showETS
              ? Column(
                  children: [
                    Expanded(child: Today()),
                    SizedBox(
                      height: 30,
                      child: Marquee(
                          velocity: 30.0,
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                          text:
                              '''CĐ CHƯA CÓ SẢN LƯỢNG : ${g.processNotScan}'''),
                    ),
                  ],
                )
              : g.chartUi,
        ));
  }
}
