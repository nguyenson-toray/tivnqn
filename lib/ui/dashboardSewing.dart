import 'dart:async';
import 'dart:io';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/screen2EtsName.dart';
import 'package:tivnqn/ui/screen3EtsProcess.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/ui/screen4ETSWorkLayer.dart';

class DashboardSewing extends StatefulWidget {
  const DashboardSewing({super.key});
  @override
  State<DashboardSewing> createState() => _DashboardSewingState();
}

class _DashboardSewingState extends State<DashboardSewing>
    with SingleTickerProviderStateMixin {
  ChartSeriesController? _chartSeriesController;
  late final AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000))
    ..repeat();

  @override
  void dispose() {
    g.reloadType.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    DateTime chartBeginTime =
        DateTime.parse("${g.todayString} " + g.config.getProductionChartBegin);
    DateTime chartEndTime = chartBeginTime
        .add(Duration(minutes: g.config.getEtsChartDurationMinute));

    g.reloadType.addListener(refreshDataUI);
    if (!g.isTVLine &&
        DateTime.now().isAfter(chartBeginTime) &&
        DateTime.now().isBefore(chartEndTime)) {
      g.screenType = 1;
    } else {
      g.screenType = 4;
    }
    if (g.config.getEtsChart == 0) {
      g.screenType = 1;
    } else {
      g.screenType = 4;
    }
    Timer.periodic(Duration(minutes: 5), (timer) {
      if (g.autochangeLine) {
        setState(() {
          g.currentIndexLine < g.lines.length - 1
              ? g.currentIndexLine++
              : g.currentIndexLine = 0;
          g.currentLine = g.lines[g.currentIndexLine];
          g.reloadType.value = 'changeLine';
          g.reloadType.notifyListeners();
        });
        // g.sharedPreferences.setInt('currentLine', g.currentLine);
      }
    });
    Timer.periodic(Duration(seconds: g.config.getReloadSeconds), (timer) async {
      DateTime time = DateTime.now();
      if (time.hour == 16 && time.minute >= 55)
        exit(0);
      else {
        if (time.hour >= 9 &&
            time.minute >= 0 &&
            time.minute <= 15 &&
            g.config.getEtsChart != 0) {
          g.screenType = 4;
        } else {
          g.screenType = 1;
        }
        setState(() {
          g.reloadType.value = 'refresh';
          g.reloadType.notifyListeners();
        });
        g.configs = await g.sqlApp.sellectConfigs();
        setState(() {
          g.showNotification = MyFuntions.checkShowNotification();
        });
      }
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
      case 'production': //chart production
        {
          MyFuntions.loadDataSQL('production');
          setState(() {
            _chartSeriesController?.updateDataSource(
                updatedDataIndexes:
                    List<int>.generate(g.chartData.length, (i) => i + 1));
          });
        }
        break;
      case 'changeLine': //changeLine
        {
          MyFuntions.loadDataSQL('changeLine');
          setState(() {
            g.workSummary = MyFuntions.summaryDailyDataETS();
            var temp = g.workLayerQtys;
            MyFuntions.createDataChartEtsWorkLayer();

            if (temp != g.workLayerQtys) {
              g.workLayerQtys.clear();
              g.chartUiWorkLayers.clear();
              for (int i = 0; i < g.workLayerNames.length; i++) {
                var workLayerChart = ChartUI.createChartUIWorkLayer(
                    g.workLayerQtys[i], g.workLayerNames[i]);
                g.chartUiWorkLayers.add(workLayerChart);
              }
            }
          });
        }
        break;
      case 'refresh': // refresh
        {
          MyFuntions.loadDataSQL('refresh');
          setState(() {
            if (g.screenType == 1) {
              _chartSeriesController?.updateDataSource(
                  updatedDataIndexes:
                      List<int>.generate(g.chartData.length, (i) => i + 1));
            } else {
              g.workSummary = MyFuntions.summaryDailyDataETS();
              g.workLayerQtys.clear();
              g.chartUiWorkLayers.clear();
              MyFuntions.createDataChartEtsWorkLayer();
              for (int i = 0; i < g.workLayerNames.length; i++) {
                var workLayerChart = ChartUI.createChartUIWorkLayer(
                    g.workLayerQtys[i], g.workLayerNames[i]);
                g.chartUiWorkLayers.add(workLayerChart);
              }
            }
          });
        }
        break;
      default:
    }
    setState(() {
      g.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar(),
        body: Stack(
          children: [
            Container(
                // padding: EdgeInsets.all(1),
                child: g.screenType == 1
                    ? g.chartData.length == 0
                        ? MyFuntions.noData()
                        : g.chartUi
                    : g.screenType == 2
                        ? Screen2EtsName()
                        : g.screenType == 3
                            ? Screen3EtsProcess()
                            : Screen4EtsWorkLayer()),
            g.showNotification
                ? Positioned(child: MyFuntions.showNotification())
                : Container(),
            Positioned(
                right: 2,
                bottom: 2,
                child: Text(
                  'Version : ${g.version}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 6,
                      fontWeight: FontWeight.normal),
                )),
          ],
        ));
  }

  createAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 6.0,
      leadingWidth: 95,
      leading: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          maxRadius: g.appBarH / 2 - 2,
          minRadius: g.appBarH / 2 - 2,
          backgroundColor:
              // g.isLoading
              //     ? Colors.primaries[Random().nextInt(Colors.primaries.length)]
              //     :
              Colors.white,
          child: Center(
            child: Text(
              g.currentLine.toString(),
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    if (g.screenType == 1) {
                      g.screenType = 2;
                    } else {
                      g.screenType = 1;
                    }
                  });
                },
                child: g.config.getEtsChart == 1
                    ? Container(
                        height: g.appBarH,
                        width: g.appBarH,
                        child: g.screenType == 1
                            ? Image.asset('assets/ets.png')
                            : Image.asset('assets/chart.png'))
                    : Container()),
            MyFuntions.clockAppBar(context),
            Text(
              DateFormat(g.dateFormat2).format(
                g.today,
              ),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
        const SizedBox(
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
                                g.reloadType.value = 'production';
                              } else {
                                g.reloadType.value = 'changeLine';
                              }
                              g.reloadType.notifyListeners();
                            });
                          },
                          child: const Icon(
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
                            g.reloadType.value = 'production';
                          } else {
                            g.reloadType.value = 'changeLine';
                          }
                          g.reloadType.notifyListeners();
                        });
                      },
                      child: const Icon(
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
                  const Text(
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
              'SẢN LƯỢNG & TỈ LỆ LỖI',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: g.fontSizeAppbar),
            )
          : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: g.appBarH,
                      width: g.appBarH,
                      child: g.isLoading
                          ? Image.asset('assets/loading.gif')
                          : Image.asset('assets/style.png')),
                  //      RotationTransition(
                  // turns: Tween(begin: 0.0, end: g.isLoading ? 1.0 : 0.0)
                  //     .animate(animationController),
                  // child: g.isLoading
                  //     ? Image.asset('assets/loading.gif')
                  //     : Image.asset('assets/style.png')),
                  Column(
                    children: [
                      Text('${g.currentMoDetail.getStyle.trim()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: g.fontSizeAppbar)),
                      Row(
                        children: [
                          Text(' ${g.currentMoDetail.getDesc.trim()}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                          Text(' - ${g.currentMoDetail.getQty.toString()} Pcs',
                              style: const TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      NDialog(
                        dialogStyle: DialogStyle(titleDivider: true),
                        content: SizedBox(
                          height: 100,
                          width: g.screenWidth,
                          child: DatePicker(
                            DateTime.now().subtract(const Duration(days: 7)),
                            daysCount: 14,
                            initialSelectedDate: DateTime.now(),
                            selectionColor: Colors.black,
                            selectedTextColor: Colors.white,
                            onDateChange: (date) {
                              Navigator.pop(context);
                              setState(() {
                                g.pickedDate = date;
                                g.reloadType.value = 'refresh';
                                g.reloadType.notifyListeners();
                              });
                            },
                          ),
                        ),
                      ).show(context);
                    },
                    child: Container(
                        height: g.appBarH,
                        child: Image.asset('assets/calendar.png')),
                  ),
                  Text(
                      DateFormat(g.dateFormat2).format(
                        g.pickedDate,
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: g.fontSizeAppbar)),
                ],
              ),
              Row(
                children: [
                  Image.asset('assets/list.png'),
                  Text(' ${g.processScaned.length}/${g.processAll.length} ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: g.fontSizeAppbar)),
                  Image.asset('assets/group.png'),
                  Text(
                    ''' ${g.idEmpScaneds.length} ''',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: g.fontSizeAppbar,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        g.screenType++;
                        if (g.screenType == 5) g.screenType = 2;
                      });
                    },
                    child: Container(
                        height: g.appBarH,
                        child: Image.asset('assets/changeScreen.png')),
                  ),
                ],
              ),
            ]),
      toolbarHeight: g.appBarH,
      centerTitle: true,
    );
  }
}
