import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/dashboard.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoaded = false;
  String functionSellected = '';
  FluWakeLock fluWakeLock = FluWakeLock();
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
      if (isLoaded) {
        Loader.hide();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    });
    super.initState();
  }

  Future<void> initData() async {
    print('Start Page - initData');
    fluWakeLock.enable();
    g.ip = (await NetworkInfo().getWifiIP())!;
    g.sqlETSDB.getSetting();
    if ((g.appSetting.getIpTvLine).toString().contains(g.ip!)) {
      g.isTVLine = true;
    } else
      g.isTVLine = false;
    g.currentLine = MyFuntions.setLineFollowIP(g.ip);
    print(
        'ip : ${g.ip}    -    isTVLine :${g.isTVLine}    -       g.currentLine: ${g.currentLine}');
    if (kDebugMode) {
      setState(() {
        g.currentLine = 8;
        g.isTVLine = false;
        // g.appSetting.setShowNotification = 0;
        g.autochangeLine = false;
      });
    }

    await g.sqlProductionDB.initConnection();
    await g.sqlETSDB.initConnection();
    await MyFuntions.loadDataSQL(1);
    await MyFuntions.loadDataSQL(2);
    g.workSummary = MyFuntions.summaryDailyDataETS();
    g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);
    g.chartUi = ChartUI.createChartUI(
        g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());

    // print('getIpTvLine : ${g.appSetting.getIpTvLine.toString()}');

    Loader.hide();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
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
