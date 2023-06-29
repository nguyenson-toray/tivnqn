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
          backgroundColor: Colors.blueGrey[200],
          actions: [
            Row(
              children: [
                Icon(Icons.settings),
                Container(
                  child: Text(
                      DateFormat("hh :mm").format(DateTime.now()).toString()),
                ),
              ],
            )
          ],
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(g.currentLine.toString(),
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 700,
                  child: Text(
                      'MO : ' + g.currentMO + '- Style : ' + g.currentStyle)),
              Row(
                children: [
                  Text("ETS"),
                  Switch(
                    value: g.showETS,
                    onChanged: (value) {
                      setState(() {
                        g.showETS = value;
                      });
                    },
                  ),
                ],
              )
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
        ));
  }
}
