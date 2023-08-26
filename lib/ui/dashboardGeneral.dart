// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:radio_group_v2/radio_group_v2.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:tivn_chart/chart/chartFuntionData.dart';
// import 'package:tivnqn/global.dart';
// import 'package:intl/intl.dart';
// import 'package:tivnqn/start.dart';

// class DashboardGeneral extends StatefulWidget {
//   DashboardGeneral({super.key});

//   @override
//   State<DashboardGeneral> createState() => _DashboardGeneralState();
// }

// class _DashboardGeneralState extends State<DashboardGeneral> {
//   ChartSeriesController? chartSeriesController;
//   double hSetting = 0;
//   double wSetting = 0;
//   double hChart = 0;
//   double wChart = 0;
//   double hChartPhone = 0;
//   double wChartPhone = 0;
//   int padding = 10;
//   bool fullScreen = false;
//   RadioGroupController myController = RadioGroupController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     hSetting = g.screenHeight - 40;
//     wSetting = g.screenWidth * 0.1;
//     hChart = ((g.screenHeight - 35) * 0.5);
//     wChart = g.screenWidth * 0.3280;
//     hChartPhone = g.screenHeight * 0.7;
//     wChartPhone = g.screenHeight;
//     getCurrentScreenName();
//     refreshChartData();
//     Timer.periodic(new Duration(seconds: g.appSetting.getTimeReload), (timer) {
//       getDataT01();
//     });
//     Timer.periodic(new Duration(seconds: g.appSetting.getTimeChangeLine),
//         (timer) {
//       autoChangeLine();
//     });

//     super.initState();
//   }

//   getDataT01() async {
//     if (!mounted) return;

//     await g.sqlProductionDB
//         .getT01InspectionDataFull(g.rangeDays)
//         .then((value) => setState(() {
//               g.sqlT01s = value;
//             }));
//     refreshChartData();
//   }

//   refreshChartData() async {
//     if (!mounted) return;

//     var dataInput = [...g.sqlT01s];
//     setState(() {
//       print(
//           'refreshChartData : screenTypeInt = ${g.screenTypeInt.toString()}     currentLine = ${g.currentLine.toString()}    inspection12 = ${g.inspection12}');
//       g.chartData.clear();
//       g.chartData = ChartFuntionData.createChartData(
//         dataInput,
//         g.currentLine,
//         g.inspection12,
//         g.rangeTime,
//         g.catalogue,
//       );
//       chartSeriesController?.updateDataSource(
//           updatedDataIndexes:
//               List<int>.generate(g.chartData.length, (i) => i + 1));
//       //g.chartData.clear();
//       g.chartDataCompareLine = ChartFuntionData.createChartData(
//         dataInput,
//         g.currentLine,
//         g.inspection12,
//         g.rangeTime,
//         'line',
//       );
//       chartSeriesController?.updateDataSource(
//           updatedDataIndexes:
//               List<int>.generate(g.chartDataCompareLine.length, (i) => i + 1));
//     });
//   }

//   autoChangeLine() {
//     if (!mounted || !g.autoChangeLine || g.screenTypeInt == 0 || !g.isTV)
//       return;
//     if (g.autoChangeLine && g.screenTypeInt == 2) {
//       setState(() {
//         if (g.currentLine < 7)
//           g.currentLine++;
//         else
//           g.currentLine = 1;
//         print('autoChangeLine -> ' + g.currentLine.toString());
//       });
//       refreshChartData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: () async {
//           return await showExitAppAlert();
//         },
//         child: Scaffold(
//           backgroundColor: Colors.blueGrey[100],
//           appBar: buildAppBar(),
//           body: Column(
//             children: [
//               SingleChildScrollView(
//                   padding: EdgeInsets.all(1),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       buildScreen(g.screenTypeInt),
//                     ],
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildScreen(int screenTypeInt) {
//     var screen;
//     switch (screenTypeInt) {
//       case 1:
//         {
//           g.screenName = 'General';
//           screen = g.isTV ? buildScreen1() : buildScreen1_Phone();
//         }
//         break;
//       case 2:
//         {
//           g.screenName = 'Detail';
//           screen = g.isTV ? buildScreen2() : buildScreen2_Phone();
//         }
//         break;
//       case 0:
//         {
//           g.screenName = 'Sewing Line';
//           screen = buildScreen0_sewingLine();
//         }
//         break;
//     }
//     return screen;
//   }

//   Widget buildScreen1() {
//     print('*********buildScreen 1 ');
//     return Container(
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   height: fullScreen ? g.screenHPixel - 30 : hChart + 10,
//                   width: g.screenWPixel / 2 - 10,
//                   child: g.chart.createChartQtyRateUI(g.chartData,
//                       g.titleSLTLLTBTNM, g.catalogue, g.currentLine),
//                 ),
//                 Container(
//                   height: fullScreen ? g.screenHPixel - 30 : hChart + 10,
//                   width: g.screenWPixel / 2 - 10,
//                   child: g.chart.createChartQtyRateUI(g.chartDataCompareLine,
//                       g.titleSLTLLCC, g.catalogue, g.currentLine),
//                 ),
//               ],
//             ),
//             SizedBox(height: 3),
//             Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: hChart - 10,
//                     width: wChart,
//                     child: g.chart.createChartGroupAllUI(g.chartData),
//                   ),
//                   Container(
//                     height: hChart - 10,
//                     width: wChart,
//                     child: g.chart.createChartGroupFUI(g.chartData),
//                   ),
//                   Container(
//                     height: hChart - 10,
//                     width: wChart,
//                     child: g.chart.createChartGroupEUI(g.chartData),
//                   ),
//                 ],
//               ),
//             )
//           ]),
//     );
//   }

//   Widget buildScreen2() {
//     print('*********buildScreen 2 ');
//     return Container(
//       child: Column(
//         children: [
//           Container(
//             height: fullScreen ? g.screenHPixel - 30 : hChart + 10,
//             child: g.chart.createChartQtyRateUI(
//                 g.chartData, '', g.catalogue, g.currentLine),
//           ),
//           SizedBox(height: 3),
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   height: hChart - 10,
//                   width: wChart,
//                   child: g.chart.createChartGroupAllUI(g.chartData),
//                 ),
//                 Container(
//                   height: hChart - 10,
//                   width: wChart,
//                   child: g.chart.createChartGroupFUI(g.chartData),
//                 ),
//                 Container(
//                   height: hChart - 10,
//                   width: wChart,
//                   child: g.chart.createChartGroupEUI(g.chartData),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget buildScreen0_sewingLine() {
//     print('*********  buildScreen 3  sewingLine   ');
//     return Container(
//       height: g.screenHPixel - 30,
//       width: g.screenWPixel,
//       child: g.chart
//           .createChartQtyRateUI(g.chartData, '', g.catalogue, g.currentLine),
//     );
//   }

//   Widget buildScreen1_Phone() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               decoration: g.myBoxDecoration,
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartQtyRateUI(
//                   g.chartData, g.titleSLTLLTBTNM, g.catalogue, g.currentLine),
//             ),
//           ),
//           SizedBox(height: 5),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               decoration: g.myBoxDecoration,
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartQtyRateUI(g.chartDataCompareLine,
//                   g.titleSLTLLCC, g.catalogue, g.currentLine),
//             ),
//           ),
//           SizedBox(height: 5),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               decoration: g.myBoxDecoration,
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartGroupAllUI(g.chartData),
//             ),
//           ),
//           SizedBox(height: 5),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               decoration: g.myBoxDecoration,
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartGroupFUI(g.chartData),
//             ),
//           ),
//           SizedBox(height: 5),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               decoration: g.myBoxDecoration,
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartGroupEUI(g.chartData),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildScreen2_Phone() {
//     return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartQtyRateUI(
//                   g.chartData, '', g.catalogue, g.currentLine),
//             ),
//           ),
//           SizedBox(height: 5),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartGroupAllUI(g.chartData),
//             ),
//           ),
//           SizedBox(height: 5),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartGroupFUI(g.chartData),
//             ),
//           ),
//           SizedBox(height: 5),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               height: hChartPhone,
//               width: wChartPhone,
//               child: g.chart.createChartGroupEUI(g.chartData),
//             ),
//           )
//         ]));
//   }

//   // Widget bbuildScreen3_sewingLinePhone() {}
//   changescreenTypeInt() {
//     setState(() {
//       g.screenTypeInt == 1 ? g.screenTypeInt = 2 : g.screenTypeInt = 1;
//       g.sharedPreferences.setInt('screenTypeInt', g.screenTypeInt);
//     });
//   }

//   getCurrentScreenName() {
//     switch (g.screenTypeInt) {
//       case 1:
//         {
//           g.screenName = 'General';
//         }
//         break;
//       case 2:
//         {
//           g.screenName = 'Detail';
//         }
//         break;
//       case 0:
//         {
//           g.screenName = 'Sewing Line';
//         }
//         break;
//     }
//   }

//   Widget setting() {
//     return Container(
//       child: Row(
//         children: [
//           rangeDay(),
//           //-------

//           playPauseChange()
//         ],
//       ),
//     );
//   }

//   AppBar buildAppBar() {
//     return AppBar(
//       toolbarHeight: 24,
//       backgroundColor: Colors.blue,
//       actionsIconTheme: IconThemeData(
//         color: Colors.white,
//       ),
//       leading: InkWell(
//           onTap: () {
//             setState(() {
//               changescreenTypeInt();
//               buildScreen(g.screenTypeInt);
//             });
//           },
//           child: Row(
//             children: [
//               // SizedBox(height: 8, child: Image.asset('assets/logo.png')),
//               Icon(Icons.dashboard, color: Colors.white),
//               Text(g.screenName),
//               Text('  Version : ${g.version}',
//                   style: TextStyle(fontSize: 5, color: Colors.tealAccent)),
//               // SizedBox(
//               //   width: 5,
//               // ),
//             ],
//           )),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // g.screenTypeInt != 1
//           //     ? Text(('LINE ' + g.currentLine.toString()))
//           //     : SizedBox(height: 20, child: Image.asset('assets/logo.png')),

//           g.screenTypeInt != 0 ? option() : Container(),
//         ],
//       ),
//       centerTitle: true,
//       actions: [getAppBarActionWidget()],
//     );
//   }

//   Widget getAppBarActionWidget() {
//     Widget result = Row();
//     switch (g.screenTypeInt) {
//       case 1:
//         {
//           result = Row(
//             children: [
//               InkWell(
//                   onTap: () {
//                     setState(() {
//                       fullScreen = !fullScreen;
//                     });
//                   },
//                   child: Icon(
//                       fullScreen ? Icons.fullscreen_exit : Icons.fullscreen)),
//               g.device == 'smartphone'
//                   ? InkWell(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => StartPage()),
//                         );
//                       },
//                       child: Icon(Icons.exit_to_app))
//                   : Container(),
//             ],
//           );
//         }
//         break;
//       case 2:
//         {
//           result = Row(
//             children: [
//               // rangeDay(),
//               playPauseChange(),
//               InkWell(
//                   onTap: () {
//                     setState(() {
//                       fullScreen = !fullScreen;
//                     });
//                   },
//                   child: Icon(
//                       fullScreen ? Icons.fullscreen_exit : Icons.fullscreen)),
//             ],
//           );
//         }
//         break;
//       case 3:
//         {}
//         break;
//     }
//     return result;
//   }

//   Widget playPauseChange() {
//     return Container(
//       child: Row(
//         children: [
//           InkWell(
//             child: Icon(
//               g.autoChangeLine ? Icons.pause : Icons.play_circle,
//             ),
//             onTap: () {
//               setState(() {
//                 g.autoChangeLine = !g.autoChangeLine;
//                 g.sharedPreferences.setBool('autoChangeLine', g.autoChangeLine);
//                 refreshChartData();
//               });
//             },
//           ),

//           // g.autoChangeLine
//           //     ?
//           //     InkWell(
//           //         child: Icon(
//           //           g.autoChangeLine ? Icons.pause : Icons.play_circle,
//           //         ),
//           //         onTap: () {
//           //           setState(() {
//           //             g.autoChangeLine = !g.autoChangeLine;
//           //             g.sharedPreferences
//           //                 .setBool('autoChangeLine', g.autoChangeLine);
//           //             refreshChartData();
//           //           });
//           //         },
//           //       )
//           //     : Container(),
//           InkWell(
//             child: Icon(Icons.arrow_back_sharp),
//             onTap: () {
//               setState(() {
//                 if (g.currentLine > g.lines.first)
//                   g.currentLine--;
//                 else
//                   g.currentLine = g.lines.last;
//                 g.sharedPreferences.setInt('currentLine', g.currentLine);
//                 refreshChartData();
//               });
//             },
//           ),
//           g.screenTypeInt != 1
//               ? Text(
//                   ('LINE ' + g.currentLine.toString()),
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.amber),
//                 )
//               : SizedBox(height: 20, child: Image.asset('assets/logo.png')),
//           InkWell(
//             child: Icon(Icons.arrow_forward_sharp),
//             onTap: () {
//               setState(() {
//                 if (g.currentLine < g.lines.last)
//                   g.currentLine++;
//                 else
//                   g.currentLine = g.lines.first;
//                 g.sharedPreferences.setInt('currentLine', g.currentLine);
//                 refreshChartData();
//               });
//             },
//           ),
//           //
//         ],
//       ),
//     );
//   }

//   Widget rangeDay() {
//     return Container(
//       child: Text(
//           style: TextStyle(fontSize: 12),
//           DateFormat('dd/MM/yyyy').format(g.dayFilerBegin) +
//               ' - ' +
//               DateFormat('dd/MM/yyyy').format(
//                 g.dayFilerEnd,
//               )),
//     );
//   }

//   Widget option() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(children: [
//         // Text('Version : ${g.version}',
//         //     style: TextStyle(fontSize: 8, color: Colors.indigoAccent)),
//         // SizedBox(
//         //   width: 25,
//         // ),
//         // rangeDay(),
//         SizedBox(
//           width: 25,
//         ),
//         RadioGroup(
//           onChanged: (value) {
//             setState(() {
//               g.rangeTime = int.parse(value.toString());
//               g.sharedPreferences.setInt('rangeTime', g.rangeTime);
//               refreshChartData();
//             });
//           },
//           controller: myController,
//           values: [1, 2, 4, 6, 10, 14],
//           indexOfDefault: [1, 2, 4, 6, 10, 14].indexOf(g.rangeTime),
//           orientation: RadioGroupOrientation.Horizontal,
//           decoration: RadioGroupDecoration(
//             spacing: 2.0,
//             labelStyle: TextStyle(color: Colors.black, fontSize: 8),
//             activeColor: Colors.amber,
//           ),
//         ),
//         SizedBox(
//           width: 25,
//         ),
//         RadioGroup(
//           onChanged: (value) {
//             setState(() {
//               g.catalogue = value.toString();
//               g.sharedPreferences.setString('catalogue', g.catalogue);
//               refreshChartData();
//             });
//           },
//           controller: myController,
//           values: ["day", "week", "month"],
//           indexOfDefault: ["day", "week", "month"].indexOf(g.catalogue),
//           orientation: RadioGroupOrientation.Horizontal,
//           decoration: RadioGroupDecoration(
//             spacing: 2.0,
//             labelStyle: TextStyle(color: Colors.black, fontSize: 8),
//             activeColor: Colors.indigo,
//           ),
//         ),
//         SizedBox(
//           width: 25,
//         ),
//         // Text('Data', style: TextStyle(color: Colors.black, fontSize: 8)),
//         RadioGroup(
//           onChanged: (value) {
//             setState(() {
//               if (value.toString() == '1st')
//                 g.inspection12 = 1;
//               else
//                 g.inspection12 = 2;
//               g.sharedPreferences.setInt('inspection12', g.inspection12);
//               refreshChartData();
//             });
//           },
//           controller: myController,
//           values: ['1st', '2nd'],
//           indexOfDefault: g.inspection12 == 1 ? 0 : 1,
//           orientation: RadioGroupOrientation.Horizontal,
//           decoration: RadioGroupDecoration(
//             spacing: 2.0,
//             labelStyle: TextStyle(color: Colors.black, fontSize: 8),
//             activeColor: Colors.green,
//           ),
//         ),
//       ]),
//     );
//   }

//   showExitAppAlert() async {
//     await QuickAlert.show(
//         context: context,
//         type: QuickAlertType.confirm,
//         title: 'Exit application ?',
//         confirmBtnText: 'YES',
//         cancelBtnText: 'NO',
//         confirmBtnColor: Colors.indigo,
//         onConfirmBtnTap: () => SystemNavigator.pop());
//   }
// }
