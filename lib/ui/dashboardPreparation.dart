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
      body: g.config.getSection == 'preparation1'
          ? DashBoardPInspectionRelaxation()
          : g.config.getSection == 'preparation2'
              ? DashboardPCutting()
              : DashboardPDispatch(),
    );
  }
}
