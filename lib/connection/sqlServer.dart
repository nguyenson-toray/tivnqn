import 'dart:io';
import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/DailySumQty.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMk026.dart';
import 'package:tivnqn/model/sqlSumQty.dart';

class SqlTIVNQN {
  bool isLoading = false;
  var connection = ConnectToSqlServerDirectly();
  final String ipLAN = '192.168.1.11';
  final String dbName = 'TIVNQN';
  final int port = 1433;
  final String instanceSql = 'MSSQLSERVER';
  final user = 'app';
  final pass = 'Toray@123';
  final String tableMOInfo = 'MOInfo';
  final String tableDailyDataLine8 = 'DailyDataLine8';
  bool lanConnectionAvailable = false;

  Future<bool> initConnection() async {
    await Socket.connect('$ipLAN', port, timeout: Duration(seconds: 3))
        .then((socket) {
      // do what need to be done
      print('Connection to IP LAN : $ipLAN:$port OK');
      lanConnectionAvailable = true;
      // Don't forget to close socket
      socket.destroy();
    }).catchError((error) {});
    if (!lanConnectionAvailable) {
      Fluttertoast.showToast(
          msg: "LAN connection to SQL Server TIVNQN not available !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    try {
      g.isSqlConnected = await connection.initializeConnection(
        ipLAN,
        dbName,
        user,
        pass,
        instance: instanceSql,
      );
      if (!g.isSqlConnected) {
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
      print('initializeConnection - $ipLAN FAILSE :' + e.toString());
    }
    return g.isSqlConnected;
  }

  Future<List<DailySumQty>> getDailyDataLine(int lineNumber) async {
    List<DailySumQty> dailyDataLine = [];
    List<Map<String, dynamic>> tempResult = [];
    final String query = '''select * from [DailyDataLine$lineNumber]
    ORDER BY No ASC
    ''';
    try {
      var rowData;
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    rowData = DailySumQty.fromMap(element),
                    dailyDataLine.add(rowData),
                  }
              }
          });
    } catch (e) {
      print('getInspectionData --> Exception : ' + e.toString());
    }
    return dailyDataLine;
  }
}

class SqlETSDB_TI {
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
  Future<bool> initConnection() async {
    await Socket.connect('$ipLAN', port, timeout: Duration(seconds: 3))
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
      g.isSqlConnected = await connection.initializeConnection(
        ipLAN,
        dbName,
        user,
        pass,
        instance: instanceSql,
      );
      if (!g.isSqlConnected) {
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
      print('initializeConnection - $ipLAN FAILSE :' + e.toString());
    }
    return g.isSqlConnected;
  }

  List<SqlEmployee> getEmployees() {
    String query = '''SELECT CODE, NAME
FROM dbo.T_YGDA
ORDER BY CODE ASC''';
    List<SqlEmployee> result = [];
    List<Map<String, String>> tempResult = [];
    connection.getRowsOfQueryResult(query).then((value) => {
          if (value.runtimeType == String)
            {
              //error
            }
          else
            {
              tempResult = value.cast<Map<String, String>>(),
              tempResult.forEach((element) {
                final String id = element['CODE'].toString();
                final String name = element['NAME'].toString();
                var emp = SqlEmployee(empId: id, empName: name);
                result.add(emp);
              })
            }
        });
    return result;
  }

  List<SqlMK026> getMK026(int line) {
    String query = '''SELECT OpNo, OpName
FROM MK026
WHERE  Line = $line 
ORDER BY OpNo ASC''';
    List<SqlMK026> result = [];
    List<Map<int, String>> tempResult = [];
    connection.getRowsOfQueryResult(query).then((value) => {
          if (value.runtimeType == String)
            {
              //error
            }
          else
            {
              tempResult = value.cast<Map<String, String>>(),
              tempResult.forEach((element) {
                final int no = int.parse(element['OpNo']!);
                final String name = element['OpName'].toString();
                var op = SqlMK026(opNo: no, opName: name);
                result.add(op);
              })
            }
        });
    return result;
  }

  List<SqlSumQty> getSqlSumQty(int line) {
    String query = '''SELECT GxNo, EmpId,SUM(Qty) as Sum_Qty
FROM EmployeeDayData
WHERE  WorkLine = $line  AND CONVERT(date,WorkDate)=CONVERT(date,getdate())
GROUP BY GxNo ,EmpId
ORDER BY GxNo ASC''';
    List<SqlSumQty> result = [];
    List<Map<int, dynamic>> tempResult = [];
    connection.getRowsOfQueryResult(query).then((value) => {
          if (value.runtimeType == String)
            {
              //error
            }
          else
            {
              tempResult = value.cast<Map<String, dynamic>>(),
              for (var element in tempResult)
                {
                  result.add(
                    SqlSumQty(
                        opNo: int.parse(element['GxNo']!),
                        EmpId: element['EmpId']!,
                        sumQty: int.parse(element['Sum_Qty']!)),
                  )
                }
            }
        });
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
}
