import 'dart:io';

import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:tivnqn/model/configs.dart';
import 'package:tivnqn/model/preparation/pCutting.dart';
import 'package:tivnqn/model/preparation/pDispatch.dart';
import 'package:tivnqn/model/preparation/pInspectionFabric.dart';
import 'package:tivnqn/model/preparation/pRelaxationFabric.dart';

class SqlApp {
  var connection = ConnectToSqlServerDirectly();
  final String ipLAN = '192.168.1.11';
  final String dbName = 'App';
  final String instanceSql = 'MSSQLSERVER';
  final user = 'app';
  final pass = 'Toray@123';
  Future<bool> checkLAN() async {
    bool lanConnection = false;

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
    } catch (e) {
      print(e);
    }
    print('Sql-App-DB initConnection : $isConnected');
    return isConnected;
  }

  Future<List<Configs>> sellectConfigs() async {
    List<Configs> result = [];
    List<Map<String, dynamic>> tempResult = [];
    final String query = '''select * from [App].[dbo].[Configs] ''';
    print('Query : $query  ');
    try {
      var rowData;
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('=> ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    rowData = Configs.fromMap(element),
                    result.add(rowData),
                  }
              }
          });
    } catch (e) {
      print('sellectConfigs --> Exception : ' + e.toString());
    }
    return result;
  }

  Future<List<PCutting>> sellectPCutting() async {
    List<PCutting> result = [];
    List<Map<String, dynamic>> tempResult = [];

    final String query = '''select * from [App].[dbo].[PCutting]
        WHERE CAST(date AS DATE) = CAST(GETDATE() AS DATE) 
        ''';
    print('Query : $query  ');
    try {
      var rowData;
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('=> ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    print(element),
                    rowData = PCutting.fromMap(element),
                    result.add(rowData),
                  }
              }
          });
    } catch (e) {
      print('sellectPCutting --> Exception : ' + e.toString());
    }
    return result;
  }

  Future<List<PDispatch>> sellectPDispatch() async {
    List<PDispatch> result = [];
    List<Map<String, dynamic>> tempResult = [];

    final String query = '''select * from [App].[dbo].[PDispatch]
        WHERE CAST(date AS DATE) = CAST(GETDATE() AS DATE) 
        ''';
    print('Query : $query  ');
    try {
      var rowData;
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('=> ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    rowData = PDispatch.fromMap(element),
                    result.add(rowData),
                  }
              }
          });
    } catch (e) {
      print('sellect PDispatch --> Exception : ' + e.toString());
    }
    return result;
  }

  Future<List<PInspectionFabric>> sellectPInspectionFabric() async {
    List<PInspectionFabric> result = [];
    List<Map<String, dynamic>> tempResult = [];

    final String query = '''select * from [App].[dbo].[PInspectionFabric]
        WHERE CAST(date AS DATE) = CAST(GETDATE() AS DATE) 
        ''';
    print('Query : $query  ');
    try {
      var rowData;
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('=> ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    print(element),
                    rowData = PInspectionFabric.fromMap(element),
                    result.add(rowData),
                  }
              }
          });
    } catch (e) {
      print('sellect PInspectionFabric --> Exception : ' + e.toString());
    }
    return result;
  }

  Future<List<PRelaxationFabric>> sellectPRelaxationFabric() async {
    List<PRelaxationFabric> result = [];
    List<Map<String, dynamic>> tempResult = [];

    final String query = '''select * from [App].[dbo].[PRelaxationFabric]
        WHERE CAST(date AS DATE) = CAST(GETDATE() AS DATE) 
        ''';
    print('Query : $query  ');
    try {
      var rowData;
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('=> ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                print(tempResult),
                for (var element in tempResult)
                  {
                    // print(element),
                    rowData = PRelaxationFabric.fromMap(element),
                    result.add(rowData),
                  }
              }
          });
    } catch (e) {
      print('sellect PRelaxationFabric --> Exception : ' + e.toString());
    }
    return result;
  }
}
