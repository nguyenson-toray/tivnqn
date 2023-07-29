import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/ui/chartPlanningImage.dart';

class ChartPlanningUI extends StatefulWidget {
  const ChartPlanningUI({super.key});

  @override
  State<ChartPlanningUI> createState() => _ChartPlanningUIState();
}

class _ChartPlanningUIState extends State<ChartPlanningUI> {
  final scrollController = ScrollController();
  List<GanttAbsoluteEvent> ganttAbsoluteEvent = [];
  bool enableZoom = false;
  double dayWidth = 24;
  double eventHeight = 40;
  double stickyAreaWidth = 135;
  DateTime startDate = DateTime.now().subtract(Duration(days: 3));
  static const defaultHolidayColor = Colors.grey;
  static const defaultBorder = BorderDirectional(
    top: BorderSide.none,
    bottom: BorderSide.none,
    start: BorderSide(),
  );
  late final Color holidayColor = Colors.grey;
  final BoxBorder? border = BorderDirectional(
    top: BorderSide.none,
    bottom: BorderSide.none,
    start: BorderSide(),
  );
  void onZoomIn() {
    setState(() {
      dayWidth += 5;
    });
  }

  void onZoomOut() {
    if (dayWidth <= 10) return;
    setState(() {
      dayWidth -= 5;
    });
  }

  void initData() {
    g.sqlPlanning.sort(
      (a, b) => a.getLine.compareTo(b.getLine),
    );
    ganttAbsoluteEvent.clear();
    int i = 1;
    g.sqlPlanning.forEach((element) {
      GanttAbsoluteEvent event = GanttAbsoluteEvent(
          displayName: '''Line ${element.getLine} - ${element.getQuantity} pcs
${element.getStyle}''',
          startDate: element.getBeginDate,
          endDate: element.getEndDate,
          suggestedColor: MyFuntions.getColorByLine(i));
      if (!element.getEndDate.isBefore(DateTime.now())) {
        ganttAbsoluteEvent.add(event);
      }
      i++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initData();
    Timer.periodic(Duration(seconds: 30), (timer) async {
      if (mounted) {
        g.sqlProductionDB.getPlanning().then((value) => {
              g.sqlPlanning = value,
              setState(() {
                initData();
              })
            });

        if (DateTime.now().hour >= 17) exit(0);
      }
    });
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
        // leading: InkWell(
        //     onTap: () {
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => ChartPlanningImage()),
        //       );
        //     },
        //     child: Icon(
        //       Icons.change_circle,
        //       color: Colors.black,
        //     )),
        // actions: [
        //   IconButton(
        //     onPressed: onZoomIn,
        //     icon: const Icon(
        //       Icons.zoom_in,
        //     ),
        //   ),
        //   IconButton(
        //     onPressed: onZoomOut,
        //     icon: const Icon(
        //       Icons.zoom_out,
        //     ),
        //   ),
        // ],
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            if (scrollController.offset <
                scrollController.position.maxScrollExtent) {
              scrollController.jumpTo(scrollController.offset + dayWidth * 30);
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            if (scrollController.offset >
                scrollController.position.minScrollExtent) {
              scrollController.jumpTo(scrollController.offset - dayWidth * 30);
            }
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GanttChartView(
                scrollPhysics: const BouncingScrollPhysics(),
                stickyAreaDayBuilder: (context) {
                  return AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, _) {
                      final pos = scrollController.positions.firstOrNull;
                      final currentOffset = pos?.pixels ?? 0;
                      final maxOffset = pos?.maxScrollExtent ?? double.infinity;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // bottom: 0,
                        children: [
                          IconButton(
                            onPressed: currentOffset > 0
                                ? () {
                                    scrollController.jumpTo(
                                        scrollController.offset -
                                            dayWidth * 30);
                                  }
                                : null,
                            color: Colors.black,
                            icon: const Icon(
                              Icons.keyboard_arrow_left,
                              // size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: currentOffset < maxOffset
                                ? () {
                                    scrollController.jumpTo(
                                        scrollController.offset +
                                            dayWidth * 30);
                                  }
                                : null,
                            color: Colors.black,
                            icon: const Icon(
                              Icons.keyboard_arrow_right,
                              // size: 20,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                scrollController: scrollController,
                maxDuration: const Duration(days: 30 * 6),
                startDate: startDate,
                dayWidth: dayWidth,
                eventHeight: eventHeight,
                stickyAreaWidth: stickyAreaWidth,
                showStickyArea: true,
                weekHeaderBuilder: (context, weekDate) =>
                    GanttChartDefaultWeekHeader(
                        weekDate: weekDate,
                        color: Colors.white,
                        backgroundColor: Colors.blue[600],
                        border: const BorderDirectional(
                          end: BorderSide(color: Colors.black),
                        )),
                dayHeaderBuilder: (context, date, bool isHoliday) =>
                    GanttChartDefaultDayHeader(
                  border: const BorderDirectional(
                    end: BorderSide(color: Colors.black),
                  ),
                  date: date,
                  isHoliday: isHoliday,
                  color: isHoliday ? Colors.redAccent : Colors.white,
                  backgroundColor: isHoliday
                      ? Colors.grey
                      : date.toString().substring(0, 10) ==
                              DateTime.now().toString().substring(0, 10)
                          ? Colors.tealAccent
                          : Colors.blue[400],
                ),
                showDays: true,
                weekEnds: const {}, //
                isExtraHoliday: (context, day) {
                  //define custom holiday logic for each day
                  return DateUtils.isSameDay(DateTime(2022, 7, 1), day);
                },
                startOfTheWeek: WeekDay.monday,
                eventCellPerDayBuilder: (context, eventStart, eventEnd,
                    isHoliday, event, day, eventColor) {
                  final isWithinEvent = !DateUtils.isSameDay(
                          eventStart, eventEnd) &&
                      (DateUtils.isSameDay(eventStart, day) ||
                          day.isAfter(eventStart) && day.isBefore(eventEnd));

                  final color = isHoliday
                      ? (holidayColor ?? defaultHolidayColor)
                      : isWithinEvent
                          ? eventColor
                          : null;
                  return Container(
                    decoration: BoxDecoration(
                      color: isHoliday ? color : null,
                      border: border ?? defaultBorder,
                    ),
                    child: !isWithinEvent || isHoliday
                        ? null
                        : LayoutBuilder(
                            builder: (context, constraints) => Center(
                              child: Container(
                                alignment: Alignment.center,
                                child: day
                                                .difference(
                                                    DateTime(2023, 7, 19))
                                                .inDays ==
                                            0 &&
                                        g.enablePercentComplete
                                    ? SquarePercentIndicator(
                                        width: 0.6 * constraints.maxHeight,
                                        height: 0.6 * constraints.maxHeight,
                                        startAngle: StartAngle.bottomLeft,
                                        reverse: false,
                                        borderRadius: 10,
                                        shadowWidth: 1.0,
                                        progressWidth: 3,
                                        shadowColor: Colors.grey,
                                        progressColor:
                                            MyFuntions.getColorByPercent(0.9),
                                        progress: 0.8,
                                        child: Center(
                                            child: Text(
                                          "54%",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 7),
                                        )),
                                      )
                                    : null,
                                height: 0.8 * constraints.maxHeight,
                                width: constraints.maxWidth,
                                color: color,
                              ),
                            ),
                          ),
                  );
                },
                stickyAreaWeekBuilder: (context) {
                  return Image.asset('assets/logo.png');
                  // Text(
                  //   'Navigation buttons',
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 14,
                  //   ),
                  // );
                },
                events: ganttAbsoluteEvent,
                // stickyAreaEventBuilder:
                //     (context, eventIndex, event, eventColor) => Container(
                //   color: Colors.yellow,
                //   child: Center(
                //     child: Text("${event.displayName}"),
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
