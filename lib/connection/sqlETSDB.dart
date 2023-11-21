import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:tivnqn/model/moDetail.dart';
import 'package:tivnqn/model/processDetail.dart';
import 'package:tivnqn/model/appSetting.dart';
import 'package:tivnqn/model/sqlCummulativeNoQty.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMoSetting.dart';
import 'package:tivnqn/model/sqlSumEmpQty.dart';
import 'package:tivnqn/model/sqlSumNoQty.dart';
import 'package:tivnqn/model/sqlWorkLayer.dart';

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

    print('SqlETSDB initConnection : $isConnected');
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
                        empId: element['CODE'],
                        empName: element['NAME'].trim())),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }

    return result;
  }

  Future<List<String>> getCnids(List<String> moNames) async {
    List<String> cnids = [];
    var tempResult;
    String where = 'WHERE ';
    for (var element in moNames) {
      where += '''ZDCODE = '$element' OR ''';
    }
    where = where.substring(0, where.length - 4);
    String query = '''SELECT CheckDate , Cnid ,Zdcode
 FROM  T_ZdGxCheck 
 $where
 ORDER BY CheckDate DESC''';
    print('getCnids of $moNames : $query');

    try {
      var value = await connection.getRowsOfQueryResult(query);
      if (value.runtimeType == String) {
        print('Query : $query => ERROR ');
      } else {
        g.processAll.clear();
        tempResult = value.cast<Map<String, dynamic>>();

        for (var moName in moNames) {
          String cnid = '';
          for (var element in tempResult) {
            if (element['Zdcode'] == moName) {
              cnid = element['Cnid'];
              break;
            }
          }
          cnids.add(cnid);
        }
      }
      print('getCnid of MOs: $moNames => $cnids');
    } catch (e) {
      print(e.toString());
    }

    return cnids;
  }

  Future<List<ProcessDetail>> getProcessDetail(String cnid) async {
    String query = '''  SELECT cnid, GxNO, GxCode, gxName, SamPrice
 FROM [ETSDB_TI].[dbo].tbSczzdGxDetail  
 WHERE cnid =  '$cnid' AND GxType = 'Sewing'
 ORDER BY GxNO ASC ''';

    List<ProcessDetail> result = [];
    var tempResult;
    double money = 0;
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
                    money = double.tryParse(element['SamPrice'].toString())!,
                    result.add(ProcessDetail(
                        cind: cnid,
                        no: element['GxNO'],
                        code: element['GxCode'],
                        name: element['gxName'],
                        unitPrice: money))
                  }
              }
          });
      print(result.length);
    } catch (e) {
      print(' $e');
    }

    return result;
  }

  Future<List<MoDetail>> getAllMoDetails() async {
    List<SqlMoSetting> moSettings = [];
    List<MoDetail> result = [];
    moSettings = await getMoSetting();
    List<String> moNames = [];
    for (var moSetting in moSettings) {
      moNames.add(moSetting.getMo);
    }
    List<String> cnids = [];
    cnids = await g.sqlETSDB.getCnids(moNames);

    String where = 'WHERE ';
    for (var element in moNames) {
      where += '''ZDCODE = '$element' OR ''';
    }
    where = where.substring(0, where.length - 4);
    String query = '''SELECT ZDCODE, STYLE_NO, MY_COUNT, XM
FROM T_SCZZD
$where ''';
    var tempResult;
    print('getAllMoDetailFromT_SCZZD : $query');
    // MoDetail modetail = MoDetail(
    //     line: 1,
    //     mo: 'TESTAPP',
    //     style: 'TESTAPPSTYLE',
    //     desc: 'TESTAPP',
    //     qty: 100,
    //     cnid: 'cnid',
    //     targetDay: 100,
    //     lastProcess: 150);
    MoDetail modetail;
    try {
      await connection.getRowsOfQueryResult(query).then((value) async => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    for (int i = 0; i < moNames.length; i++)
                      {
                        if (element['ZDCODE'] == moNames[i])
                          {
                            modetail = MoDetail(
                                line: moSettings[i].getLine,
                                mo: element['ZDCODE'],
                                style: element['STYLE_NO'],
                                desc: element['XM'] ?? '',
                                qty: element['MY_COUNT'],
                                cnid: cnids[i],
                                lastProcess: moSettings[i].getLastProcess,
                                targetDay: moSettings[i].getTargetDay),
                            result.add(modetail)
                          }
                      }
                  }
              }
          });
      print(
          '''getAllMoDetailFromT_SCZZD ======> result.length = ${result.length})''');
    } catch (e) {
      print(e.toString());
    }

    return result;
  }

  Future<List<SqlMoSetting>> getMoSetting() async {
    String query = '''SELECT line, mo, targetDay, lastProcess
FROM A_MoSetting''';
    List<SqlMoSetting> result = [];
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
                    result.add(
                      SqlMoSetting(
                          line: element['line'],
                          mo: element['mo'],
                          targetDay: element['targetDay'],
                          lastProcess: element['lastProcess']),
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

  Future<List<SqlSumEmpQty>> getSqlSumEmpQty(String mo, DateTime date) async {
    String dateString = DateFormat(g.dateFormat).format(
      g.pickedDate,
    );
    String query = '''SELECT GxNo, EmpId,SUM(Qty) as Sum_Qty
FROM EmployeeDayData
WHERE  WorkLine LIKE '%L%' AND ZDCode = '${mo.trim()}'  AND CONVERT(date,WorkDate)=CONVERT(date,'$dateString')
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

  Future<List<SqlSumNoQty>> getSqlSumNoQty(String mo, DateTime date) async {
    String dateString = DateFormat(g.dateFormat).format(
      g.pickedDate,
    );
    String query = '''SELECT GxNo,SUM(Qty) as Sum_Qty
FROM EmployeeDayData
WHERE  WorkLine LIKE '%L%' AND ZDCode = '${mo.trim()}'  AND CONVERT(date,WorkDate)=CONVERT(date,'$dateString')
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

  Future<List<SqlCummulativeNoQty>> getSqlCummNoQty(String mo) async {
    String query = '''
SELECT GxNo,  SUM(Qty) as CummulativeQty
FROM TbZDCodeGxQty
WHERE  ZDCode = '$mo'  
GROUP BY GxNo 
ORDER BY GxNo ASC
''';
    List<SqlCummulativeNoQty> result = [];
    var tempResult;
    print('getSqlCummNoQty : $query');
    try {
      await connection.getRowsOfQueryResult(query).then((value) => {
            if (value.runtimeType == String)
              {print('Query : $query => ERROR ')}
            else
              {
                tempResult = value.cast<Map<String, dynamic>>(),
                for (var element in tempResult)
                  {
                    result.add(SqlCummulativeNoQty(
                        GxNo: element['GxNo'],
                        CummulativeQty: element['CummulativeQty'])),
                  }
              }
          });
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<List<Worklayer>> getWorklayer() async {
    List<Worklayer> result = [];
    List<Map<String, dynamic>> tempResult = [];

    final String query =
        '''SELECT [WorklayerNo], [WorkLayerName],[OperationBegin],[Operationend]  
FROM [ETSDB_TI].[dbo].[tbbsWorkLayer]
ORDER BY WorklayerNo ASC
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
                    rowData = Worklayer.fromMap(element),
                    result.add(rowData),
                  }
              }
          });
    } catch (e) {
      print('getWorklayer --> Exception : ' + e.toString());
    }
    return result;
  }
}
