import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:tivnqn/ui/dashboardSewingLine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tivnqn/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('en');
  await getsharedPreferences();
  await detectDeviceInfo();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  g.version = packageInfo.version;
  runApp(const MyApp());
}

Future<void> detectDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  g.screenWidthPixel = androidInfo.displayMetrics.widthPx;
  g.screenHeightPixel = androidInfo.displayMetrics.heightPx;
  g.screenWidthInch = androidInfo.displayMetrics.widthInches;
  g.screenHeightInch = androidInfo.displayMetrics.heightInches;
  print('screenWidthPixel : ' + g.screenWidthPixel.toString());
  print('screenHeightPixel : ' + g.screenHeightPixel.toString());
  print('screenWidthInch : ' + g.screenWidthInch.toString());
  print('screenHeightInch : ' + g.screenHeightInch.toString());

  final ip = await NetworkInfo().getWifiIP();
  if (ip == '192.168.1.69' || ip == '192.168.1.70') {
    g.isTVLine = false;
  }
  print('isTVLine : $g.isTVLine');
}

getsharedPreferences() async {
  g.sharedPreferences = await SharedPreferences.getInstance();
  if (g.sharedPreferences.getInt("currentLine") == null) {
    g.sharedPreferences.setInt('currentLine', 1);
    g.currentLine = 1;
  } else
    g.currentLine = g.sharedPreferences.getInt("currentLine")!;
  if (g.sharedPreferences.getInt("rangeTime") == null) {
    g.sharedPreferences.setInt('rangeTime', 6);
    g.rangeTime = 6;
  } else
    g.rangeTime = g.sharedPreferences.getInt("rangeTime")!;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIVN-QN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DashboardSewingLine(),
    );
  }
}
