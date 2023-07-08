import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tivnqn/connection/sqlETSDB.dart';
import 'package:tivnqn/connection/sqlProductionDB.dart';
import 'package:tivnqn/model/chartData.dart';
import 'package:tivnqn/model/processDetail.dart';
import 'package:tivnqn/model/appSetting.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMoInfo.dart';
import 'package:tivnqn/model/sqlSumEmpQty.dart';
import 'package:tivnqn/model/sqlSumNoQty.dart';
import 'package:tivnqn/model/sqlT01.dart';
import 'package:tivnqn/model/workSummary.dart';

class g {
  static DateTime today = DateTime.now();
  static DateTime pickedDate = DateTime.now();
  static int processNoFinishBegin = 71;
  static int processNoFinishEnd = 150;
  static String title = 'SẢN LƯỢNG & TỈ LỆ LỖI';
  static late String todayString;
  static final String dateFormat = 'yyyy-MM-dd';
  static final String dateFormat2 = 'dd/MM/yyyy';
  static final rangeDays = 14;
  static final sqlUser = 'app';
  static final sqlPass = 'Toray@123';
  static final dbProduction = 'Production';
  static final dbETSDB_TI = 'ETSDB_TI';

  static String version = '2.0.0';
  static double screenWidthPixel = 0;
  static double screenHeightPixel = 0;
  static double screenWidthInch = 0;
  static double screenHeightInch = 0;
  static double appBarH = 40;

  static bool isTVLine = true;
  static bool autochangeLine = true;
  static bool isLoading = false;
  static List<int> lines = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  static int currentLine = 1;
  static int currentIndexLine = 0;
  static String currentMO = '';
  static String currentStyle = '';
  static String currentCnid = '';
  static late SharedPreferences sharedPreferences;
  static var sqlProductionDB = SqlProductionDB();
  static var sqlETSDB = SqlETSDB();

  static List<SqlEmployee> sqlEmployees = [];
  static late SqlMoInfo sqlMoInfo;
  static List<SqlSumEmpQty> sqlSumEmpQty = [];
  static List<SqlSumNoQty> sqlSumNoQty = [];
  static List<WorkSummary> workSummary = [];
  static List<SqlEmployee> employeesScaned = [];
  static List<ProcessDetail> processDetail = [];
  static List<int> processAll = [];
  static List<int> processScaned = [];
  static List<int> processNotScan = [];
  static List<String> idEmpScaneds = [];
  static List<SqlT01> sqlT01 = [];
  static AppSetting appSetting = AppSetting(
      lines: '1,2,3,4,5,6,8,9',
      timeChangeLine: 5,
      timeReload: 1,
      rangeDays: 14,
      showNotification: 0,
      notificationURL: '',
      showBegin: '07:00:00',
      showDuration: 30,
      chartBegin: '09:00:00',
      chartDuration: 30,
      ipTvLine: '');
  List<Map<int, String>> defectCodeNames = [];

  static bool showETS = false;
  static bool showProcess = false;
  static ValueNotifier<int> reloadType = ValueNotifier(0);
  //--------------------
  static late Widget chartUi;
  static List<ChartData> chartData = [];
}
