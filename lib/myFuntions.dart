import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/model/chartData.dart';
import 'package:tivnqn/model/sqlT01.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/global.dart';

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
          g.appSetting = await g.sqlETSDB.getSetting();
          g.lines.clear();
          g.appSetting.getLines.toString().split(',').forEach((element) {
            g.lines.add(int.parse(element));
          });
          g.currentIndexLine = g.lines.indexOf(g.currentLine);

          g.sqlSumEmpQty = await g.sqlETSDB
              .getSqlSumEmpQty(g.currentLine, g.sqlMoInfo.getMo, g.pickedDate);
          g.sqlSumNoQty = await g.sqlETSDB
              .getSqlSumNoQty(g.currentLine, g.sqlMoInfo.getMo, g.pickedDate);
        }
        break;
      case 3: // load line data
        {
          g.appSetting = await g.sqlETSDB.getSetting();
          g.lines.clear();
          g.appSetting.getLines.toString().split(',').forEach((element) {
            g.lines.add(int.parse(element));
          });
          g.currentIndexLine = g.lines.indexOf(g.currentLine);
          g.sqlSumEmpQty = await g.sqlETSDB
              .getSqlSumEmpQty(g.currentLine, g.sqlMoInfo.getMo, g.pickedDate);
          g.sqlSumNoQty = await g.sqlETSDB
              .getSqlSumNoQty(g.currentLine, g.sqlMoInfo.getMo, g.pickedDate);
        }
        break;
      default:
    }
    g.isLoading = false;
    return (g.sqlSumEmpQty.isNotEmpty);
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
      result = Color.fromARGB(255, 250, 181, 181);
    else if (ration <= 50)
      result = Color.fromARGB(255, 250, 221, 183);
    else if (ration <= 75)
      result = Color.fromARGB(255, 245, 245, 186);
    else
      result = Color.fromARGB(255, 183, 245, 215);
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
    String link = 'https://drive.google.com/uc?export=view&id=';
    String temp1 = orgLink.split('https://drive.google.com/file/d/')[0];
    String fileId = temp1.split('/')[0];
    link += fileId;
    print('getLinkImageNotification : $orgLink');
    print('-> : $link');
    return link;
  }
}
