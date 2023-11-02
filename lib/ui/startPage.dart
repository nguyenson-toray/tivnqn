import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:restart_app/restart_app.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/dashboardImage.dart';
import 'package:tivnqn/ui/dashboardPlanning.dart';
import 'package:tivnqn/ui/dashboardPlanningImage.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/dashboardSewing.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoaded = false;
  String imgLinkOrg = '';
  FluWakeLock fluWakeLock = FluWakeLock();
  bool connected = true;
  var myTextStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  void initState() {
    // TODO: implement initState

    Timer(const Duration(milliseconds: 300), () async {
      initData().then((value) => (value) {
            setState(() {
              isLoaded = value;
              print('isLoaded ==: $isLoaded');
            });
          });
      g.screenWidth = MediaQuery.of(context).size.width;
      g.screenHeight = MediaQuery.of(context).size.height;
      print('screen size : ${g.screenWidth} x ${g.screenHeight}');
    });

    super.initState();
  }

  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }

  Future<void> initData() async {
    print('Start Page - initData');
    fluWakeLock.enable();
    if (!connected) {
      Loader.hide();
      Loader.show(context,
          isSafeAreaOverlay: true,
          overlayColor: Colors.grey[300],
          progressIndicator: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/error.png'),
              Text('''LỖI KẾT NỐI ĐẾN MÁY CHỦ !
HÃY TẮT APP (Bấm phím BACK) => KIỂM TRA CÀI ĐẶT KẾT NỐI WIFI => MỞ LẠI APP''')
            ],
          ));
      Future.delayed(const Duration(seconds: 15), () {
        setState(() {
          Loader.hide();
          Restart.restartApp();
        });
      });
      return;
    }

    g.ip = (await NetworkInfo().getWifiIP())!;
    if (kDebugMode) {
      setState(() {
        g.ip = '192.168.1.68';
      });
    }

    print('g.ip : ${g.ip} ');
    switch (g.ip) {
      case '192.168.1.61':
        {
          imgLinkOrg =
              'https://drive.google.com/file/d/1XQ_bjXdpaUupiq8k8kHpsYqCgM_Kwtpq/view?usp=drive_link';
          g.tvName = 'preparation1';
        }
        break;
      case '192.168.1.62':
        {
          imgLinkOrg =
              'https://drive.google.com/file/d/1FVqBg-Pm2OQEZgXTPgQghviorrfenEdu/view?usp=drive_link';
          g.tvName = 'preparation2';
        }
        break;
      case '192.168.1.63':
        {
          imgLinkOrg =
              'https://drive.google.com/file/d/1PJ0EhproXnoBN2QSBx8QTigTltKC0WgN/view?usp=drive_link';
          g.tvName = 'preparation3';
        }
        break;
      case '192.168.1.64':
        {
          imgLinkOrg =
              'https://drive.google.com/file/d/1AQ_BCMtpRvQEJ8GYlLOGyQr9u-5tD-qJ/view?usp=drive_link';
          g.tvName = 'cad';
        }
        break;
      case '192.168.1.65':
        {
          imgLinkOrg =
              'https://drive.google.com/file/d/13dT544GH46HJwXVIKApW_Wyrz21gBZkc/view?usp=drive_link';
          g.tvName = 'sample';
        }
        break;
      case '192.168.1.66':
        {
          //qc
          imgLinkOrg =
              'https://drive.google.com/file/d/1VT4_93iB2n8U1WqBFSSitVdAYT7vEvvg/view?usp=drive_link';
          g.tvName = 'control4';
        }
        break;
      case '192.168.1.68':
        {
          //planning
          imgLinkOrg =
              'https://drive.google.com/file/d/1DTBn5-HIKOw6vwitmKk3v85Fmo5MgaEH/view?usp=drive_link';
          g.tvName = 'control3';
        }
        break;

      default:
        {
          g.tvName = 'line';
        }
    }
    switch (g.tvName) {
      case 'line':
        {
          connected = await g.sqlProductionDB.initConnection();
          g.appSetting = await g.sqlProductionDB.getAppSetting();
          g.enableMoney = MyFuntions.parseBool(g.appSetting.getEnableMoney);
          await g.sqlETSDB.initConnection();

          g.isTVPlanning = false;
          if ((g.appSetting.getIpTvLine).toString().contains(g.ip)) {
            g.isTVLine = true;
            g.autochangeLine = false;
          } else {
            g.isTVLine = false;
          }

          g.currentLine = MyFuntions.setLineFollowIP(g.ip);
          g.appSetting.getLines.toString().split(',').forEach((element) {
            g.lines.add(int.parse(element));
          });

          g.currentIndexLine = g.lines.indexOf(g.currentLine);
          print(
              'ip : ${g.ip}    -    isTVLine :${g.isTVLine}    -       g.currentLine: ${g.currentLine}');

          g.sqlT01 =
              await g.sqlProductionDB.getT01InspectionData(g.currentLine);
          g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);
          g.chartUi = ChartUI.createChartUI(
              g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
          if (g.appSetting.getEnableETS != 0) {
            g.moDetails = await g.sqlETSDB.getAllMoDetails();
            g.sqlEmployees = await g.sqlETSDB.getEmployees();
            g.currentMoDetail = g.moDetails
                .firstWhere((element) => element.getLine == g.currentLine);
            g.processDetail =
                await g.sqlETSDB.getProcessDetail(g.currentMoDetail.getCnid);
            g.sqlSumEmpQty = await g.sqlETSDB
                .getSqlSumEmpQty(g.currentMoDetail.getMo, g.pickedDate);
            g.sqlSumNoQty = await g.sqlETSDB
                .getSqlSumNoQty(g.currentMoDetail.getMo, g.pickedDate);
            g.sqlCummulativeNoQty =
                await g.sqlETSDB.getSqlCummNoQty(g.currentMoDetail.getMo);
            g.workSummary = MyFuntions.summaryDailyDataETS();
          }
          Loader.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardSewing()),
          );
        }
        break;
      default:
        {
          g.imgDashboardLink = MyFuntions.getLinkImage(imgLinkOrg);
          Loader.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardImage()),
          );
        }
    }
  }

  showLoading() {
    return Loader.show(
      context,
      overlayColor: Colors.white,
      progressIndicator: SizedBox(
          width: 100,
          height: 200,
          child: Column(children: [
            Image.asset('assets/logo.png'),
            Image.asset('assets/loading.gif')
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: showLoading()));
  }
}
