import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/ui/footer.dart';
import 'package:tivnqn/ui/lastDays.dart';
import 'package:tivnqn/ui/today.dart';
import 'package:tivnqn/ui/topPanel.dart';
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
          actions: [Icon(Icons.settings)],
          leading: Container(
            child: Text(DateFormat("hh :mm").format(DateTime.now()).toString()),
          ),
          toolbarHeight: g.appBarH,
          centerTitle: true,
          title: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(g.currentLine.toString(),
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
          )),
      body: LayoutGrid(
        areas: '''
          today lastdays 
          footer footer  
        ''',
        columnSizes: [1.fr, 1.fr],
        rowSizes: [
          auto,
          40.px,
        ],
        children: [
          // gridArea('topPanel').containing(TopPanel()),
          gridArea('today').containing(Today()),
          gridArea('lastdays').containing(LastDays()),
          gridArea('footer').containing(Footer()),
        ],
      ),
    );
  }
}
