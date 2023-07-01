// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';

class SqlT01 {
  String x02;
  int x06;
  int x07;
  int x08;
  int x09;
  get getX02 => this.x02;

  set setX02(x02) => this.x02 = x02;

  get getX06 => this.x06;

  set setX06(x06) => this.x06 = x06;

  get getX07 => this.x07;

  set setX07(x07) => this.x07 = x07;

  get getX08 => this.x08;

  set setX08(x08) => this.x08 = x08;

  get getX09 => this.x09;

  set setX09(x09) => this.x09 = x09;
  SqlT01({
    required this.x02,
    required this.x06,
    required this.x07,
    required this.x08,
    required this.x09,
  });

  @override
  String toString() {
    return 'SqlT01(x02: $x02, x06: $x06, x07: $x07, x08: $x08, x09: $x09)';
  }
}
