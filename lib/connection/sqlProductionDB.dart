import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:tivnqn/model/planning.dart';
import 'package:tivnqn/model/sqlT01.dart';
import 'package:tivnqn/model/sqlT01Full.dart';

class SqlProductionDB {
  var connection = ConnectToSqlServerDirectly();
  final String ipLAN = '192.168.1.11';
  final String dbName = 'Production';
  final int port = 1433;
  final String instanceSql = 'MSSQLSERVER';
  final user = 'app';
  final pass = 'Toray@123';
  Future<bool> checkLAN() async {
    bool lanConnection = false;
    const String ipLAN = '192.168.1.11';
    const int port = 1433;
    await Socket.connect(ipLAN, port, timeout: const Duration(seconds: 3))
        .then((socket) {
      // do what need to be done
      print('Connection to IP LAN : $ipLAN:$port OK');
      lanConnection = true;
      // Don't forget to close socket
      socket.destroy();
    });
    print(
        'SqlProductionDB checkLAN IP : $ipLAN  port : $port : $lanConnection');
    return lanConnection;
  }

  Future<bool> initConnection() async {
    bool isConnected = false;
    try {
      bool lanConnection = await checkLAN();
      if (lanConnection) {
        isConnected = await connection.initializeConnection(
          ipLAN,
          dbName,
          user,
          pass,
          instance: instanceSql,
        );
      }
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
    print('SqlProductionDB initConnection : $isConnected');
    return isConnected;
  }

  Future<List<SqlT01>> getT01InspectionData(int line) async {
    List<SqlT01> result = [];
    final String query = '''SELECT X02, X06, X07, X08, X09
FROM [Production].[dbo].[T01_1st inspection data]
WHERE X01 = $line and [2nd] =1 AND ( X02 >= DATEADD (day,-${g.config.getProductionChartRangeDay}, getdate()) )
ORDER BY X02 ASC
    ''';
    print('getT01InspectionData $line ');
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
      print('getInspectionData --> Exception : $e');
    }
    return result;
  }

  Future<List<SqlT01Full>> getT01InspectionDataFull(int rangeDays) async {
    List<SqlT01Full> result = [];
    List<Map<String, dynamic>> tempResult = [];
    late DateTime beginDate;
    beginDate = DateTime.now().subtract(Duration(days: rangeDays));
    late DateTime day;
    final String query =
        '''select * from [Production].[dbo].[T01_1st inspection data]''';
    print(
        'select all Table 01InspectionData   ( ${rangeDays.toString()} days : from ${DateFormat(g.dateFormat).format(
      beginDate,
    )} to today !!!');
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
                    rowData = SqlT01Full.fromMap(element),
                    day = DateTime.parse(rowData.getX02.toString()),
                    if (day.isAfter(beginDate))
                      {
                        result.add(rowData),
                      }
                  }
              }
          });
    } catch (e) {
      print('getInspectionData --> Exception : ' + e.toString());
    }
    return result;
  }
}
