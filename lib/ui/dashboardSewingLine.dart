import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/ui/lastDays.dart';
import 'package:tivnqn/ui/today.dart';
import 'package:tivnqn/global.dart';

class DashboardSewingLine extends StatefulWidget {
  const DashboardSewingLine({super.key});

  @override
  State<DashboardSewingLine> createState() => _DashboardSewingLineState();
}

class _DashboardSewingLineState extends State<DashboardSewingLine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                Container(
                  child: Text(
                      DateFormat("hh :mm").format(DateTime.now()).toString()),
                ),
                Icon(Icons.settings),
              ],
            )
          ],
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(g.currentLine.toString(),
                style:
                    const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
          ),
          title: Row(
            children: [
              Text('MO : ${g.currentMO} * Style : ${g.currentStyle}'),
            ],
          ),
          toolbarHeight: g.appBarH,
          centerTitle: true,
        ),
        body: Row(
          children: [
            SizedBox(
                width: g.screenWidthPixel / 2,
                height: 500,
                child: const Today()),
            // const LastDays()
          ],
        )
        // LayoutGrid(
        //   areas: '''
        //       today lastdays
        //       footer footer
        //     ''',
        //   columnSizes: [1.fr, 1.fr],
        //   rowSizes: [
        //     auto,
        //     40.px,
        //   ],
        //   children: [
        //     // gridArea('topPanel').containing(TopPanel()),
        //     gridArea('today').containing(Today()),
        //     gridArea('lastdays').containing(LastDays()),
        //     gridArea('footer').containing(Footer()),
        //   ],
        // ),
        );
  }
}
