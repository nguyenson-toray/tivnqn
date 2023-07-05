import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tivnqn/model/chartData.dart';
import 'package:tivnqn/model/processDetail.dart';
import 'package:tivnqn/model/setting.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:tivnqn/connection/mySqI.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMoInfo.dart';
import 'package:tivnqn/model/sqlSumQty.dart';
import 'package:tivnqn/model/sqlT01.dart';
import 'package:tivnqn/model/workSummary.dart';

class g {
  static DateTime today = DateTime.now();
  static int processNoFinishBegin = 71;
  static int processNoFinishEnd = 150;
  static String title = 'SẢN LƯỢNG & TỈ LỆ LỖI';
  static late String todayString;
  static final String dateFormat = 'yyyy-MM-dd';
  static final rangeDays = 14;
  static final sqlUser = 'app';
  static final sqlPass = 'Toray@123';
  static final dbProduction = 'Production';
  static final dbETSDB_TI = 'ETSDB_TI';

  static bool isTVLine = true;
  static String version = '2.0.0';
  static double screenWidthPixel = 0;
  static double screenHeightPixel = 0;
  static double screenWidthInch = 0;
  static double screenHeightInch = 0;
  static double appBarH = 50;
  static double todayWidth = 200;

  static bool needLoadAllData = true;
  static int currentLine = 8;
  static String currentMO = '2023JUN003';
  static String currentStyle = 'DS-23AU001';
  static String currentCnid = '';
  static late SharedPreferences sharedPreferences;
  static var mySql = MySql();
  static bool isMySqlConnected = false;

  static List<SqlEmployee> sqlEmployees = [];
  static late SqlMoInfo sqlMoInfo;
  static List<SqlSumQty> sqlSumQty = [];
  static List<WorkSummary> workSummary = [];
  static List<SqlEmployee> employeesScaned = [];
  static List<ProcessDetail> processDetail = [];
  static List<int> processAll = [];
  static List<int> processScaned = [];
  static List<int> processNotScan = [];
  static List<String> idEmpScaneds = [];
  static List<SqlT01> sqlT01 = [];
  static Setting setting = Setting(
      reloadTimeSeconds: 30,
      showNotification: 0,
      text: '',
      imgURL: '',
      showBegin: '',
      showEnd: '',
      chartBegin: '',
      chartEnd: '',
      rangeDay: 14);
  List<Map<int, String>> defectCodeNames = [];

  static bool showETS = false;
  //--------------------
  static late Widget chartUi;
  static List<ChartData> chartData = [];
}
