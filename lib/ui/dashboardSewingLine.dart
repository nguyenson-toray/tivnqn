import 'dart:async';
import 'dart:io';
import 'package:blinking_text/blinking_text.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/showAllProcess.dart';
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
  ChartSeriesController? _chartSeriesController;

  @override
  void dispose() {
    g.reloadType.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (kDebugMode) {
      // g.isTVLine = true;
    }
    DateTime chartBeginTime =
        DateTime.parse(g.todayString + " " + g.appSetting.getChartBegin);
    DateTime chartEndTime =
        chartBeginTime.add(Duration(minutes: g.appSetting.getChartDuration));
    DateTime notificationBeginTime =
        DateTime.parse(g.todayString + " " + g.appSetting.getShowBegin);
    DateTime notificationEndTime =
        chartBeginTime.add(Duration(minutes: g.appSetting.getShowDuration));
    g.reloadType.addListener(refreshDataUI);
    if (g.isTVLine) g.autochangeLine = false;
    if (!g.isTVLine &&
        DateTime.now().isAfter(chartBeginTime) &&
        DateTime.now().isBefore(chartEndTime))
      g.showETS = false;
    else
      g.showETS = true;
    Timer.periodic(new Duration(minutes: g.appSetting.getTimeChangeLine),
        (timer) {
      if (g.autochangeLine) {
        setState(() {
          g.currentIndexLine < g.lines.length - 1
              ? g.currentIndexLine++
              : g.currentIndexLine = 0;
          g.currentLine = g.lines[g.currentIndexLine];
          g.reloadType.value = 2;
          g.reloadType.notifyListeners();
        });
        g.sharedPreferences.setInt('currentLine', g.currentLine);
      }
    });
    Timer.periodic(new Duration(minutes: g.appSetting.getTimeReload), (timer) {
      setState(() {
        g.reloadType.value = 3;
        g.reloadType.notifyListeners();
      });
      if (g.appSetting.getShowNotification != 0 &&
          DateTime.now().isAfter(notificationBeginTime) &&
          DateTime.now().isBefore(notificationEndTime)) {
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
        autoStart: true, volume: 1.0);
  }

  showNotification() async {
    if (Loader.isShown || !g.isTVLine)
      return;
    else {
      playAudio();
      return Loader.show(context,
          overlayColor: Colors.white,
          progressIndicator: Scaffold(
            body: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  MyFuntions.getLinkImageNotification(
                      g.appSetting.getNotificationURL),
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.warning,
                    size: 50,
                  ),
                )),
          ));
    }
  }

  Future<void> refreshDataUI() async {
    print(
        'refreshDataUI -isLoading : ${g.isLoading} - g.reloadType.value = ${g.reloadType.value}');
    if (g.isLoading) return;
    await MyFuntions.loadDataSQL(g.reloadType.value);
    switch (g.reloadType.value) {
      case 1: //chart production
        {
          setState(() {
            g.chartData.clear();
            g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);
            g.chartUi = ChartUI.createChartUI(
                g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
            _chartSeriesController?.updateDataSource(
                updatedDataIndexes:
                    List<int>.generate(g.chartData.length, (i) => i + 1));
          });
        }
        break;
      case 2: //all ETS
        {
          setState(() {
            g.workSummary.clear();
            g.workSummary = MyFuntions.summaryDailyDataETS();
          });
        }
        break;
      case 3: // line data
        {
          setState(() {
            g.workSummary.clear();
            g.workSummary = MyFuntions.summaryDailyDataETS();
          });
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar(),
        body: Container(
          // padding: EdgeInsets.all(1),
          child: g.showETS
              ? Column(
                  children: [
                    SizedBox(
                      height: 3,
                      width: g.screenHeightPixel,
                      child: Visibility(
                          visible: g.isLoading,
                          child: LinearProgressIndicator(
                              color: Colors.greenAccent)),
                    ),
                    Expanded(child: g.showProcess ? ShowAllProcess() : Today()),
                    !g.showProcess
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                DateFormat('hh:mm').format(DateTime.now()),
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: g.processNotScan.length > 0
                                      ? Image.asset('assets/warning2.gif')
                                      : Icon(
                                          Icons.thumb_up,
                                          size: 20,
                                          color: Colors.green,
                                        )),
                              SizedBox(
                                height: 30,
                                width: 850,
                                child: g.processNotScan.length > 0
                                    ? Marquee(
                                        blankSpace: 200,
                                        velocity: 40.0,
                                        scrollAxis: Axis.horizontal,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent),
                                        text:
                                            '''${g.processNotScan.length} CĐ chưa có sản lượng : ${g.processNotScan}''')
                                    : Text(
                                        '100% CĐ có sản lượng !',
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                //0-25 : Đỏ    26-50 : Cam    51-75 : Vàng    76-100 : Xanh    >100 : Ngôi sao
                              ),
                            ],
                          )
                        : Container(),
                  ],
                )
              : g.chartUi,
        ));
  }

  createAppBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue,
      actions: [
        Row(
          children: [
            InkWell(
                onTap: () {
                  if (g.isLoading) return;
                  setState(() {
                    g.currentIndexLine > 0
                        ? g.currentIndexLine--
                        : g.currentIndexLine = g.lines.length - 1;
                    g.currentLine = g.lines[g.currentIndexLine];
                    g.reloadType.value = 2;
                    g.reloadType.notifyListeners();
                  });
                  g.sharedPreferences.setInt('currentLine', g.currentLine);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 40,
                )),
            Text('LINE ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28)),
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
                  if (g.isLoading) return;
                  setState(() {
                    g.currentIndexLine < g.lines.length - 1
                        ? g.currentIndexLine++
                        : g.currentIndexLine = 0;
                    g.currentLine = g.lines[g.currentIndexLine];

                    g.reloadType.value = 2;
                    g.reloadType.notifyListeners();
                  });
                  g.sharedPreferences.setInt('currentLine', g.currentLine);
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 40,
                )),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        g.isTVLine
            ? Row(
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
              )
            : Row(
                children: [
                  Switch(
                    value: g.autochangeLine,
                    onChanged: (value) {
                      setState(() {
                        g.autochangeLine = value;
                      });
                    },
                  ),
                  Text(
                    "Auto change",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
      ],
      title: g.showETS
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              g.showETS
                  ? Row(
                      children: [
                        Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 36,
                        ),
                        Text(
                          '''${g.idEmpScaneds.length}''',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : Image.asset('assets/logo_white.png'),
              Row(
                children: [
                  Image.asset('assets/style.png'),
                  Text('${g.currentStyle.trim()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28)),
                ],
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () async {
                        NDialog(
                          dialogStyle: DialogStyle(titleDivider: true),
                          content: Container(
                            height: 100,
                            width: g.screenWidthPixel / 2,
                            child: DatePicker(
                              DateTime.now().subtract(Duration(days: 7)),
                              daysCount: 14,
                              initialSelectedDate: DateTime.now(),
                              selectionColor: Colors.black,
                              selectedTextColor: Colors.white,
                              onDateChange: (date) {
                                Navigator.pop(context);
                                setState(() {
                                  if (date != null) {
                                    g.pickedDate = date;
                                    g.reloadType.value = 3;
                                    g.reloadType.notifyListeners();
                                  }
                                });
                              },
                            ),
                          ),
                        ).show(context);
                      },
                      child: Icon(Icons.calendar_month,
                          size: 36, color: Colors.white)),
                  Text(
                      DateFormat(g.dateFormat2).format(
                        g.pickedDate,
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28)),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    g.showProcess = !g.showProcess;
                  });
                },
                child: Icon(
                  Icons.change_circle_sharp,
                  color: g.showProcess ? Colors.black : Colors.white,
                  size: 36,
                ),
              )
            ])
          : Text(
              'SẢN LƯỢNG & TỈ LỆ LỖI',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
      toolbarHeight: g.appBarH,
      centerTitle: true,
    );
  }
}
