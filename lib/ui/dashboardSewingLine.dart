import 'dart:async';
import 'dart:io';
import 'package:blinking_text/blinking_text.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/today.dart';
import 'package:tivnqn/global.dart';
import 'package:marquee/marquee.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

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
            DateTime.parse(g.todayString + " " + g.setting.getChartBegin)) &&
        DateTime.now().isBefore(
            DateTime.parse(g.todayString + " " + g.setting.getChartEnd)))
      g.showETS = false;
    else
      g.showETS = true;

    Timer.periodic(new Duration(seconds: g.setting.getReloadTimeSeconds),
        (timer) {
      refreshData();
      if (g.setting.getShowNotification != 0 &&
          DateTime.now().isAfter(
              DateTime.parse(g.todayString + " " + g.setting.getShowBegin)) &&
          DateTime.now().isBefore(
              DateTime.parse(g.todayString + " " + g.setting.getShowEnd))) {
        showNotification();
      } else {
        Loader.hide();
      }

      if (DateTime.now().hour >= 17) exit(0);
    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> playAudio() async {
    AssetsAudioPlayer.newPlayer().open(Audio("assets/notification_sound.wav"),
        autoStart: true, volume: 0.5);
  }

  showNotification() async {
    if (Loader.isShown)
      return;
    else {
      double textH = g.setting.text.length > 0 ? 200 : 0;
      double imgH = g.screenHeightPixel / 2 - textH - 16;
      playAudio();
      return Loader.show(context,
          overlayColor: Colors.white,
          progressIndicator: Scaffold(
            body: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: textH,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset('assets/speaker.gif'),
                        ),
                        Flexible(
                          child: Text(
                            '${g.setting.getText}',
                            style: TextStyle(
                                fontSize: 30, overflow: TextOverflow.visible),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: imgH,
                      child: Image.network(
                        g.setting.getImgURL,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.warning,
                        ),
                      )),
                ],
              ),
            ),
          ));
    }
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
      g.needLoadAllData = false;
    });
  }

  // Widget setting() {
  //   return Container(
  //     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       Text('LINE : '),
  //       DropdownButton<String>(
  //         value: g.currentLine.toString(),
  //         items: lines.map<DropdownMenuItem<String>>((int value) {
  //           return DropdownMenuItem<String>(
  //             value: value.toString(),
  //             child: Text(
  //               value.toString(),
  //               style: TextStyle(fontSize: 22),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (String? newValue) async {
  //           g.currentLine = int.parse(newValue!);
  //           g.sharedPreferences.setInt('currentLine', g.currentLine);
  //           g.needLoadAllData = true;
  //           await refreshData();
  //           g.needLoadAllData = false;
  //         },
  //       ),
  //     ]),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          actions: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      if (g.needLoadAllData) return;
                      setState(() {
                        g.currentLine > 1 ? g.currentLine-- : g.currentLine = 9;
                        g.needLoadAllData = true;
                      });
                      g.sharedPreferences.setInt('currentLine', g.currentLine);
                      refreshData();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    )),
                Text('LINE ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
                CircleAvatar(
                  maxRadius: g.appBarH / 2 - 2,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Text(
                      g.currentLine.toString(),
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      if (g.needLoadAllData) return;
                      setState(() {
                        g.currentLine < 9 ? g.currentLine++ : g.currentLine = 1;
                        g.needLoadAllData = true;
                      });
                      g.sharedPreferences.setInt('currentLine', g.currentLine);
                      refreshData();
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    )),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Row(
              children: [
                Switch(
                  value: g.showETS,
                  onChanged: (value) {
                    setState(() {
                      g.showETS = value;
                    });
                  },
                ),
                Text(
                  "ETS",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
          leading: g.showETS
              ? Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: Colors.pinkAccent,
                      size: 28,
                    ),
                    Text(
                      '''${g.idEmpScaneds.length}''',
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Image.asset('assets/logo_white.png'),
          title: g.showETS
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      Row(
                        children: [
                          Image.asset('assets/style.png'),
                          Text('${g.currentStyle.trim()}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22)),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: () async {
                                NDialog(
                                  dialogStyle: DialogStyle(titleDivider: true),
                                  // title: Text("NDialog"),
                                  content: Container(
                                    height: 100,
                                    width: g.screenWidthPixel / 2,
                                    child: DatePicker(
                                      DateTime.now()
                                          .subtract(Duration(days: 7)),
                                      daysCount: 14,
                                      initialSelectedDate: DateTime.now(),
                                      selectionColor: Colors.black,
                                      selectedTextColor: Colors.white,
                                      onDateChange: (date) {
                                        Navigator.pop(context);
                                        setState(() {
                                          if (date != null) {
                                            g.pickedDate = date;
                                            g.needLoadAllData = true;
                                            refreshData();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ).show(context);
                              },
                              child: Icon(Icons.calendar_month,
                                  color: Colors.tealAccent)),
                          Text(
                              DateFormat(g.dateFormat2).format(
                                g.pickedDate,
                              ),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22)),
                        ],
                      ),
                    ])
              : Text(
                  'SẢN LƯỢNG & TỈ LỆ LỖI',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
          toolbarHeight: g.appBarH,
          centerTitle: true,
        ),
        body: Container(
          // padding: EdgeInsets.all(1),
          child: g.showETS
              ? Column(
                  children: [
                    SizedBox(
                      height: 3,
                      width: g.screenHeightPixel,
                      child: Visibility(
                          visible: g.needLoadAllData,
                          child: LinearProgressIndicator(
                              color: Colors.greenAccent)),
                    ),
                    Expanded(child: Today()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          DateFormat('hh:mm').format(DateTime.now()),
                          style: const TextStyle(
                              color: Colors.blue,
                              // fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: 23,
                            width: 23,
                            child: Image.asset('assets/warning2.gif')),
                        SizedBox(
                          height: 23,
                          width: 850,
                          child: Marquee(
                              blankSpace: 200,
                              velocity: 30.0,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              text:
                                  '''${g.processNotScan.length} CĐ chưa có sản lượng : ${g.processNotScan}'''),
                          //0-25 : Đỏ    26-50 : Cam    51-75 : Vàng    76-100 : Xanh    >100 : Ngôi sao
                        ),
                      ],
                    ),
                  ],
                )
              : g.chartUi,
        ));
  }
}
