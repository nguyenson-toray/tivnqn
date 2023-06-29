import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/myFuntions.dart';
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

  Future<bool> initData() async {
    fluWakeLock.enable();
    g.isMySqlConnected = await g.mySql.initConnection();
    if (g.isMySqlConnected) {
      g.sqlSumQty = await g.mySql.getSqlSumQty(g.currentLine);
      g.sqlMK026 = await g.mySql.getMK026(g.currentLine);
      g.sqlEmployees = await g.mySql.getEmployees();
      g.sqlMoInfo = await g.mySql.getMoInfo();
      g.currentMO = g.sqlMoInfo
          .firstWhere((element) => element.getLine == g.currentLine)
          .getMo;
      g.currentStyle = g.sqlMoInfo
          .firstWhere((element) => element.getLine == g.currentLine)
          .getStyle;
    }
    g.workSummary = MyFuntions.summaryData();
    if (g.sqlSumQty.isNotEmpty) {
      Loader.hide();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardSewingLine()),
      );
    }
    return (g.sqlSumQty.isNotEmpty);
  }

  showLoading() {
    return Loader.show(
      context,
      overlayColor: g.isTV ? Colors.white : Colors.black54,
      progressIndicator: SizedBox(
          width: 100,
          height: 200,
          child: Column(children: [
            g.isTV ? Image.asset('assets/logo.png') : Container(),
            Image.asset('assets/loading.gif')
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: showLoading()));
  }
}
