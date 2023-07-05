import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/ui/startPage.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('vi');
  await getsharedPreferences();
  await detectDeviceInfo();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  g.version = packageInfo.version;
  g.todayString = DateFormat(g.dateFormat).format(
    g.today,
  );
  runApp(const MyApp());
}

Future<void> detectDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  g.screenWidthPixel = androidInfo.displayMetrics.widthPx;
  g.screenHeightPixel = androidInfo.displayMetrics.heightPx;
  g.screenWidthInch = androidInfo.displayMetrics.widthInches;
  g.screenHeightInch = androidInfo.displayMetrics.heightInches;
  print('screenWidthPixel : ${g.screenWidthPixel}');
  print('screenHeightPixel : ${g.screenHeightPixel}');
  print('screenWidthInch : ${g.screenWidthInch}');
  print('screenHeightInch : ${g.screenHeightInch}');
  final ip = await NetworkInfo().getWifiIP();
  if (ip == '192.168.1.69' || ip == '192.168.1.70') {
    g.isTVLine = false;
  }
  print('isTVLine : $g.isTVLine');
}

getsharedPreferences() async {
  g.sharedPreferences = await SharedPreferences.getInstance();
  if (g.sharedPreferences.getInt("currentLine") == null) {
    g.sharedPreferences.setInt('currentLine', 8);
  } else {
    g.currentLine = g.sharedPreferences.getInt("currentLine")!;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: MaterialApp(
        title: 'TIVN-QN',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const StartPage(),
      ),
    );
  }
}
