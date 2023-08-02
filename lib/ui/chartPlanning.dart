import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
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
  double cellW = 16;
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
        leadingWidth: 95,
        leading: Image.asset(
          'assets/logo_white.png',
        ),
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
                  scrollController.jumpTo(scrollController.offset + 300);
                }
              }
              if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                if (scrollController.offset <
                    scrollController.position.maxScrollExtent) {
                  scrollController.jumpTo(scrollController.offset - 300);
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
                                    color: Colors.blueGrey, width: 0.1),
                                color: Colors.white),
                            height: cellEventH,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
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
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
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
      width: dayCount * cellW,
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
                                  color: Colors.blueGrey, width: 0.1),
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
                      border: Border.all(color: Colors.blueGrey, width: 0.1),
                      color:
                          date.weekday == 7 ? Colors.white : Colors.teal[50]),
                  width: cellW,
                  height: cellHeaderH,
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
    Planning lineEvent = Planning(
        line: line,
        style: '',
        desc: '',
        quantity: 0,
        beginDate: DateTime.parse('2023-01-01'),
        endDate: DateTime.parse('2023-01-01'),
        comment: '');
    List<Planning> lineEvents = [];
    lineEvents =
        g.sqlPlanning.where((element) => element.getLine == line).toList();
    if (lineEvents.length > 0) {
      lineEvent = lineEvents.first;
    }
    print('lineEvent : $lineEvent');
    return Container(
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
              return inEvent && isFirstDateEvent
                  ? Container(
                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.1),
                          color: Colors.transparent),
                      width: cellW * dayEventCount,
                      child: drawEvent(lineEvent))
                  : Container(
                      width: inEvent ? 0 : cellW,
                      height: cellEventH,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.1),
                          color: Colors.transparent),
                    );
            }));
  }

  Widget drawEvent(Planning event) {
    DateTime beginDate = event.getBeginDate;
    DateTime endDate = event.getEndDate;
    double width = (endDate.difference(beginDate).inDays + 1) * cellW;
    String contentStr =
        'Style: ${event.getStyle} ${event.getDesc != '' ? ' - Description: ${event.getDesc}' : ''} - ${event.getQuantity}Pcs ${event.getComment != '' ? ' - Note: ${event.getComment}' : ''}';
    Widget content = Container();
    if (event.getLine == 8) {
      print('content : ${contentStr.length} w: $width');
    }
    if (width / contentStr.length < 3.8) {
      content = Marquee(
          blankSpace: 20,
          velocity: 30.0,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          style: const TextStyle(
              // fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.black),
          text: contentStr);
    } else {
      content = Text(contentStr,
          style: const TextStyle(
              // fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.black));
    }
    return ClipPath(
      clipper: ArrowClipper(cellEventH, cellEventH - 6, Edge.RIGHT),
      child: Container(
        padding: EdgeInsets.fromLTRB(1, 1, cellW, 0),
        width: width,
        height: cellEventH,
        color: MyFuntions.gerRandomColor(),
        child: Center(child: content),
      ),
    );
  }
}
