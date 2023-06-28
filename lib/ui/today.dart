import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/ui/listViewData.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
// Declaring the controller and the item size
  late ScrollController _scrollController;
  final itemSize = g.sqlSumQty.length;
  List<String> qtyDetail = [];
// Initializing
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    g.workSummary.forEach((element) {
      String detail = '';
      List<ProcessDetailQty> processDetailQtys = element.getProcessDetailQtys;
      processDetailQtys.forEach((element) {
        detail +=
            '''${element.getGxNo} - ${element.getGxName} - - ${element.getQty}\n''';
      });
      qtyDetail.add(detail);
    });
    super.initState();
  }

  void _scrollListener() {
    setState(() {
      var index = (_scrollController.offset / itemSize).round() + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Text('ETS * MO : ${g.currentMO} * Style : ${g.currentStyle}'),
          Divider(
            color: Colors.teal.shade100,
            thickness: 2.0,
          ),
          Expanded(
            child: ListView.builder(
                // controller: _scrollController,
                // reverse: false,
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 20,
                    child: Card(
                      child: ListTile(
                          titleTextStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.black),
                          leadingAndTrailingTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black),
                          trailing: Text(
                              g.workSummary[index].getShortName.toString()),
                          // trailing: SizedBox(
                          //     width: 80,
                          //     child:
                          //         Text(g.sqlSumQty[index].getSumQty.toString())),
                          title: Text(qtyDetail[index])),
                    ),
                  );
                },
                itemCount: (g.workSummary.length)),
          ),
        ],
      ),
    );
  }
}
