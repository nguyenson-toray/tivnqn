import 'dart:io';
import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMk026.dart';
import 'package:tivnqn/model/sqlMoInfo.dart';
import 'package:tivnqn/model/sqlSumQty.dart';

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
  Future<bool> initConnection() async {
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

  Future<List<SqlMoInfo>> getMoInfo() async {
    String query = '''SELECT line, mo, style, qty
FROM A_MoInfo
ORDER BY line''';
    List<SqlMoInfo> result = [];

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
                    result.add(SqlMoInfo(
                        line: element['line'],
                        mo: element['mo'],
                        style: element['style'],
                        qty: element['qty'])),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }

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

  Future<List<SqlMK026>> getMK026(int line) async {
    String query = '''SELECT GxNo, GxName, CardColor
FROM A_MK026
WHERE  Line = $line 
ORDER BY GxNo ASC''';
    List<SqlMK026> result = [];
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
                  result.add(SqlMK026(
                      GxNo: element['GxNo'],
                      GxName: element['GxName'],
                      CardColor: element['CardColor']))
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
