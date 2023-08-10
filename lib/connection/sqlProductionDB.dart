import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tivnqn/global.dart';
import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:tivnqn/model/planning.dart';
import 'package:tivnqn/model/sqlT01.dart';

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
WHERE X01 = $line and [2nd] =1 AND ( X02 >= DATEADD (day,-${g.appSetting.getRangeDays}, getdate()) )
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

  Future<List<Planning>> getPlanning() async {
    String query =
        '''SELECT line,brand, style, quantity, beginDate, endDate, comment, description
        FROM [Production].[dbo].[A_Planning]''';
    List<Planning> result = [];
    var tempResult;
    print('getPlanning : $query');
    try {
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    result.add(
                      Planning(
                        line: element['line'],
                        brand: element['brand'] != null ? element['brand'] : '',
                        style: element['style'] != null ? element['style'] : '',
                        desc: element['description'] != null
                            ? element['description']
                            : '',
                        quantity: element['quantity'] != null
                            ? element['quantity']
                            : 0,
                        beginDate: DateTime.parse(element['beginDate']),
                        endDate: DateTime.parse(element['endDate']),
                        comment: element['comment'] != null
                            ? element['comment']
                            : '',
                      ),
                    )
                  }
              }
          });
      print(result);
    } catch (e) {
      print(e.toString());
    }

    return result;
  }
}
