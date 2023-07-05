import 'dart:async';
import 'dart:io';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/showNotification.dart';
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
  bool changeSetting = false;
  ChartSeriesController? _chartSeriesController;

  @override
  void initState() {
    g.needLoadAllData = false;
    if (DateTime.now().isAfter(
            DateTime.parse(g.todayString + " " + g.setting.getShowBegin)) &&
        DateTime.now().isBefore(
            DateTime.parse(g.todayString + " " + g.setting.getShowEnd)))
      g.showETS = false;
    else
      g.showETS = true;

    Timer.periodic(new Duration(seconds: g.setting.getReloadTimeSeconds),
        (timer) {
      refreshData();
      if (DateTime.now().hour >= 17) exit(0);
    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> refreshData() async {
    await MyFuntions.getSqlData();
    setState(() {
      g.workSummary.clear();
      g.workSummary = MyFuntions.summaryDailyDataETS();
      g.chartData.clear();
      g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);
      g.chartUi = ChartUI.createChartUI(
          g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
      _chartSeriesController?.updateDataSource(
          updatedDataIndexes:
              List<int>.generate(g.chartData.length, (i) => i + 1));
    });
  }

  Widget setting() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('LINE : '),
        DropdownButton<String>(
          value: g.currentLine.toString(),
          items: lines.map<DropdownMenuItem<String>>((int value) {
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(
                value.toString(),
                style: TextStyle(fontSize: 22),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            g.currentLine = int.parse(newValue!);
            g.sharedPreferences.setInt('currentLine', g.currentLine);
            g.needLoadAllData = true;
            await refreshData();
            g.needLoadAllData = false;
          },
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          actions: [
            g.isTVLine
                ? Row(
                    children: [
                      Text(changeSetting ? 'Lưu' : 'Cài đặt'),
                      InkWell(
                        onTap: () {
                          setState(() {
                            changeSetting = !changeSetting;
                          });
                        },
                        child: changeSetting
                            ? Icon(
                                Icons.save,
                                color: Colors.orange,
                              )
                            : Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      InkWell(
                          onTap: () async {
                            setState(() {
                              g.currentLine > 1
                                  ? g.currentLine = g.currentLine - 1
                                  : g.currentLine = 9;
                            });
                            g.sharedPreferences
                                .setInt('currentLine', g.currentLine);
                            g.needLoadAllData = true;
                            await refreshData();
                            g.needLoadAllData = false;
                          },
                          child: Icon(Icons.arrow_back)),
                      Text('LINE'),
                      InkWell(
                          onTap: () async {
                            setState(() {
                              g.currentLine < 9
                                  ? g.currentLine = g.currentLine + 1
                                  : g.currentLine = 1;
                            });
                            g.sharedPreferences
                                .setInt('currentLine', g.currentLine);
                            g.needLoadAllData = true;
                            await refreshData();
                            g.needLoadAllData = false;
                          },
                          child: Icon(Icons.arrow_forward)),
                    ],
                  ),
            SizedBox(
              width: 20,
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
                        color: Colors.blue,
                        fontSize: 34,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          title: changeSetting
              ? setting()
              : Text(
                  g.showETS
                      ? 'SẢN LƯỢNG HÔM NAY : ${g.currentStyle.trim()}'
                      : 'SẢN LƯỢNG & TỈ LỆ LỖI',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
          toolbarHeight: g.appBarH,
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(2),
          child: g.showETS
              ? Column(
                  children: [
                    g.setting.showNotification == 0
                        ? Container()
                        : ShowNotification(),
                    Expanded(child: Today()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset('assets/warning2.gif')),
                        SizedBox(
                          height: 25,
                          width: 900,
                          child: Marquee(
                              blankSpace: 200,
                              velocity: 30.0,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              text:
                                  '''0-25% : ĐỎ   26-50% : CAM   51-75% : VÀNG   76-100% : XANH       Tổng ${g.idEmpScaneds.length} bạn CN có sản lượng. Những công đoạn chưa có sản lượng : ${g.processNotScan}'''),
                        ),
                      ],
                    ),
                  ],
                )
              : g.chartUi,
        ));
  }
}
