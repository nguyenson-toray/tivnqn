import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tivnqn/global.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tivnqn/model/preparation/pDispatch.dart';
import 'package:tivnqn/model/preparation/pDispatchDataSource.dart';
import 'package:tivnqn/myFuntions.dart';

class DashboardPDispatch extends StatefulWidget {
  const DashboardPDispatch({super.key});

  @override
  State<DashboardPDispatch> createState() => _DashboardPDispatchState();
}

class _DashboardPDispatchState extends State<DashboardPDispatch> {
  List<PDispatch> pDispatchs = <PDispatch>[];

  late PDispatchDataSource pDispatchDataSource;
  @override
  void initState() {
    pDispatchDataSource = PDispatchDataSource(pDispatch: g.pDispatchs);

    Timer.periodic(Duration(minutes: g.refreshMinute), (timer) {
      DateTime time = DateTime.now();
      if (time.hour == 16 && time.minute >= 55)
        exit(0);
      else
        refreshData();
    });
    super.initState();
  }

  Future<void> refreshData() async {
    var temp = await g.sqlApp.sellectPDispatch();
    if (temp.length > 0) {
      setState(() {
        g.pDispatchs = temp;
        pDispatchDataSource = PDispatchDataSource(pDispatch: g.pDispatchs);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 24,
        backgroundColor: Colors.blue,
        elevation: 6.0,
        leadingWidth: 95,
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              g.todayString,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
        leading: Image.asset(
          'assets/logo_white.png',
        ),
        centerTitle: true,
        title: const Text(
          'DISPATCH TO SEWING LINE PLAN',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child:
                SfDataGrid(source: pDispatchDataSource, columns: <GridColumn>[
              GridColumn(
                  columnName: 'line',
                  width: g.screenWidth / 15 - 18,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'line'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  columnName: 'brand',
                  width: g.screenWidth / 15 * 2,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'brand'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  columnName: 'styleNo',
                  width: g.screenWidth / 6,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Style No',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  columnName: 'orderQty',
                  width: g.screenWidth / 15,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Order Qty',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  columnName: 'Color',
                  width: g.screenWidth / 6,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Color',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  columnName: 'item1',
                  width: g.screenWidth / 10,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Size #1',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  columnName: 'item2',
                  width: g.screenWidth / 10,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Size #2',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  columnName: 'item3',
                  width: g.screenWidth / 10,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Size #3',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
              GridColumn(
                  columnName: 'total',
                  width: g.screenWidth / 15 * 1.5 + 18,
                  label: Container(
                      color: Colors.blue[200],
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dispatched %',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
            ]),
          ),
          Positioned(
              bottom: 10, right: 10, child: MyFuntions.getClock(context)),
        ],
      ),
    );
  }
}
