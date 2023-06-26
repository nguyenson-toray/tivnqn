import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/ui/dashboardSewingLine.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoaded = false;
  String functionSellected = '';
  FluWakeLock fluWakeLock = FluWakeLock();
  var myTextStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  void initState() {
    // TODO: implement initState

    Timer(Duration(milliseconds: 500), () async {
      initData().then((value) => (value) {
            setState(() {
              isLoaded = value;
            });
          });
    });

    Timer.periodic(new Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (isLoaded) {
        Loader.hide();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new DashboardSewingLine()),
        );
      }
    });
    super.initState();
  }

  Future<bool> initData() async {
    var isConnected = await g.sql.initConnection();
    if (isConnected) {
      g.sqlEmployees = g.sql.getEmployees();
      g.sqlMK026 = g.sql.getMK026(g.currentLine);
      g.sqlSumQty = g.sql.getSqlSumQty(g.currentLine);
      fluWakeLock.enable();
    } else {
      print("SQL Server not available -Load offline data");
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => new ErrorPage()),
      // );
    }
    print('initData-DONE');
    setState(() {
      isLoaded = true;
    });
    return true;
  }

  showLoading() {
    if (isLoaded) {
      Loader.hide();
    } else {
      Loader.show(
        context,
        overlayColor: g.isTV ? Colors.white : Colors.black54,
        progressIndicator: SizedBox(
            width: 100,
            height: 200,
            child: Column(children: [
              g.isTV ? Image.asset('assets/logo.png') : Container(),
              Image.asset('assets/loading.gif')
            ])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('isLoaded : ' + isLoaded.toString());
    return SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //     elevation: 10,
            //     backgroundColor: Colors.indigoAccent,
            //     actions: [
            //       InkWell(
            //         child: Image.asset('assets/vietnam.png'),
            //       ),
            //       InkWell(
            //         child: Image.asset('assets/japan.png'),
            //       )
            //     ]),
            body: g.device.contains('TV')
                ? showLoading()
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: hightSpace,
                        ),
                        SizedBox(
                            height: logoH,
                            child: Image.asset('assets/logo.png')),
                        SizedBox(
                          height: hightSpace,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Container(
                            // decoration: g.myBoxDecoration,
                            height: buttonH,
                            width: buttonW,
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueAccent)),
                                icon: Icon(
                                  Icons.dashboard,
                                  size: 40,
                                ),
                                label: Container(
                                    width: buttonW,
                                    child: Text(
                                      'Management',
                                      style: myTextStyle,
                                    )),
                                onPressed: () async {
                                  print(' Touch Management - isLoaded : ' +
                                      isLoaded.toString());
                                  setState(() {
                                    functionSellected = 'Management';
                                    g.screenTypeInt = 1;
                                  });
                                  if (isLoaded) {
                                    Loader.hide();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new Dashboard()),
                                    );
                                  } else {
                                    showLoading();
                                  }
                                }),
                          ),
                        ),
                        SizedBox(
                          height: hightSpace,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Container(
                            // decoration: g.myBoxDecoration,
                            height: buttonH,
                            width: buttonW,
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.cyan)),
                                icon: Icon(
                                  Icons.bug_report,
                                  size: 40,
                                ),
                                label: Container(
                                    width: buttonW,
                                    child: Text(
                                      'QC',
                                      style: myTextStyle,
                                    )),
                                onPressed: () async {
                                  print(' Touch QC - isLoaded : ' +
                                      isLoaded.toString());
                                  setState(() {
                                    functionSellected = 'QC';
                                  });
                                  if (isLoaded) {
                                    Loader.hide();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => new QcPage()),
                                    );
                                  } else {
                                    showLoading();
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  )));
  }
}
