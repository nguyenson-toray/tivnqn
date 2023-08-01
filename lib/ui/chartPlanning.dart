import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/model/planning.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/global.dart';

class ChartPlanning extends StatefulWidget {
  const ChartPlanning({super.key});

  @override
  State<ChartPlanning> createState() => _ChartPlanningState();
}

class _ChartPlanningState extends State<ChartPlanning> {
  // DateTime startChartDate = DateTime.now().subtract(Duration(days: 10));
  final scrollController = ScrollController();
  DateTime startChartDate = DateTime.parse('2023-07-01');
  DateTime endChartDate = DateTime.parse('2023-12-31');
  // int firstWeekNumber = MyFuntions.findWeekNumber(DateTime.parse('2023-07-01'));
  // int lastWeekNumber = MyFuntions.findWeekNumber(DateTime.parse('2023-12-31'));
  int dayCount = 0;
  double cellW = 20;
  double cellHeaderH = 20;
  double cellEventH = 46;
  double currentOffset = 0;
  @override
  void initState() {
    List<DateTime> dates = [];
    g.sqlPlanning.forEach((element) {
      dates.add(element.getEndDate);
    });
    dates.sort((a, b) => a.difference(b).inDays);
    // endChartDate = dates.last;
    endChartDate = DateTime.parse('2024-04-31');
    dayCount = endChartDate.difference(DateTime.parse('2023-07-01')).inDays;
    currentOffset =
        (DateTime.now().difference(DateTime.parse('2023-07-01')).inDays - 10) *
            cellW;
    Timer(const Duration(milliseconds: 100), () async {
      scrollController.initialScrollOffset;
      scrollController.jumpTo(currentOffset);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 24,
        backgroundColor: Colors.lightBlue,
        elevation: 6.0,
        centerTitle: true,
        title: const Text(
          'PRODUCTION PLANNING',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),
        child: RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                if (scrollController.offset <
                    scrollController.position.maxScrollExtent) {
                  scrollController.jumpTo(scrollController.offset + 400);
                }
              }
              if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                if (scrollController.offset <
                    scrollController.position.maxScrollExtent) {
                  scrollController.jumpTo(scrollController.offset - 400);
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: cellHeaderH * 2,
                      child: Text(
                        '''L
I
N
E''',
                        style:
                            TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                      height: cellHeaderH * 2 + cellEventH * 9,
                      width: 25,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueGrey, width: 0.5),
                                color: Colors.white),
                            height: cellEventH,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: cellHeaderH * 2 + cellEventH * 9,
                        width: dayCount * cellW,
                        child: CustomScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          slivers: [
                            SliverList(
                                delegate:
                                    SliverChildBuilderDelegate((_, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: cellHeaderH * 2,
                                      width: dayCount * cellW,
                                      child: header()),
                                  event(1),
                                  event(2),
                                  event(3),
                                  event(4),
                                  event(5),
                                  event(6),
                                  event(7),
                                  event(8),
                                  event(9),
                                ],
                              );
                            }, childCount: dayCount)),
                          ],
                        ),
                      ),
                      Container(
                        height: cellHeaderH,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Use the LEFT - RIGHT arrow buttons on the remote control to scroll',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget header() {
    return Container(
      height: cellHeaderH * 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: cellHeaderH,
            width: dayCount * cellW,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dayCount,
                itemBuilder: (context, index) {
                  DateTime date = startChartDate.add(Duration(days: index));
                  String header =
                      '${date.year} - ${DateFormat.MMMM().format(date)}';
                  return date.day == 1
                      ? Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blueGrey, width: 0.5),
                              color: Colors.teal[100]),
                          width: cellW *
                              MyFuntions.findLastDateOfTheMonth(date).day,
                          height: cellHeaderH,
                          child: Text(
                            '$header',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container();
                }),
          ),
          Container(
            height: cellHeaderH,
            width: dayCount * cellW,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dayCount,
              itemBuilder: (context, index) {
                DateTime date = startChartDate.add(Duration(days: index));

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey, width: 0.5),
                      color:
                          date.weekday == 7 ? Colors.grey[200] : Colors.white),
                  width: cellHeaderH,
                  height: cellW,
                  // color: Colors.lightBlueAccent,
                  child: Text(
                    '${date.day}',
                    style: TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget event(int line) {
    int eventIndex = 0;

    List<Planning> lineEvents = [];
    lineEvents =
        g.sqlPlanning.where((element) => element.getLine == line).toList();
    Planning lineEvent = lineEvents.first;
    print('lineEvent : $lineEvent');
    return Container(
        // color: Colors.redAccent,
        height: cellEventH,
        width: cellW * dayCount,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dayCount,
            itemBuilder: (context, index) {
              DateTime date = startChartDate.add(Duration(days: index));

              if (eventIndex < lineEvents.length - 1 &&
                  date.isAfter(lineEvent.getEndDate)) {
                eventIndex++;
                lineEvent = lineEvents[eventIndex];
              }
              int dayEventCount = lineEvent.getEndDate
                      .difference(lineEvent.getBeginDate)
                      .inDays +
                  1;
              bool isFirstDateEvent =
                  lineEvent.getBeginDate.difference(date).inDays == 0;
              bool inEvent = date.isAfter(
                      lineEvent.getBeginDate.subtract(Duration(days: 1))) &&
                  date.isBefore(lineEvent.getEndDate.add(Duration(days: 1)));
              // print(
              //     'date: $date  index : $index   inEvent:$inEvent  isFirstDateEvent: $isFirstDateEvent   dayEventCount : $dayEventCount');
              return inEvent && isFirstDateEvent
                  ? Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueGrey, width: 0.5),
                          color: MyFuntions.gerRandomColor()),
                      width: cellW * dayEventCount,
                      height: cellEventH,
                      child: Text(
                          textAlign: TextAlign.center,
                          'Style: ${lineEvent.getStyle}     Qty: ${lineEvent.getQuantity}Pcs     Desc: ${lineEvent.getComment}'))
                  : Container(
                      width: inEvent ? 0 : cellW,
                      height: cellEventH,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueGrey, width: 0.5),
                          color: Colors.transparent),
                    );
            }));
  }
}
