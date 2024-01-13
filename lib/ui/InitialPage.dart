import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
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
import 'package:tivnqn/ui/dashboardPCutting.dart';
import 'package:tivnqn/ui/dashboardPDispatch.dart';
import 'package:tivnqn/ui/dashboardPInspectionRelaxation.dart';
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
    if (kDebugMode) {
      setState(() {
        // hourString = "14";
        // minuteString = "32";
      });
    }

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
    Loader.hide();
    super.dispose();
  }

  void checkAndPlay() async {
    print("checkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
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
    isConnectedSqlAppTiqn = await g.sqlApp.initConnection();
    isLoading = false;
    if (isConnectedSqlAppTiqn) {
      g.configs = await g.sqlApp.sellectConfigs();
      setState(() {
        isLoading = false;
        textLoading = '';
        exceriseBegin = DateTime.parse(
            "${g.todayString} " + "${g.configs[0].getDoExerciseTime}");
        hour = exceriseBegin.hour;
        minute = exceriseBegin.minute;
        print('exceriseBegin :' + exceriseBegin.toString());
        if (DateTime.now().isAfter(exceriseBegin)) {
          Future.delayed(const Duration(milliseconds: 200)).then((val) {
            loadDataGoToNextPage();
            return;
          });
        } else {
          cron.schedule(Schedule.parse("${minute - 1} $hour * * * "), () async {
            //// 30 2 * * * [command]This will run once a day, at 2:30 am.
            Timer.periodic(Duration(milliseconds: 200), (timer) {
              if (!isPlaying && playerIsReady) checkAndPlay();
            });
          });
        }
      });

      Loader.hide();
    } else {
      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          Loader.hide();
          textLoading =
              "Có lỗi xảy ra ! Bấm phím BACK trên điều khiển từ xa để tắt ứng dụng & mở lại !";
        });
      });
    }
  }

  showLoading(String textLoading) {
    return Loader.show(
      isAppbarOverlay: false,
      context,
      overlayColor: Colors.white,
      progressIndicator: SizedBox(
          width: 100,
          height: 200,
          child: Column(children: [
            Image.asset('assets/logo.png'),
            Image.asset('assets/loading.gif'),
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isLoading ? 24 * 1.5 : 0,
        backgroundColor: Colors.blue,
        elevation: 6.0,
        title: Text(
          textLoading,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? showLoading(textLoading)
          : Stack(
              children: [
                YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.amber,
                  progressColors: ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),
                  onReady: () {
                    print('Player is ready.');

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
                ),
                Positioned(
                    bottom: 10, right: 10, child: MyFuntions.getClock(context)),
              ],
            ),
    );
  }

  Future<void> loadDataGoToNextPage() async {
    setState(() {
      isLoading = true;
    });
    String imgLinkOrg = '';
    String appBarTitle = '';
    g.currentIndexLine = g.lines.indexOf(g.currentLine);
    g.ip = (await NetworkInfo().getWifiIP())!;
    if (kDebugMode) {
      setState(() {
        g.ip = '192.168.1.71';
      });
    }
    await g.sqlProductionDB.initConnection();
    await g.sqlETSDB.initConnection();
    print('g.ip : ${g.ip} ');
    g.configs.forEach((element) {
      if (g.ip == element.getIp) {
        g.config = element;
      }
    });
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
          g.config.setEtsChart = 1;
          goToSewingPage();
        }
        break;
      case 'line4':
        {
          g.currentLine = 4;
          g.config.setEtsChart = 1;
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
          goToPreparation1();
        }
        break;
      case 'preparation2':
        {
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
          goToPreparation2();
        }
        break;
      case 'preparation3':
        {
          g.pDispatchs = await g.sqlApp.sellectPDispatch();
          goToPreparation3();
        }
        break;
      case 'sample':
        {
          imgLinkOrg =
              'https://drive.google.com/file/d/13dT544GH46HJwXVIKApW_Wyrz21gBZkc/view?usp=drive_link';

          appBarTitle = 'SAMPLE PLANNING';
          goToDashboardImage(appBarTitle, imgLinkOrg);
        }
        break;
      case 'qc':
        {
          imgLinkOrg =
              'https://drive.google.com/file/d/1VT4_93iB2n8U1WqBFSSitVdAYT7vEvvg/view?usp=drive_link';

          appBarTitle = 'QC';
          goToDashboardImage(appBarTitle, imgLinkOrg);
        }
        break;
      case 'planning':
        {
          imgLinkOrg =
              'https://drive.google.com/file/d/1jwLa-cadcjk80SACLTIMwYATF8o5fBOr/view?usp=drive_link';
          g.tvName = 'control3';
          appBarTitle = 'PRODUCTION PLANNING';
          goToDashboardImage(appBarTitle, imgLinkOrg);
        }
      default:
        {
          exit(0);
        }
    }
  }

  void goToPreparation1() {
    Loader.hide();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashBoardPInspectionRelaxation()),
    );
  }

  void goToPreparation2() {
    Loader.hide();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPCutting()),
    );
  }

  void goToPreparation3() {
    Loader.hide();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPDispatch()),
    );
  }

  void goToDashboardImage(String title, String imgLinkOrg) {
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
    g.sqlT01 = await g.sqlProductionDB.getT01InspectionData(g.currentLine);
    g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);

    g.chartUi = ChartUI.createChartUI(
        g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
    if (g.config.getEtsChart != 0) {
      print('**********************************************');
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
    Loader.hide();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardSewing()),
    );
  }
}
