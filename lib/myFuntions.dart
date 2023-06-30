import 'package:flutter/material.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/global.dart';

class MyFuntions {
  static List<WorkSummary> summaryData() {
    List<WorkSummary> result = [];
    g.sqlSumQty.forEach((element) {
      g.idEmpScaneds.add(element.getEmpId);
    });
    g.idEmpScaneds = g.idEmpScaneds.toSet().toList();

    g.idEmpScaneds.forEach((idEmpScaned) {
      final String currentName = g.sqlEmployees
          .firstWhere((emp) => emp.getEmpId == idEmpScaned)
          .getEmpName;
      final String currentEmpShortName = currentName;
      late WorkSummary workSummary;
      List<ProcessDetailQty> processDetailQtys = [];
      for (int i = 0; i < g.sqlSumQty.length; i++) {
        if (idEmpScaned == g.sqlSumQty[i].EmpId) {
          final int GxNo = g.sqlSumQty[i].getGxNo;
          final int qty = g.sqlSumQty[i].getSumQty;
          final String GxName = g.sqlMK026
              .firstWhere(
                  (element) => element.getGxNo == g.sqlSumQty[i].getGxNo)
              .getGxName;
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
    return result;
  }

  Future<bool> initDataStarUp() async {
    g.isMySqlConnected = await g.mySql.initConnection();
    if (g.isMySqlConnected) {
      g.sqlSumQty = await g.mySql.getSqlSumQty(g.currentLine);
      g.sqlMK026 = await g.mySql.getMK026(g.currentLine);
      g.sqlEmployees = await g.mySql.getEmployees();
      g.sqlMoInfo = await g.mySql.getMoInfo(g.currentLine);
      g.currentMO = g.sqlMoInfo.getMo;
      g.currentStyle = g.sqlMoInfo.getStyle;
    }
    g.workSummary = MyFuntions.summaryData();

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
}
