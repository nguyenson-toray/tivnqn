import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:restart_app/restart_app.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/preparation/.chartDataPCutting.dart';
import 'package:tivnqn/model/preparation/chartDataPInspection.dart';
import 'package:tivnqn/model/preparation/chartDataPRelaxation.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/dashboardImage.dart';
import 'package:tivnqn/ui/dashboardPCutting.dart';
import 'package:tivnqn/ui/dashboardPDispatch.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/ui/dashboardSewing.dart';
import 'package:tivnqn/ui/dashboardPInspectionRelaxation.dart';
import 'dart:io';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoaded = false;
  String imgLinkOrg = '';
  String title = '';

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
    connected = await g.sqlApp.initConnection();
    switch (g.ip) {
      case '192.168.1.61':
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
          g.tvName = 'preparation1';
        }
        break;
      case '192.168.1.62':
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

          g.tvName = 'preparation2';
        }
        break;
      case '192.168.1.63':
        {
          g.pDispatchs = await g.sqlApp.sellectPDispatch();

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
          title = 'SAMPLE PLANNING';
        }
        break;
      case '192.168.1.66':
        {
          //qc
          imgLinkOrg =
              'https://drive.google.com/file/d/1VT4_93iB2n8U1WqBFSSitVdAYT7vEvvg/view?usp=drive_link';
          g.tvName = 'control4';
          title = 'QC';
        }
        break;
      case '192.168.1.68':
        {
          //planning
          imgLinkOrg =
              'https://drive.google.com/file/d/1DTBn5-HIKOw6vwitmKk3v85Fmo5MgaEH/view?usp=drive_link';
          g.tvName = 'control3';
          title = 'PRODUCTION PLANNING';
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
          if (g.ip == '192.168.1.73' || g.ip == '192.168.1.74') {
            setState(() {
              g.appSetting.setEnableETS = 1;
            });
          }
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
        break;
      case 'preparation1':
        {
          Loader.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashBoardPInspectionRelaxation()),
          );
        }
      case 'preparation2':
        {
          Loader.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPCutting()),
          );
        }
      case 'preparation3':
        {
          Loader.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPDispatch()),
          );
        }
      case 'cad':
        {
          exit(0);
        }
      default:
        {
          Loader.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardImage(
                    title: title,
                    linkImageDirectly: MyFuntions.getLinkImage(imgLinkOrg))),
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
