import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:tivnqn/model/processDetail.dart';
import 'package:tivnqn/model/appSetting.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMoInfo.dart';
import 'package:tivnqn/model/sqlSumEmpQty.dart';
import 'package:tivnqn/model/sqlSumNoQty.dart';

class SqlETSDB {
  var connection = ConnectToSqlServerDirectly();
  final String ipLAN = '192.168.1.11';
  final String dbName = 'ETSDB_TI';
  final int port = 1433;
  final String instanceSql = 'MSSQLSERVER';
  final user = 'app';
  final pass = 'Toray@123';

  Future<bool> initConnection() async {
    bool isConnected = false;
    try {
      bool lanConnection = false;
      await Socket.connect(ipLAN, port, timeout: const Duration(seconds: 3))
          .then((socket) {
        // do what need to be done
        lanConnection = true;
        // Don't forget to close socket
        socket.destroy();
      });
      print('SqlETSDB checkLAN IP : $ipLAN  port : $port : $lanConnection');
      if (lanConnection)
        isConnected = await connection.initializeConnection(
          ipLAN,
          dbName,
          user,
          pass,
          instance: instanceSql,
        );

      if (!isConnected) {
        Fluttertoast.showToast(
            msg: "SQL Server not available !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }

    print('SqlETSDB initConnection : $isConnected');
    return isConnected;
  }

  Future<AppSetting> getSetting() async {
    String query =
        '''SELECT lines, timeChangeLine, timeReload, rangeDays, showNotification, notificationURL, showBegin, showDuration, chartBegin, chartDuration, ipTvLine 
FROM A_AppSetting''';
    late AppSetting result;
    var tempResult = [];
    var element;
    await connection.getRowsOfQueryResult(query).then((value) => {
          if (value.runtimeType == String)
            {print('ERROR')}
          else
            {
              tempResult = value.cast<Map<String, dynamic>>(),
              element = tempResult[0],
              result = AppSetting(
                lines: element['lines'],
                timeChangeLine: element['timeChangeLine'],
                timeReload: element['timeReload'],
                rangeDays: element['rangeDays'],
                showNotification: element['showNotification'],
                notificationURL: element['notificationURL'],
                showBegin: element['showBegin'],
                showDuration: element['showDuration'],
                chartBegin: element['chartBegin'],
                chartDuration: element['chartDuration'],
                ipTvLine: element['ipTvLine'],
              )
            }
        });
    return result;
  }

  Future<List<SqlEmployee>> getEmployees() async {
    String query = '''SELECT CODE, NAME
FROM dbo.T_YGDA
ORDER BY CODE ASC''';
    List<SqlEmployee> result = [];

    var tempResult;
    print('getEmployees : $query');
    try {
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    result.add(SqlEmployee(
                        empId: element['CODE'], empName: element['NAME'])),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }

    return result;
  }

  Future<String> getCnid(String mo) async {
    String cnid = '';
    String queryGetCnid = ''' SELECT TOP(1) Cnid
 FROM  T_ZdGxCheck 
 WHERE ZDCODE = '$mo'  
 ORDER BY CheckDate DESC''';

    try {
      await connection
          .getRowsOfQueryResult(queryGetCnid)
          .then((value) => {cnid = value[0]['Cnid']});
    } catch (e) {
      print(e.toString());
    }
    print('getCnid of MO: $mo => $cnid');
    return cnid;
  }

  Future<List<ProcessDetail>> getProcessDetail(String cnid) async {
    String query = '''  SELECT cnid, GxNO, GxCode, gxName
 FROM [ETSDB_TI].[dbo].tbSczzdGxDetail  
 WHERE cnid =  '$cnid' AND GxType = 'Sewing'
 ORDER BY GxNO ASC ''';

    List<ProcessDetail> result = [];
    var tempResult;
    print('getProcessDetail : $query');
    try {
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                g.processAll.clear(),
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    g.processAll.add(element['GxNO']),
                    result.add(ProcessDetail(
                        cind: cnid,
                        no: element['GxNO'],
                        code: element['GxCode'],
                        name: element['gxName'])),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }
    print(result.length);
    return result;
  }

  Future<SqlMoInfo> getMoInfo(int line) async {
    String query = '''SELECT line, mo, style, qty, TargetDay, LastProcess
FROM A_MoInfo
WHERE line = ${line}''';
    late SqlMoInfo result = SqlMoInfo(
        line: 1,
        mo: 'mo',
        style: 'style',
        qty: 1,
        targetDay: 1,
        lastProcess: 0);

    var tempResult;
    print('getMoInfo : $query');
    try {
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    result = SqlMoInfo(
                        line: element['line'],
                        mo: element['mo'],
                        style: element['style'],
                        qty: element['qty'],
                        targetDay: element['TargetDay'],
                        lastProcess: element['LastProcess']),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }
    print(result);
    return result;
  }

  Future<List<SqlSumEmpQty>> getSqlSumEmpQty(
      int line, String mo, DateTime date) async {
    String dateString = DateFormat(g.dateFormat).format(
      g.pickedDate,
    );
    String query = '''SELECT GxNo, EmpId,SUM(Qty) as Sum_Qty
FROM EmployeeDayData
WHERE  WorkLine = 'L$line' AND ZDCode = '${mo.trim()}'  AND CONVERT(date,WorkDate)=CONVERT(date,'${dateString}')
GROUP BY GxNo, EmpId
ORDER BY GxNo ASC''';
    List<SqlSumEmpQty> result = [];
    var tempResult;
    print('getSqlSumEmpQty : $query');
    try {
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    result.add(SqlSumEmpQty(
                        GxNo: element['GxNo'],
                        EmpId: element['EmpId'],
                        SumEmpQty: element['Sum_Qty'])),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }
    // print(result);
    return result;
  }

  Future<List<SqlSumNoQty>> getSqlSumNoQty(
      int line, String mo, DateTime date) async {
    String dateString = DateFormat(g.dateFormat).format(
      g.pickedDate,
    );
    String query = '''SELECT GxNo,SUM(Qty) as Sum_Qty
FROM EmployeeDayData
WHERE  WorkLine = 'L$line' AND ZDCode = '${mo.trim()}'  AND CONVERT(date,WorkDate)=CONVERT(date,'${dateString}')
GROUP BY GxNo
ORDER BY GxNo ASC''';
    List<SqlSumNoQty> result = [];
    var tempResult;
    print('getSqlSumNoQty : $query');
    try {
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    result.add(SqlSumNoQty(
                        GxNo: element['GxNo'], SumNoQty: element['Sum_Qty'])),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }

    return result;
  }
}
