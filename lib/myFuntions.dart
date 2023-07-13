import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:tivnqn/model/chartData.dart';
import 'package:tivnqn/model/sqlT01.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/global.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class MyFuntions {
  static List<WorkSummary> summaryDailyDataETS() {
    g.processScaned.clear();
    g.processNotScan.clear();
    g.idEmpScaneds.clear();

    List<WorkSummary> result = [];
    g.sqlSumEmpQty.forEach((element) {
      g.idEmpScaneds.add(element.getEmpId);
      g.processScaned.add(element.getGxNo);
    });
    g.idEmpScaneds = g.idEmpScaneds.toSet().toList();
    g.processScaned = g.processScaned.toSet().toList();
    g.processNotScan =
        g.processAll.toSet().difference(g.processScaned.toSet()).toList();
    g.idEmpScaneds.forEach((idEmpScaned) {
      final String currentName = g.sqlEmployees
          .firstWhere((emp) => emp.getEmpId == idEmpScaned)
          .getEmpName;
      var names = currentName.split(' ');
      final String currentEmpShortName =
          names[names.length - 2] + " " + names.last;
      WorkSummary workSummary = WorkSummary(
          shortName: 'shortName',
          processDetailQtys: [
            ProcessDetailQty(GxNo: 0, GxName: 'GxName', qty: 0)
          ]);
      List<ProcessDetailQty> processDetailQtys = [];
      for (int i = 0; i < g.sqlSumEmpQty.length; i++) {
        if (idEmpScaned == g.sqlSumEmpQty[i].EmpId) {
          final int GxNo = g.sqlSumEmpQty[i].getGxNo;
          final int qty = g.sqlSumEmpQty[i].getSumEmpQty;
          final String GxName = g.processDetail
              .firstWhere(
                  (element) => element.getNo == g.sqlSumEmpQty[i].getGxNo)
              .getName;
          final processDetailQty =
              ProcessDetailQty(GxNo: GxNo, GxName: GxName, qty: qty);
          processDetailQtys.add(processDetailQty);
          workSummary = WorkSummary(
              shortName: currentEmpShortName,
              processDetailQtys: processDetailQtys);
        }
      }
      result.add(workSummary);
    });
    print('summaryDailyDataETS => ${result.length}');
    return result;
  }

  static Future<bool> loadDataSQL(int type) async {
    print('loadDataSQL : ${type}');
    g.isLoading = true;
    switch (type) {
      case 1: //load production db
        {
          g.sqlT01 =
              await g.sqlProductionDB.getT01InspectionData(g.currentLine);
        }
        break;
      case 2: // load all ETS
        {
          g.sqlEmployees = await g.sqlETSDB.getEmployees();
          g.sqlMoInfo = await g.sqlETSDB.getMoInfo(g.currentLine);
          g.currentMO = g.sqlMoInfo.getMo;
          g.currentStyle = g.sqlMoInfo.getStyle;
          g.currentCnid = await g.sqlETSDB.getCnid(g.currentMO);
          g.processDetail = await g.sqlETSDB.getProcessDetail(g.currentCnid);

          g.lines.clear();
          g.appSetting.getLines.toString().split(',').forEach((element) {
            g.lines.add(int.parse(element));
          });
          g.currentIndexLine = g.lines.indexOf(g.currentLine);

          g.sqlSumEmpQty =
              await g.sqlETSDB.getSqlSumEmpQty(g.sqlMoInfo.getMo, g.pickedDate);
          g.sqlSumNoQty =
              await g.sqlETSDB.getSqlSumNoQty(g.sqlMoInfo.getMo, g.pickedDate);
        }
        break;
      case 3: // load line data , setting
        {
          await g.sqlETSDB.getSetting();
          g.lines.clear();
          g.appSetting.getLines.toString().split(',').forEach((element) {
            g.lines.add(int.parse(element));
          });

          g.currentIndexLine = g.lines.indexOf(g.currentLine);
          g.sqlSumEmpQty =
              await g.sqlETSDB.getSqlSumEmpQty(g.sqlMoInfo.getMo, g.pickedDate);
          g.sqlSumNoQty =
              await g.sqlETSDB.getSqlSumNoQty(g.sqlMoInfo.getMo, g.pickedDate);
        }
        break;
      default:
    }
    g.isLoading = false;
    return (g.sqlSumEmpQty.isNotEmpty);
  }

  static int setLineFollowIP(String ip) {
    int line = 1;
    switch (ip) {
      case '192.168.1.71':
        {
          line = 1;
        }
        break;
      case '192.168.1.72':
        {
          line = 2;
        }
        break;
      case '192.168.1.73':
        {
          line = 3;
        }
        break;
      case '192.168.1.74':
        {
          line = 4;
        }
        break;
      case '192.168.1.75':
        {
          line = 5;
        }
        break;
      case '192.168.1.76':
        {
          line = 6;
        }
        break;
      case '192.168.1.77':
        {
          line = 7;
        }
        break;
      case '192.168.1.78':
        {
          line = 8;
        }
        break;
      case '192.168.1.79':
        {
          line = 8;
        }
        break;
      default:
        line = 1;
    }
    return line;
  }

  static Color getColorByQty(int qty, int target) {
    Color result = Colors.yellow;
    int ration = (qty / target * 100).round();
    if (ration <= 25)
      result = Colors.redAccent;
    else if (ration <= 50)
      result = Colors.orangeAccent;
    else if (ration <= 75)
      result = Colors.yellowAccent;
    else
      result = Colors.greenAccent;
    return result;
  }

  static Color getColorByQty2(int qty, int target) {
    Color result = Color.fromRGBO(248, 240, 168, 1);
    int ration = (qty / target * 100).round();
    if (ration <= 25)
      result = const Color.fromARGB(255, 245, 31, 16);
    else if (ration <= 50)
      result = Colors.orange;
    else if (ration <= 75)
      result = const Color.fromARGB(255, 248, 225, 19);
    else
      result = const Color.fromARGB(255, 62, 243, 68);
    return result;
  }

  static bool parseBool(int integer) {
    if (integer > 0)
      return true;
    else
      return false;
  }

  static List<ChartData> sqlT01ToChartData(List<SqlT01> dataInput) {
    List<SqlT01> input = [...dataInput];
    List<ChartData> result = [];
    List<String> dates = [];
    input.forEach((element) {
      dates.add(element.getX02);
    });
    dates = dates.toSet().toList();
    dates.forEach((dateString) {
      DateTime currentDate = DateFormat(g.dateFormat).parse(dateString);
      num qty1st = 0;
      num qty1stOK = 0;
      num qty1stNOK = 0;
      num qtyAfterRepaire = 0;
      num qtyOKAfterRepaire = 0;
      num rationDefect1st = 0;
      num rationDefectAfterRepaire = 0;
      input.forEach((data) {
        if (dateString == data.getX02) {
          qty1st += data.getX06;
          qty1stOK += data.getX07;
          qtyAfterRepaire += data.getX08;
          qtyOKAfterRepaire += data.getX09;
        }
        qty1stNOK = qty1st - qty1stOK;
        rationDefect1st = double.parse((qty1stNOK / qty1st).toStringAsFixed(4));
        rationDefectAfterRepaire = double.parse(
            ((qtyAfterRepaire - qtyOKAfterRepaire) / qtyAfterRepaire)
                .toStringAsFixed(4));
      });
      ChartData data = ChartData(
          date: dateString,
          qty1st: qty1st,
          qty1stOK: qty1stOK,
          qty1stNOK: qty1stNOK,
          qtyAfterRepaire: qtyAfterRepaire,
          qtyOKAfterRepaire: qtyOKAfterRepaire,
          rationDefect1st: rationDefect1st,
          rationDefectAfterRepaire: rationDefectAfterRepaire);
      result.add(data);
    });
    return result;
  }

  static String getLinkImageNotification(String orgLink) {
    // https: //drive.google.com/file/d/1-3zgxOg_AyWoTkEu8F21WvNX-kcRwChB/view?usp=drive_link
    // file ID : 1-3zgxOg_AyWoTkEu8F21WvNX-kcRwChB
    // -> https://drive.google.com/uc?export=view&id=<FILE_ID>
    // https://drive.google.com/uc?export=view&id=1-3zgxOg_AyWoTkEu8F21WvNX-kcRwChB
    String link = 'https://drive.google.com/uc?export=view&id=';
    String fileId = orgLink.substring(32, 65);
    link += fileId;
    print('org link : ${orgLink}');
    print('-> : $link');
    return link;
  }

  static Future<void> playAudio() async {
    AssetsAudioPlayer.newPlayer().open(Audio("assets/notification_sound.wav"),
        autoStart: true, volume: 1.0);
  }
}
