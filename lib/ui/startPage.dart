import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/dashboardSewingLine.dart';

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
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      if (isLoaded) {
        Loader.hide();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardSewingLine()),
        );
      }
    });
    super.initState();
  }

  Future<void> initData() async {
    fluWakeLock.enable();
    await MyFuntions.getSqlData();
    g.workSummary = MyFuntions.summaryDailyDataETS();
    g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);
    g.chartUi = ChartUI.createChartUI(
        g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
    Loader.hide();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardSewingLine()),
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
