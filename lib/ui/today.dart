import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tivnqn/myFuntions.dart';

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
    g.workSummary.forEach((element) {
      String detail = '';
      List<ProcessDetailQty> processDetailQtys = element.getProcessDetailQtys;
      processDetailQtys.forEach((element) {
        detail +=
            '''${element.getGxNo} - ${element.getGxName} - ${element.getQty}\n''';
      });
      qtyDetail.add(detail);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: EdgeInsets.all(2),
      itemCount: g.workSummary.length,
      // the number of columns
      crossAxisCount: 6,
      // vertical gap between two items
      mainAxisSpacing: 2,
      // horizontal gap between two items
      crossAxisSpacing: 2,
      itemBuilder: (context, index) {
        List<ProcessDetailQty> process =
            g.workSummary[index].getProcessDetailQtys;
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: MyFuntions.getColorByQty(
                    process[0].getQty, g.sqlMoInfo.getTargetDay),
                width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          surfaceTintColor: Colors.pink,
          color: Colors.cyan[50],
          margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
          child: Column(
              // dense: true,
              // visualDensity: VisualDensity(vertical: -4),
              // contentPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
              children: [
                SizedBox(
                  height: process.length * 25,
                  child: MasonryGridView.count(
                    itemCount: process.length,
                    // the number of columns
                    crossAxisCount: 1,
                    // vertical gap between two items
                    mainAxisSpacing: 2,
                    // horizontal gap between two items
                    crossAxisSpacing: 2,
                    itemBuilder: (context, index2) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                                width: 128,
                                child: Text(
                                  '''${process[index2].getGxNo} : ${process[index2].getGxName}''',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    // fontSize: 10,
                                    color: process[index2].getGxNo == 150
                                        ? Colors.deepPurpleAccent
                                        : Colors.black,
                                    fontWeight: process[index2].getGxNo >=
                                                g.processNoFinishBegin &&
                                            process[index2].getGxNo <=
                                                g.processNoFinishEnd
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                '''${process[index2].getQty}''',
                              )
                            ],
                          ),
                          Divider(height: 1, color: Colors.white),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  width: 170,
                  decoration: BoxDecoration(
                    color: MyFuntions.getColorByQty(
                        process[0].getQty, g.sqlMoInfo.getTargetDay),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // color: MyFuntions.getColorByQty(
                  //     process[0].getQty, g.sqlMoInfo.getTargetDay),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      process[0].getQty > g.sqlMoInfo.getTargetDay
                          ? Icon(
                              Icons.star,
                              color: Colors.white,
                            )
                          : Container(),
                      Text(g.workSummary[index].getShortName.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                          )),
                    ],
                  ),
                )
              ]),
        );
      },
    );
  }
}
