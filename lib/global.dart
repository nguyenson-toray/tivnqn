import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tivnqn/connection/sqlETSDB.dart';
import 'package:tivnqn/connection/sqlProductionDB.dart';
import 'package:tivnqn/model/chartData.dart';
import 'package:tivnqn/model/moDetail.dart';
import 'package:tivnqn/model/planning.dart';
import 'package:tivnqn/model/processDetail.dart';
import 'package:tivnqn/model/appSetting.dart';
import 'package:tivnqn/model/sqlCummulativeNoQty.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlSumEmpQty.dart';
import 'package:tivnqn/model/sqlSumNoQty.dart';
import 'package:tivnqn/model/sqlT01.dart';
import 'package:tivnqn/model/sqlT01Full.dart';
import 'package:tivnqn/model/workSummary.dart';

class g {
  static DateTime today = DateTime.now();
  static DateTime pickedDate = DateTime.now();
  static int processNoFinishBegin = 71;
  static int processNoFinishEnd = 150;
  static String title = 'SẢN LƯỢNG & TỈ LỆ LỖI';
  static late String todayString;
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateFormat2 = 'dd/MM/yyyy';
  static const rangeDays = 14;
  static const sqlUser = 'app';
  static const sqlPass = 'Toray@123';
  static const dbProduction = 'Production';
  static const dbETSDB_TI = 'ETSDB_TI';

  static String version = '2.0.0';
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double appBarH = 40;
  static double footerH = 25;
  static double fontSizeAppbar = 20;

  static String ip = '';
  static bool isTVLine = true;
  static bool isTVPlanning = true;
  static bool enableMoney = false;
  static var currencyFormat =
      NumberFormat.currency(locale: "vi_VN", symbol: "đ");
  static int screenType = 1; //1 :chart , 2: name, 3: process
  static bool autochangeLine = true;
  static bool isLoading = false;
  static List<int> lines = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  static int currentLine = 1;
  static int currentIndexLine = 0;
  static String dashboardGeneralType = 'general';
  static late SharedPreferences sharedPreferences;
  static var sqlProductionDB = SqlProductionDB();
  static var sqlETSDB = SqlETSDB();

  static List<SqlEmployee> sqlEmployees = [];
  static List<MoDetail> moDetails = [];
  static late MoDetail currentMoDetail;
  static List<SqlSumEmpQty> sqlSumEmpQty = [];
  static List<SqlSumNoQty> sqlSumNoQty = [];
  static List<SqlCummulativeNoQty> sqlCummulativeNoQty = [];
  static List<WorkSummary> workSummary = [];
  static List<SqlEmployee> employeesScaned = [];
  static List<ProcessDetail> processDetail = [];
  static List<int> processAll = [];
  static List<int> processScaned = [];
  static List<int> processNotScan = [];
  static List<String> idEmpScaneds = [];
  static List<SqlT01> sqlT01 = [];
  static List<SqlT01Full> sqlT01s = [];
  static late AppSetting appSetting;
  List<Map<int, String>> defectCodeNames = [];

  static ValueNotifier<String> reloadType = ValueNotifier('');
  //--------------------
  static late Widget chartUi;
  static List<ChartData> chartData = [];

  //---------------- planning chart
  static bool enablePercentComplete = false;
  static List<Planning> sqlPlanning = [];
}
