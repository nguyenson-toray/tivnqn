import 'dart:async';
import 'dart:io';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/screen2EtsName.dart';
import 'package:tivnqn/ui/screen3EtsProcess.dart';
import 'package:tivnqn/global.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ChartSeriesController? _chartSeriesController;

  @override
  void dispose() {
    g.reloadType.dispose();
    super.dispose();
  }

  @override
  void initState() {
    DateTime chartBeginTime =
        DateTime.parse(g.todayString + " " + g.appSetting.getChartBegin);
    DateTime chartEndTime =
        chartBeginTime.add(Duration(minutes: g.appSetting.getChartDuration));
    DateTime notificationBeginTime =
        DateTime.parse(g.todayString + " " + g.appSetting.getShowBegin);
    DateTime notificationEndTime = notificationBeginTime
        .add(Duration(minutes: g.appSetting.getShowDuration));

    g.reloadType.addListener(refreshDataUI);
    if (!g.isTVLine &&
        DateTime.now().isAfter(chartBeginTime) &&
        DateTime.now().isBefore(chartEndTime))
      g.screenType = 1;
    else
      g.screenType = 2;
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
    Timer.periodic(new Duration(seconds: g.appSetting.getTimeReload), (timer) {
      setState(() {
        g.reloadType.value = 3;
        g.reloadType.notifyListeners();
      });
      if (g.isTVLine &&
          g.appSetting.getShowNotification != 0 &&
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

  showNotification() async {
    if (Loader.isShown)
      return;
    else {
      print(
          MyFuntions.getLinkImageNotification(g.appSetting.getNotificationURL));
      MyFuntions.playAudio();
      return Loader.show(context,
          overlayColor: Colors.white,
          progressIndicator: Scaffold(
            body: Center(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar(),
        body: Container(
            // padding: EdgeInsets.all(1),
            child: g.screenType == 1
                ? g.chartUi
                : g.screenType == 2
                    ? Screen2EtsName()
                    : Screen3EtsProcess()));
  }

  createAppBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue,
      // leading: Image.asset('assets/logo_white.png'),
      leading: Visibility(
          visible: g.isLoading,
          child: LinearProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.lightBlue,
          )),
      actions: [
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (g.screenType < 3)
                    g.screenType++;
                  else
                    g.screenType = 1;
                });
              },
              child: g.screenType == 1
                  ? Image.asset('assets/screen1.png')
                  : g.screenType == 2
                      ? Image.asset('assets/screen2.png')
                      : Image.asset('assets/screen3.png'),
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        !g.isTVLine
            ? Row(
                children: [
                  g.isTVLine
                      ? Container()
                      : InkWell(
                          onTap: () {
                            if (g.isLoading) return;
                            setState(() {
                              g.currentIndexLine > 0
                                  ? g.currentIndexLine--
                                  : g.currentIndexLine = g.lines.length - 1;
                              g.currentLine = g.lines[g.currentIndexLine];

                              if (g.screenType == 1) {
                                g.reloadType.value = 1;
                              } else {
                                g.reloadType.value = 2;
                              }
                              g.reloadType.notifyListeners();
                            });
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 40,
                          )),
                  InkWell(
                      onTap: () {
                        if (g.isLoading) return;
                        setState(() {
                          g.currentIndexLine < g.lines.length - 1
                              ? g.currentIndexLine++
                              : g.currentIndexLine = 0;
                          g.currentLine = g.lines[g.currentIndexLine];
                          if (g.screenType == 1) {
                            g.reloadType.value = 1;
                          } else {
                            g.reloadType.value = 2;
                          }
                          g.reloadType.notifyListeners();
                        });
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 40,
                      )),
                  Switch(
                    value: g.autochangeLine,
                    onChanged: (value) {
                      setState(() {
                        g.autochangeLine = value;
                      });
                    },
                  ),
                  Text(
                    '''Auto
Change ''',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : Container(),
      ],
      title: g.screenType == 1
          ? Text(
              'SẢN LƯỢNG & TỈ LỆ LỖI - LINE ${g.currentLine}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )
          : Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Row(
                children: [
                  Image.asset('assets/group.png'),
                  Text(
                    '''${g.idEmpScaneds.length}''',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  SizedBox(
                    width: 10,
                  ),
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
                          width: g.screenWidth,
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
                    child: Image.asset('assets/calendar.png'),
                  ),
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
            ]),
      toolbarHeight: g.appBarH,
      centerTitle: true,
    );
  }
}
