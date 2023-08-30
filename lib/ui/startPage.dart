import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:restart_app/restart_app.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';
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
  String functionSellected = '';
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

    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      if (connected && isLoaded) {
        Loader.hide();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardSewing()),
        );
      }
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
    connected = await g.sqlProductionDB.initConnection();
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
    g.appSetting = await g.sqlProductionDB.getAppSetting();
    g.enableMoney = MyFuntions.parseBool(g.appSetting.getEnableMoney);
    await g.sqlETSDB.initConnection();

    g.ip = (await NetworkInfo().getWifiIP())!;
    if (kDebugMode) {
      setState(() {
        g.ip = '192.168.1.81';
        g.appSetting.setEnableChartPlanningUI = 0;
        g.enableMoney = false;
        g.appSetting.setEnableETS = 0;
      });
    }
    print('g.ip : ${g.ip} ');
    if (g.ip == g.appSetting.getIpTvPlanning) {
      g.isTVPlanning = true;
      if (g.appSetting.getEnableChartPlanningUI != 0) {
        g.sqlPlanning = await g.sqlProductionDB.getPlanning();
      }
    } else {
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

      g.sqlT01 = await g.sqlProductionDB.getT01InspectionData(g.currentLine);
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
    }

    Loader.hide();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => !g.isTVPlanning
              ? DashboardSewing()
              : g.appSetting.getEnableChartPlanningUI != 0
                  ? DashboardPlanning()
                  : DashboardPlanningImage()),
    );
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
