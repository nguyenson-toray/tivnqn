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
      crossAxisCount: 6,
      itemBuilder: (context, index) {
        List<ProcessDetailQty> process =
            g.workSummary[index].getProcessDetailQtys;
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: MyFuntions.getColorByQty(
                    process[0].getQty, g.sqlMoInfo.getTargetDay),
                width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          surfaceTintColor: Colors.pink,
          color: Colors.cyan[50],
          margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
          child: ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.fromLTRB(2, 2, 2, 0),
              title: SizedBox(
                height: process.length * 22,
                child: MasonryGridView.count(
                  crossAxisCount: 1,
                  itemCount: process.length,
                  itemBuilder: (context, index2) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 130,
                              child: Text(
                                '''${process[index2].getGxNo} : ${process[index2].getGxName}''',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
              subtitle: Container(
                color: MyFuntions.getColorByQty(
                    process[0].getQty, g.sqlMoInfo.getTargetDay),
                child: Text(g.workSummary[index].getShortName.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    )),
              )),
        );
      },
    );
  }
}
