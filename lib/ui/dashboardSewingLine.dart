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
  final lines = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[700],
          actions: [
            // Text(DateFormat("hh :mm").format(DateTime.now()).toString()),
            Text('LINE : '),
            DropdownButton<String>(
              value: g.currentLine.toString(),
              items: lines.map<DropdownMenuItem<String>>((int value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(
                    value.toString(),
                    // style: TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  g.currentLine = int.parse(newValue!);
                  // changeSetting();
                });
              },
            ),
            // InkWell(
            //   child: Icon(Icons.settings),
            //   onTap: () {},
            // ),
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
            ),
          ],
          // leading: CircleAvatar(
          //   backgroundColor: Colors.white,
          //   child: Text(g.currentLine.toString(),
          //       style:
          //           const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          // ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 700,
                  child: Text(
                      'MO : ' + g.currentMO + '- Style : ' + g.currentStyle)),
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
                child: g.showETS ? Today() : LastDays()),
            // const LastDays()
          ],
        ));
  }
}
