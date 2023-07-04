import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/model/chartData.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlT01.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/global.dart';

class MyFuntions {
  static List<WorkSummary> summaryDailyDataETS() {
    g.processScaned.clear();
    g.processNotScan.clear();
    g.idEmpScaneds.clear();

    List<WorkSummary> result = [];
    g.sqlSumQty.forEach((element) {
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
      final String currentEmpShortName = currentName;
      WorkSummary workSummary = WorkSummary(
          shortName: 'shortName',
          processDetailQtys: [
            ProcessDetailQty(GxNo: 0, GxName: 'GxName', qty: 0)
          ]);
      List<ProcessDetailQty> processDetailQtys = [];
      for (int i = 0; i < g.sqlSumQty.length; i++) {
        if (idEmpScaned == g.sqlSumQty[i].EmpId) {
          final int GxNo = g.sqlSumQty[i].getGxNo;
          final int qty = g.sqlSumQty[i].getSumQty;
          final String GxName = g.processDetail
              .firstWhere((element) => element.getNo == g.sqlSumQty[i].getGxNo)
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

  static Future<bool> getSqlData() async {
    print('getSqlData : g.needLoadAllData = ${g.needLoadAllData}');
    g.isMySqlConnected =
        await g.mySql.initConnection(g.dbETSDB_TI, g.sqlUser, g.sqlPass);
    if (g.isMySqlConnected) {
      if (g.needLoadAllData) {
        // g.sqlMK026 = await g.mySql.getMK026(g.currentLine);
        g.sqlEmployees = await g.mySql.getEmployees();
        g.sqlMoInfo = await g.mySql.getMoInfo(g.currentLine);
        g.currentMO = g.sqlMoInfo.getMo;
        g.currentStyle = g.sqlMoInfo.getStyle;
        g.currentCnid = await g.mySql.getCnid(g.currentMO);
        g.processDetail = await g.mySql.getProcessDetail(g.currentCnid);
      }
      g.sqlSumQty = await g.mySql.getSqlSumQty(g.currentLine);
    }
    g.isMySqlConnected =
        await g.mySql.initConnection(g.dbProduction, g.sqlUser, g.sqlPass);
    if (g.isMySqlConnected) {
      g.sqlT01 = await g.mySql.getT01InspectionData(g.currentLine);
    }
    return (g.sqlSumQty.isNotEmpty);
  }

  static Color getColorByQty(int qty, int target) {
    Color result = Colors.yellow;
    int ration = (qty / target * 100).round();
    if (ration <= 25)
      result = Colors.red;
    else if (ration <= 50)
      result = Colors.orange;
    else if (ration <= 75)
      result = Colors.yellow;
    else
      result = Colors.green;
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
}
