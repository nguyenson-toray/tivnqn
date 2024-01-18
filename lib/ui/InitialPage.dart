import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:tivnqn/global.dart';
import 'package:cron/cron.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:flutter/foundation.dart';
import 'package:tivnqn/model/preparation/.chartDataPCutting.dart';
import 'package:tivnqn/model/preparation/chartDataPInspection.dart';
import 'package:tivnqn/model/preparation/chartDataPRelaxation.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/dashboardImage.dart';
import 'package:tivnqn/ui/dashboardPlanning.dart';
import 'package:tivnqn/ui/dashboardPreparation.dart';
import 'package:tivnqn/ui/dashboardSewing.dart';
import 'package:youtube_player_flutter_quill/youtube_player_flutter_quill.dart';

class InitialPgae extends StatefulWidget {
  const InitialPgae({super.key});

  @override
  State<InitialPgae> createState() => _InitialPgaeState();
}

class _InitialPgaeState extends State<InitialPgae> {
  bool isConnectedSqlAppTiqn = false;
  bool isLoading = true;
  String textLoading = "Load config !";
  FluWakeLock fluWakeLock = FluWakeLock();
  late YoutubePlayerController controller;
  var cron = new Cron();
  bool isPlaying = false;
  bool isPlayed = false;
  String linkDoExercise =
      'https://www.youtube.com/watch?v=Sv7bkD9t9zU&t=8s&ab_channel=%E6%9D%B1%E6%80%A5%E5%BB%BA%E8%A8%AD%E5%85%AC%E5%BC%8F';

  String videoID = '';
  bool playerIsReady = false;
  late DateTime exceriseBegin;
  late DateTime currentTime;
  Duration seekTime = Duration(milliseconds: 0);
  late int hour;
  late int minute;
  String hourString = "07";
  String minuteString = "45";
  bool showVideo = false;
  String imgLinkOrg = '';
  @override
  initState() {
    // TODO: implement initState
    Timer(const Duration(milliseconds: 300), () async {
      g.screenWidth = MediaQuery.of(context).size.width;
      g.screenHeight = MediaQuery.of(context).size.height;
      print('screen size : ${g.screenWidth} x ${g.screenHeight}');
    });
    fluWakeLock.enable();

    initSQLConfigsDoExcerise();

    videoID = YoutubePlayer.convertUrlToId(linkDoExercise)!;
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        hideControls: true,
        loop: false,
        mute: kDebugMode ? false : true,
        autoPlay: false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void checkAndPlay() async {
    g.sqlApp.sellectConfigs().then((value) => {
          if (value[0].getDoExercise == 1)
            {
              controller.play(),
              setState(() {
                isPlaying = true;
              })
            },
        });
  }

  Future<void> initSQLConfigsDoExcerise() async {
    g.ip = (await NetworkInfo().getWifiIP())!;
    if (kDebugMode) {
      setState(() {
        g.ip = '192.168.1.71';
      });
    }
    isConnectedSqlAppTiqn = await g.sqlApp.initConnection();
    isLoading = false;
    if (isConnectedSqlAppTiqn) {
      g.configs = await g.sqlApp.sellectConfigs();
      g.configs.forEach((element) {
        if (g.ip == element.getIp) {
          g.config = element;
          imgLinkOrg = element.getImageLink;
        }
      });
      setState(() {
        isLoading = false;
        textLoading = '';
        exceriseBegin = DateTime.parse(
            "${g.todayString} " + "${g.configs[0].getDoExerciseTime}");
        hour = exceriseBegin.hour;
        minute = exceriseBegin.minute;
        print('exceriseBegin :' + exceriseBegin.toString());
        if (g.config.getDoExercise == 0 ||
            DateTime.now().isAfter(exceriseBegin)) {
          Future.delayed(const Duration(milliseconds: 200)).then((val) {
            loadDataGoToNextPage();
            return;
          });
        } else {
          setState(() {
            showVideo = true;
          });

          // cron.schedule(Schedule.parse("${minute - 1} $hour * * * "), () async {
          //// 30 2 * * * [command]This will run once a day, at 2:30 am.
          Timer.periodic(Duration(milliseconds: 200), (timer) {
            if (!isPlaying && playerIsReady) checkAndPlay();
            if (isPlaying) {
              timer.cancel();
            }
          });
          // });
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          textLoading =
              "Có lỗi xảy ra ! Bấm phím BACK trên điều khiển từ xa để tắt ứng dụng & mở lại !";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          showVideo
              ? YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.amber,
                  progressColors: ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.tealAccent,
                  ),
                  onReady: () {
                    print('Player is ready.');
                    if (DateTime.now().isAfter(exceriseBegin)) {
                      loadDataGoToNextPage();
                    } else
                      setState(() {
                        playerIsReady = true;
                      });
                  },
                  onEnded: (metaData) {
                    setState(() {
                      isPlayed = true;
                    });
                    loadDataGoToNextPage();
                  },
                )
              : Container(),
          Positioned(bottom: 5, right: 5, child: MyFuntions.getClock(context)),
          isLoading ? MyFuntions.showLoading() : Container()
        ],
      ),
    );
  }

  Future<void> loadDataGoToNextPage() async {
    setState(() {
      isLoading = true;
    });

    String appBarTitle = '';
    g.currentIndexLine = g.lines.indexOf(g.currentLine);

    await g.sqlProductionDB.initConnection();
    await g.sqlETSDB.initConnection();
    print('g.ip : ${g.ip} ');

    switch (g.config.getSection) {
      case 'line1':
        {
          g.currentLine = 1;
          goToSewingPage();
        }
        break;
      case 'line2':
        {
          g.currentLine = 2;
          goToSewingPage();
        }
        break;
      case 'line3':
        {
          g.currentLine = 3;
          goToSewingPage();
        }
        break;
      case 'line4':
        {
          g.currentLine = 4;
          goToSewingPage();
        }
        break;
      case 'line5':
        {
          g.currentLine = 5;
          goToSewingPage();
        }
        break;
      case 'line6':
        {
          g.currentLine = 6;
          goToSewingPage();
        }
        break;
      case 'line7':
        {
          g.currentLine = 7;
          goToSewingPage();
        }
        break;
      case 'line8':
        {
          g.currentLine = 8;
          goToSewingPage();
        }
      case 'line9':
        {
          g.currentLine = 9;
          goToSewingPage();
        }
        break;
      case 'line10':
        {
          g.currentLine = 10;
          goToSewingPage();
        }
        break;
      case 'line11':
        {
          g.currentLine = 11;
          goToSewingPage();
        }
        break;
      case 'preparation1':
        {
          g.title = 'INSPECTION FABRIC';
          g.pInspectionFabrics = await g.sqlApp.sellectPInspectionFabric();
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

          g.pRelaxationFabrics = await g.sqlApp.sellectPRelaxationFabric();
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
          goToPreparation();
        }
        break;
      case 'preparation2':
        {
          g.title = 'CUTTING';
          g.pCuttings = await g.sqlApp.sellectPCutting();
          g.pCuttings.forEach((element) {
            var a = element.planQty as num;
            var b = element.actualQty as num;
            ChartDataPCutting temp = ChartDataPCutting(
                name:
                    'Line: ${element.line} - ${element.band} - Style:${element.styleNo} - Color: ${element.color} - Size: ${element.size} #️⃣ Process: ${element.actualQty}/${element.planQty}',
                actual: element.actualQty as num,
                remain: a - b);
            g.chartDataPCuttings.add(temp);
          });
          goToPreparation();
        }
        break;
      case 'preparation3':
        {
          g.title = 'DISPATCH TO SEWING LINE PLAN';
          g.pDispatchs = await g.sqlApp.sellectPDispatch();
          goToPreparation();
        }
        break;
      case 'sample':
        {
          appBarTitle = 'SAMPLE PLANNING';
          goToDashboardImage(appBarTitle, imgLinkOrg);
        }
        break;
      case 'qc':
        {
          appBarTitle = 'QC';
          goToDashboardImage(appBarTitle, imgLinkOrg);
        }
        break;
      case 'planning':
        {
          appBarTitle = 'PRODUCTION PLANNING';
          if (g.config.getImageLink.toString().contains('https://')) {
            goToDashboardImage(appBarTitle, imgLinkOrg);
          } else {
            g.sqlPlanning = await g.sqlApp.getPlanning();
            // Loader.hide();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPlanning()),
            );
          }
        }
      default:
        {
          exit(0);
        }
    }
  }

  void goToPreparation() {
    print("------------------> goToPreparation");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPreparation()),
    );
  }

  void goToDashboardImage(String title, String imgLinkOrg) {
    print("------------------> goToDashboardImage");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DashboardImage(
              title: title,
              linkImageDirectly: MyFuntions.getLinkImage(imgLinkOrg))),
    );
  }

  void goToSewingPage() async {
    print("------------------> goToSewingPage");
    g.thongbao = await g.sqlApp.sellectThongBao();
    g.sqlT01 = await g.sqlProductionDB.getT01InspectionData(g.currentLine);
    g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);

    g.chartUi = ChartUI.createChartUI(
        g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
    if (g.config.getEtsChart != 0) {
      g.moDetails = await g.sqlETSDB.getAllMoDetails();
      g.sqlEmployees = await g.sqlETSDB.getEmployees();
      g.currentMoDetail =
          g.moDetails.firstWhere((element) => element.getLine == g.currentLine);
      g.processDetail =
          await g.sqlETSDB.getProcessDetail(g.currentMoDetail.getCnid);
      g.sqlSumEmpQty = await g.sqlETSDB
          .getSqlSumEmpQty(g.currentMoDetail.getMo, g.pickedDate);
      g.sqlSumNoQty = await g.sqlETSDB
          .getSqlSumNoQty(g.currentMoDetail.getMo, g.pickedDate);
      g.sqlCummulativeNoQty =
          await g.sqlETSDB.getSqlCummNoQty(g.currentMoDetail.getMo);
      g.workSummary = MyFuntions.summaryDailyDataETS();
      //-----------
      g.workLayers = await g.sqlETSDB.getWorklayer();
      MyFuntions.createDataChartEtsWorkLayer();
      for (int i = 0; i < g.workLayerNames.length; i++) {
        var workLayerChart = ChartUI.createChartUIWorkLayer(
            g.workLayerQtys[i], g.workLayerNames[i]);
        g.chartUiWorkLayers.add(workLayerChart);
      }
    }
    // Loader.hide();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardSewing()),
    );
  }
}
