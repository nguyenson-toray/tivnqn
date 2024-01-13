// import 'package:flutter/material.dart';
// import 'package:mssql_connection/mssql_connection.dart';
// import 'package:intl/intl.dart';
// import 'package:tivnqn/global.dart';
// import 'package:tivnqn/model/configs.dart';
// import 'package:tivnqn/model/preparation/pCutting.dart';
// import 'package:tivnqn/model/preparation/pDispatch.dart';
// import 'package:tivnqn/model/preparation/pInspectionFabric.dart';
// import 'package:tivnqn/model/preparation/pRelaxationFabric.dart';
// import 'dart:async';
// import 'dart:convert';

// class SqlAppTiqn {
//   final String ipLAN = '192.168.1.11';
//   final String dbName = 'App';
//   final String port = '1433';
//   final int timeoutInSeconds = 10;
//   // final String instanceSql = 'MSSQLSERVER';
//   final user = 'app';
//   final pass = 'Toray@123';
//   final String tableConfig = '[App].[dbo].configs';
//   final String tablePInspectionFabric = '[App].[dbo].PInspectionFabric';
//   final String tablePCutting = '[App].[dbo].PCutting';
//   final String tablePDispatch = '[App].[dbo].PDispatch';
//   final mssqlConnection = MssqlConnection.getInstance();
//   bool isConnected = false;
//   get getIsConnected => this.isConnected;

//   set setIsConnected(isConnected) => this.isConnected = isConnected;

// // Returns a boolean indicating the connection status.
//   Future<bool> connect() async {
//     bool connection = false;
//     connection = await mssqlConnection.connect(
//       ip: ipLAN,
//       port: port,
//       databaseName: dbName,
//       username: user,
//       password: pass,
//       timeoutInSeconds: timeoutInSeconds,
//     );
//     return connection;
//   }

//   Future<bool> disconnect() async {
//     // Example: Disconnect from the database
//     bool isDisconnected = await mssqlConnection.disconnect();
// // Returns a boolean indicating the disconnection status.
//     return isDisconnected ? isDisconnected : false;
//   }

//   Future<List<Configs>> getConfigs() async {
//     List<Configs> result = [];
//     List<Map<String, dynamic>> tempResult = [];

//     final String query = '''select * from $tableConfig''';
//     print('Query : $query  ');
//     try {
//       mssqlConnection.getData(query).then((value) => {
//             if (value.isNotEmpty)
//               {
//                 result = (jsonDecode(value) as List)
//                     .map((data) => Configs.fromJson(value))
//                     .toList()
//               }
//           });
//       var rowData;
//     } catch (e) {
//       print('getConfigs  --> Exception : ' + e.toString());
//     }
//     return result;
//   }

//   Future<List<PInspectionFabric>> gettPInspectionFabric() async {
//     List<PInspectionFabric> result = [];
//     List<Map<String, dynamic>> tempResult = [];

//     final String query = '''select * from $tablePInspectionFabric
//         WHERE CAST(date AS DATE) = CAST(GETDATE() AS DATE) 
//         ''';
//     print('Query : $query  ');
//     try {
//       mssqlConnection.getData(query).then((value) => {
//             if (value.isNotEmpty)
//               {
//                 result = (jsonDecode(value) as List)
//                     .map((data) => new PInspectionFabric.fromJson(value))
//                     .toList()
//               }
//           });
//       var rowData;
//     } catch (e) {
//       print('get PInspectionFabric --> Exception : ' + e.toString());
//     }
//     return result;
//   }
// }
