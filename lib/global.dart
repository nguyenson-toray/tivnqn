import 'package:shared_preferences/shared_preferences.dart';
import 'package:tivnqn/connection/mySqI.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMk026.dart';
import 'package:tivnqn/model/sqlMoInfo.dart';
import 'package:tivnqn/model/sqlSumQty.dart';
import 'package:tivnqn/model/workSummary.dart';

class g {
  static bool isTV = true;
  static bool isTVLine = true;
  static String version = '1.0.0';
  static double screenWidthPixel = 0;
  static double screenHeightPixel = 0;
  static double screenWidthInch = 0;
  static double screenHeightInch = 0;
  static double appBarH = 40;
  static double todayWidth = 200;

  static int currentLine = 8;
  static String currentMO = '2023JUN003';
  static String currentStyle = 'DS-23AU001';
  static int rangeTime = 6;
  static late SharedPreferences sharedPreferences;
  static var mySql = MySql();
  static bool isMySqlConnected = false;

  static List<SqlEmployee> sqlEmployees = [];
  static late SqlMoInfo sqlMoInfo;
  static List<SqlMK026> sqlMK026 = [];
  static List<SqlSumQty> sqlSumQty = [];
  static List<WorkSummary> workSummary = [];
  static List<SqlEmployee> lineEmployeesScaned = [];
  static List<String> idEmpScaneds = [];
  List<Map<int, String>> defectCodeNames = [];

  static bool showETS = true;
}
