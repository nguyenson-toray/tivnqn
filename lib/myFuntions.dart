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
      final String currentEmpShortName = currentName.split(' ').last;
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
}
