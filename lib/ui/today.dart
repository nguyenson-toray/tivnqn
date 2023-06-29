import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
            '''${element.getGxNo} - ${element.getGxName} - ${element.getQty}\n''';
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
    return MasonryGridView.count(
      padding: EdgeInsets.all(2),
      itemCount: g.workSummary.length,
      crossAxisCount: 5,
      itemBuilder: (context, index) {
        List<ProcessDetailQty> process =
            g.workSummary[index].getProcessDetailQtys;
        return Card(
          color: Colors.teal[50],
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
                              width: 150,
                              child: Text(
                                '''${process[index2].getGxNo} : ${process[index2].getGxName}''',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '''${process[index2].getQty}''',
                              style: TextStyle(
                                  color: process[index2].getQty < 40
                                      ? Colors.red
                                      : Colors.green),
                            )
                          ],
                        ),
                        Divider(height: 1),
                      ],
                    );
                  },
                ),
              ),
              subtitle: Text(
                g.workSummary[index].getShortName.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              )),
        );
      },
    );
  }
}
