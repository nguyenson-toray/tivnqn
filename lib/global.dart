import 'package:shared_preferences/shared_preferences.dart';
import 'package:tivnqn/connection/sqlServer.dart';
import 'package:tivnqn/model/dailySumQty.dart';
import 'package:tivnqn/model/sqlEmployee.dart';
import 'package:tivnqn/model/sqlMk026.dart';
import 'package:tivnqn/model/sqlSumQty.dart';

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
  static bool isSqlConnected = false;
  static List<DailySumQty> dailySumQtys = [];

  static var sql = SqlETSDB_TI();
  static List<SqlEmployee> sqlEmployees = [];
  static List<SqlMK026> sqlMK026 = [];
  static List<SqlSumQty> sqlSumQty = [];

  List<Map<int, String>> defectCodeNames = [];
}
