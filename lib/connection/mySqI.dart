import 'dart:io';
import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/processDetail.dart';
import 'package:tivnqn/model/setting.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMoInfo.dart';
import 'package:tivnqn/model/sqlSumQty.dart';
import 'package:tivnqn/model/sqlT01.dart';

class MySql {
  bool isLoading = false;
  var connection = ConnectToSqlServerDirectly();
  final String ipLAN = '192.168.1.11';
  final String dbName = 'ETSDB_TI';
  final int port = 1433;
  final String instanceSql = 'MSSQLSERVER';
  final user = 'readonly';
  final pass = 'Toray@123';
  final String tbReturnWork = 'tbReturnWork';
  final String tblineDayData = 'tblineDayData';
  final String tbBsReturnWorkCode = 'tbBsReturnWorkCode';
  bool lanConnectionAvailable = false;
  Future<bool> initConnection(String dbName, user, pass) async {
    bool isConnected = false;
    await Socket.connect(ipLAN, port, timeout: const Duration(seconds: 3))
        .then((socket) {
      // do what need to be done
      print('Connection to IP LAN : $ipLAN:$port OK');
      lanConnectionAvailable = true;
      // Don't forget to close socket
      socket.destroy();
    }).catchError((error) {});
    if (!lanConnectionAvailable) {
      Fluttertoast.showToast(
          msg: "LAN connection to SQL Server ETSDB_TI not available !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    try {
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
      print('initializeConnection - $ipLAN FAILSE :$e');
    }
    return isConnected;
  }

  Future<Setting> getSetting() async {
    String query =
        '''SELECT reloadTimeSeconds, showNotification, text, imgURL, showBegin, showEnd, chartBegin, chartEnd, rangeDay
FROM A_Setting''';
    late Setting result = Setting(
        reloadTimeSeconds: 30,
        showNotification: 0,
        text: 'text',
        imgURL: 'imgURL',
        showBegin: 'showBegin',
        showEnd: 'showEnd',
        chartBegin: 'chartBegin',
        chartEnd: 'chartEnd',
        rangeDay: 14);
    var tempResult = [];
    var element;
    await connection.getRowsOfQueryResult(query).then((value) => {
          if (value.runtimeType == String)
            {
              //error
            }
          else
            {
              tempResult = value.cast<Map<String, dynamic>>(),
              element = tempResult[0],
              result = Setting(
                  reloadTimeSeconds: element['reloadTimeSeconds'],
                  showNotification: element['showNotification'],
                  text: element['text'],
                  imgURL: element['imgURL'],
                  showBegin: element['showBegin'],
                  showEnd: element['showEnd'],
                  chartBegin: element['chartBegin'],
                  chartEnd: element['chartEnd'],
                  rangeDay: element['rangeDay'])
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
    String query = '''SELECT line, mo, style, qty, TargetDay
FROM A_MoInfo
WHERE line = ${line}''';
    late SqlMoInfo result =
        SqlMoInfo(line: 1, mo: 'mo', style: 'style', qty: 1, targetDay: 1);

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
                        targetDay: element['TargetDay']),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }
    print(result);
    return result;
  }

  Future<List<SqlSumQty>> getSqlSumQty(int line) async {
    String query = '''SELECT GxNo, EmpId,SUM(Qty) as Sum_Qty
FROM EmployeeDayData
WHERE  WorkLine = 'L$line'  AND CONVERT(date,WorkDate)=CONVERT(date,getdate())
GROUP BY GxNo, EmpId
ORDER BY GxNo ASC''';
    List<SqlSumQty> result = [];
    var tempResult;
    print('getSqlSumQty : $query');
    try {
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    result.add(SqlSumQty(
                        GxNo: element['GxNo'],
                        EmpId: element['EmpId'],
                        SumQty: element['Sum_Qty'])),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }
    // print(result);
    return result;
  }

  List<Map<int, String>> geDefectCodeNames() {
    String queryString =
        'SELLECT ReturnWorkCode, ReturnWorkName FROM dbo.$tbBsReturnWorkCode';
    List<Map<int, String>> tempResult = [];
    connection.getRowsOfQueryResult(queryString).then((value) => {
          if (value.runtimeType == String)
            {
              //error
            }
          else
            {
              tempResult = value.cast<Map<int, String>>(),
              tempResult.forEach((element) {
                int returnWorkCode =
                    int.parse(element['ReturnWorkCode'].toString());
                String returnWorkName = element['ReturnWorkName'].toString();
                var map = {returnWorkCode, returnWorkName};
                tempResult.add(map as Map<int, String>);
              })
            }
        });
    return tempResult;
  }

  Future<List<SqlT01>> getT01InspectionData(int line) async {
    List<SqlT01> result = [];
    List<Map<String, dynamic>> tempResult = [];
    final String query = '''SELECT X02, X06, X07, X08, X09
FROM [Production].[dbo].[T01_1st inspection data]
WHERE X01 = ${line} and [2nd] =1 AND ( X02 >= DATEADD (day,-${g.setting.getRangeDay}, getdate()) )
ORDER BY X02 ASC
    ''';
    print('getT01InspectionData ${line} ');
    print(query);
    try {
      var tempResult = [];
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {
                //error
              }
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    result.add(SqlT01(
                        x02: element['X02'],
                        x06: element['X06'],
                        x07: element['X07'],
                        x08: element['X08'],
                        x09: element['X09']))
                  }
              }
          });
    } catch (e) {
      print('getInspectionData --> Exception : ' + e.toString());
    }
    return result;
  }
}
