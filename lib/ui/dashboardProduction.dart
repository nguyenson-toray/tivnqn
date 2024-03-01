import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/processDetail.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';

class DashboardProduction extends StatefulWidget {
  const DashboardProduction({super.key});

  @override
  State<DashboardProduction> createState() => _DashboardProductionState();
}

class _DashboardProductionState extends State<DashboardProduction>
    with SingleTickerProviderStateMixin {
  var leftCollumnW = g.screenWidth / 4 * 3 - 30 - 4;
  var rightCollumnW = g.screenWidth / 4 + 30 - 3;
  ChartSeriesController? chartControllerETS;
  ChartSeriesController? chartSeriesControllerProduction;
  Widget titleWidgetETS = Container();
  late final AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000))
    ..repeat();
  Legend myLegendETSDaily = const Legend(
      itemPadding: 3,

      // height: '40%',
      textStyle: TextStyle(
          fontSize: 11, fontWeight: FontWeight.normal, color: Colors.black),
      position: LegendPosition.bottom,
      isVisible: true,
      overflowMode: LegendItemOverflowMode.wrap);
  Legend myLegendETSTotal = const Legend(
      itemPadding: 3,
      // height: '40%',
      textStyle: TextStyle(
          fontSize: 11, fontWeight: FontWeight.normal, color: Colors.black),
      position: LegendPosition.bottom,
      isVisible: true,
      overflowMode: LegendItemOverflowMode.wrap);
  DataLabelSettings myDataLabelSettingsETSDaily = const DataLabelSettings(
    labelAlignment: ChartDataLabelAlignment.auto,
    labelPosition: ChartDataLabelPosition.inside,
    alignment: ChartAlignment.center,
    showZeroValue: true,
    isVisible: true,
    // textStyle: TextStyle(
    //     // fontSize: 20,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.black),
  );
  DataLabelSettings myDataLabelSettingsETSTotal = const DataLabelSettings(
    labelAlignment: ChartDataLabelAlignment.auto,
    labelPosition: ChartDataLabelPosition.inside,
    alignment: ChartAlignment.center,
    isVisible: false,
    textStyle: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  );
  @override
  void dispose() {
    g.reloadType.dispose();
    // animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    DateTime chartBeginTime =
        DateTime.parse("${g.todayString} " + g.config.getProductionChartBegin);
    DateTime chartEndTime = chartBeginTime
        .add(Duration(minutes: g.config.getProductionChartDurationMinute));

    g.reloadType.addListener(refreshDataUI);

    if (g.isTVControl) {
      g.screenMode = 'chartETS';
    } else {
      if (g.config.getEtsMO == 'no') {
        g.screenMode = 'chartProduction';
      } else {
        if (DateTime.now().isBefore(chartEndTime)) {
          g.screenMode = 'chartProduction';
        } else {
          g.screenMode = 'chartETS';
        }
      }
    }

    setTitle(g.screenMode);
    Timer.periodic(Duration(seconds: g.config.getReloadSeconds), (timer) async {
      DateTime time = DateTime.now();
      if (time.hour == 16 && time.minute >= 55) {
        exit(0);
      } else {
        setState(() {
          g.reloadType.value = 'refresh';
          g.reloadType.notifyListeners();
        });
        g.configs = await g.sqlApp.sellectConfigs();
        g.thongbao = await g.sqlApp.sellectThongBao();
        setState(() {
          g.showThongBao = MyFuntions.checkThongBao();
        });

        setTitle(g.screenMode);
      }
    });
    Timer.periodic(Duration(minutes: 5), (timer) async {
      if (g.autochangeLine) {
        setState(() {
          g.currentIndexLine++;
          if (g.currentIndexLine >= g.linesETS.length) {
            g.currentIndexLine = 0;
          }
          g.currentLine = g.linesETS.elementAt(g.currentIndexLine);
          g.reloadType.value = 'changeLine';
          g.reloadType.notifyListeners();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('g.screenMode : ${g.screenMode}');
    return Scaffold(
        appBar: appBar(),
        body: Stack(children: [
          Container(
              padding: EdgeInsets.all(3),
              child: g.screenMode == 'chartProduction'
                  ? g.chartData.length == 0
                      ? MyFuntions.noData()
                      : g.chartUi
                  : etsChart()),
          g.showThongBao
              ? Positioned(
                  left: 0, top: 0, child: MyFuntions.showNotification())
              : Positioned(
                  left: 2,
                  bottom: 2,
                  child: Text(
                    'Version : ${g.version}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 6,
                        fontWeight: FontWeight.normal),
                  ))
        ]));
  }

  appBar() {
    return AppBar(
        centerTitle: true,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat(g.dateFormat2).format(
                    g.today,
                  ),
                  style: TextStyle(
                      fontSize: g.fontSizeAppbar,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                MyFuntions.clockAppBar(context)
              ]),
          (g.isTVControl && g.linesETS.length > 1)
              ? actionWidgetAppbar()
              : Container()
        ],
        title: g.titleAppBar);
  }

  etsChart() {
    return Container(
      color: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              color: Colors.white,
              width: leftCollumnW,
              child: SfCartesianChart(
                  // legend: myLegendETSDaily,
                  title: ChartTitle(text: '${'SẢN LƯỢNG HÔM NAY '}'),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(
                      text:
                          'Công đoạn : 1..10 : Chuẩn bị           11..100: May',
                    ),
                    labelPosition: ChartDataLabelPosition.outside,
                    labelStyle: TextStyle(
                      // fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  series: <CartesianSeries<ProcessDetail, String>>[
                    ColumnSeries<ProcessDetail, String>(
                        dataLabelSettings: myDataLabelSettingsETSDaily,
                        markerSettings: const MarkerSettings(isVisible: true),
                        dataSource: g.processDetail,
                        xValueMapper: (ProcessDetail data, _) =>
                            data.getNo.toString(),
                        yValueMapper: (ProcessDetail data, _) =>
                            data.getQtyDaily,
                        color: Color.fromRGBO(8, 142, 255, 1))
                  ])),
          Container(
              color: Colors.white,
              width: rightCollumnW,
              child: SfCartesianChart(
                  legend: myLegendETSTotal,
                  title: ChartTitle(text: 'TỔNG SẢN LƯỢNG'),
                  primaryXAxis: CategoryAxis(
                    labelPosition: ChartDataLabelPosition.inside,
                    labelStyle: TextStyle(
                      // fontSize: 13,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  series: <ChartSeries>[
                    StackedBar100Series<ProcessDetail, String>(
                        color: Colors.green,
                        dataSource: g.processDetail,
                        // dataLabelSettings: myDataLabelSettingsETSTotal,
                        xValueMapper: (ProcessDetail data, _) =>
                            data.getNo.toString() +
                            '-' +
                            data.getName +
                            " : " +
                            data.getQtyTotal.toString() +
                            " pcs",
                        yValueMapper: (ProcessDetail data, _) =>
                            data.getQtyTotal,
                        name: "Hoàn thành",
                        width: 0.8,
                        spacing: 0.2),
                    StackedBar100Series<ProcessDetail, String>(
                        color: Colors.black12,
                        dataSource: g.processDetail,
                        // dataLabelSettings: myDataLabelSettingsETSTotal,
                        xValueMapper: (ProcessDetail data, _) =>
                            data.getNo.toString() +
                            '-' +
                            data.getName +
                            " : " +
                            data.getQtyTotal.toString() +
                            " pcs",
                        yValueMapper: (ProcessDetail data, _) =>
                            g.currentMoDetail.getQty - data.getQtyTotal,
                        name: "Còn lại",
                        width: 0.8,
                        spacing: 0.2)
                  ])),
        ],
      ),
    );
  }

  Future<void> refreshDataUI() async {
    print(
        'refreshDataUI -isLoading : ${g.isLoading} - g.reloadType.value = ${g.reloadType.value} g.screenMode = ${g.screenMode}');
    if (g.isLoading) return;
    await MyFuntions.loadDataSQL(g.reloadType.value);
    switch (g.reloadType.value) {
      case 'production': //chart production
        {
          MyFuntions.loadDataSQL('production');
          setState(() {
            chartSeriesControllerProduction?.updateDataSource(
                updatedDataIndexes:
                    List<int>.generate(g.chartData.length, (i) => i + 1));
          });
        }
        break;
      case 'changeLine': //changeLine
        {
          MyFuntions.loadDataSQL('changeLine');
        }
        break;
      case 'refresh': // refresh
        {
          MyFuntions.loadDataSQL('refresh');

          setState(() {
            if (g.screenMode == 'chartProduction') {
              chartSeriesControllerProduction?.updateDataSource(
                  updatedDataIndexes:
                      List<int>.generate(g.chartData.length, (i) => i + 1));
            } else {
              MyFuntions.summaryDataETS();
              chartControllerETS?.updateDataSource(
                  updatedDataIndexes:
                      List<int>.generate(g.processDetail.length, (i) => i + 1));
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

  void setTitle(String screenMode) {
    setState(() {
      if (g.showThongBao) {
        g.titleAppBar = Text('THÔNG BÁO',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: g.fontSizeAppbar));
      } else {
        switch (screenMode) {
          case 'chartProduction':
            g.titleAppBar = Text('SẢN LƯỢNG & TỈ LỆ LỖI',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: g.fontSizeAppbar));
            break;
          case 'chartETS':
            g.titleAppBar = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${g.currentMoDetail.getStyle.trim()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: g.fontSizeAppbar)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                ),
              ],
            );
            break;
          default:
        }
      }
    });
  }

  actionWidgetAppbar() {
    return Row(
      children: [
        InkWell(
            onTap: () {
              setState(() {
                g.currentIndexLine--;
                if (g.currentIndexLine < 0) {
                  g.currentIndexLine = g.linesETS.length - 1;
                }
                g.currentLine = g.linesETS.elementAt(g.currentIndexLine);
                g.reloadType.value = 'changeLine';
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
              setState(() {
                g.currentIndexLine++;
                if (g.currentIndexLine >= g.linesETS.length) {
                  g.currentIndexLine = 0;
                }
                g.currentLine = g.linesETS.elementAt(g.currentIndexLine);
                g.reloadType.value = 'changeLine';
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
          '''Auto Change Line 
After5 Minutes''',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
}
