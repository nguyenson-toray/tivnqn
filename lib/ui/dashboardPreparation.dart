import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/ui/dashboardPCutting.dart';
import 'package:tivnqn/ui/dashboardPDispatch.dart';
import 'package:tivnqn/ui/dashboardPInspectionRelaxation.dart';

class DashboardPreparation extends StatefulWidget {
  const DashboardPreparation({super.key});

  @override
  State<DashboardPreparation> createState() => _DashboardPreparationState();
}

class _DashboardPreparationState extends State<DashboardPreparation> {
  @override
  void initState() {
    // TODO: implement initState

    Timer.periodic(Duration(seconds: g.config.getReloadSeconds), (timer) async {
      DateTime time = DateTime.now();
      if (time.hour == 16 && time.minute >= 55)
        exit(0);
      else {
        g.configs = await g.sqlApp.sellectConfigs();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: g.appBarH,
          backgroundColor: Colors.blue,
          elevation: 6.0,
          leadingWidth: 95,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              child: Row(
                children: [
                  MyFuntions.clockAppBar(context),
                  Text(
                    DateFormat(g.dateFormat2).format(
                      g.today,
                    ),
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
          leading: Image.asset(
            'assets/logo_white.png',
          ),
          centerTitle: true,
          title: Text(
            g.title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            g.config.getSection == 'preparation1'
                ? DashBoardPInspectionRelaxation()
                : g.config.getSection == 'preparation2'
                    ? DashboardPCutting()
                    : DashboardPDispatch(),
            Positioned(
                right: 2,
                bottom: 2,
                child: Text(
                  'Version : ${g.version}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 6,
                      fontWeight: FontWeight.normal),
                )),
          ],
        ));
  }
}
