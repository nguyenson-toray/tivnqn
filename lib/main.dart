import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/ui/InitialPage.dart';
import 'package:flutter/services.dart';
import 'package:ntp/ntp.dart';

Future<void> main() async {
  [
    'pool.ntp.org',
    // 'time.facebook.com',
    // 'time.euro.apple.com',
    // 'pool.ntp.org',
  ].forEach(_checkTime);
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('vi');
  await getsharedPreferences();
  await detectDeviceInfo();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  g.version = packageInfo.version;
  g.todayString = DateFormat(g.dateFormat).format(
    g.today,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft // DeviceOrientation.portraitUp
  ]).then((_) async {
    runApp(const MyApp());
  });
}

Future<void> detectDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('androidInfo.manufacturer : ${androidInfo.manufacturer}');
  if (androidInfo.manufacturer.contains('tcl') ||
      androidInfo.systemFeatures.contains('android.software.leanback') ||
      androidInfo.manufacturer.contains('TCL') ||
      androidInfo.manufacturer.contains('Google') ||
      androidInfo.manufacturer.contains('unknown')) {
    g.fontSizeAppbar == 20;
  } else {
    g.fontSizeAppbar == 14;
  }
  print('g.fontSizeAppbar :${g.fontSizeAppbar}');
  // g.screenWidthPixel = androidInfo.displayMetrics.widthPx;
  // g.screenHeightPixel = androidInfo.displayMetrics.heightPx;
  // g.screenWidthInch = androidInfo.displayMetrics.widthInches;
  // g.screenHeightInch = androidInfo.displayMetrics.heightInches;
  // print('screenWidthPixel : ${g.screenWidthPixel}');
  // print('screenHeightPixel : ${g.screenHeightPixel}');
  // print('screenWidthInch : ${g.screenWidthInch}');
  // print('screenHeightInch : ${g.screenHeightInch}');
}

getsharedPreferences() async {
  g.sharedPreferences = await SharedPreferences.getInstance();
  // if (g.sharedPreferences.getInt("currentLine") == null) {
  //   g.sharedPreferences.setInt('currentLine', 8);
  // } else {
  //   g.currentLine = g.sharedPreferences.getInt("currentLine")!;
  // }
}

Future<void> _checkTime(String lookupAddress) async {
  DateTime _myTime;
  DateTime _ntpTime;

  /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
  _myTime = DateTime.now();

  /// Or get NTP offset (in milliseconds) and add it yourself
  g.ntpTimeOffsetMilliseconds =
      await NTP.getNtpOffset(localTime: _myTime, lookUpAddress: lookupAddress);

  _ntpTime = _myTime.add(Duration(milliseconds: g.ntpTimeOffsetMilliseconds));

  print('\n==== $lookupAddress ====');
  print('Device time: $_myTime');
  print('NTP time: $_ntpTime');
  print(
      'Difference: ${_myTime.difference(_ntpTime).inMilliseconds}  Milliseconds');

  return;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TIVN-QN',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: InitialPgae(),
      ),
    );
  }
}
