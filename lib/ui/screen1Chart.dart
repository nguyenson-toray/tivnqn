import 'package:flutter/material.dart';
import 'package:tivnqn/global.dart';

class Screen1Chart extends StatefulWidget {
  const Screen1Chart({super.key});

  @override
  State<Screen1Chart> createState() => _Screen1ChartState();
}

class _Screen1ChartState extends State<Screen1Chart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: g.chartUi,
    );
  }
}
