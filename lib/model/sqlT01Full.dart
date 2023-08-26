import 'dart:convert';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';

class SqlT01Full {
  int id;
  int inspectionType;
  int x01;
  String x02;
  int x03;
  String x04;
  String x05;
  int x06;
  int x07;
  int x08;
  int x09;
  int x10;
  int a1;
  int a2;
  int a3;
  int b1;
  int b2;
  int b3;
  int c1;
  int c2;
  int d1;
  int d2;
  int d3;
  int d4;
  int e1;
  int e2;
  int e3;
  int e4;
  int e5;
  int e6;
  int e7;
  int f1;
  int f2;
  int f3;
  int f4;
  int f5;
  int f6;
  int f7;
  int f8;
  int f9;
  int g1;
  int g2;
  int g3;
  int h;
  String xc;
  int sumA;
  int sumB;
  int sumC;
  int sumD;
  int sumE;
  int sumF;
  int sumG;
  int sumH;
  int total;
  int x11;
  int x12;
  int tMonth;
  int tYear;
  int tF;
  String time;
  int checkNo;
  String defectName;
  int totalChecked;
  bool lastResult;
  get getId => this.id;

  set setId(id) => this.id = id;

  get getInspectionType => this.inspectionType;

  set setInspectionType(inspectionType) => this.inspectionType = inspectionType;

  get getX01 => this.x01;

  set setX01(x01) => this.x01 = x01;

  get getX02 => this.x02;

  set setX02(x02) => this.x02 = x02;

  get getX03 => this.x03;

  set setX03(x03) => this.x03 = x03;

  get getX04 => this.x04;

  set setX04(x04) => this.x04 = x04;

  get getX05 => this.x05;

  set setX05(x05) => this.x05 = x05;

  get getX06 => this.x06;

  set setX06(x06) => this.x06 = x06;

  get getX07 => this.x07;

  set setX07(x07) => this.x07 = x07;

  get getX08 => this.x08;

  set setX08(x08) => this.x08 = x08;

  get getX09 => this.x09;

  set setX09(x09) => this.x09 = x09;

  get getX10 => this.x10;

  set setX10(x10) => this.x10 = x10;

  get getA1 => this.a1;

  set setA1(a1) => this.a1 = a1;

  get getA2 => this.a2;

  set setA2(a2) => this.a2 = a2;

  get getA3 => this.a3;

  set setA3(a3) => this.a3 = a3;

  get getB1 => this.b1;

  set setB1(b1) => this.b1 = b1;

  get getB2 => this.b2;

  set setB2(b2) => this.b2 = b2;

  get getB3 => this.b3;

  set setB3(b3) => this.b3 = b3;

  get getC1 => this.c1;

  set setC1(c1) => this.c1 = c1;

  get getC2 => this.c2;

  set setC2(c2) => this.c2 = c2;

  get getD1 => this.d1;

  set setD1(d1) => this.d1 = d1;

  get getD2 => this.d2;

  set setD2(d2) => this.d2 = d2;

  get getD3 => this.d3;

  set setD3(d3) => this.d3 = d3;

  get getD4 => this.d4;

  set setD4(d4) => this.d4 = d4;

  get getE1 => this.e1;

  set setE1(e1) => this.e1 = e1;

  get getE2 => this.e2;

  set setE2(e2) => this.e2 = e2;

  get getE3 => this.e3;

  set setE3(e3) => this.e3 = e3;

  get getE4 => this.e4;

  set setE4(e4) => this.e4 = e4;

  get getE5 => this.e5;

  set setE5(e5) => this.e5 = e5;

  get getE6 => this.e6;

  set setE6(e6) => this.e6 = e6;

  get getE7 => this.e7;

  set setE7(e7) => this.e7 = e7;

  get getF1 => this.f1;

  set setF1(f1) => this.f1 = f1;

  get getF2 => this.f2;

  set setF2(f2) => this.f2 = f2;

  get getF3 => this.f3;

  set setF3(f3) => this.f3 = f3;

  get getF4 => this.f4;

  set setF4(f4) => this.f4 = f4;

  get getF5 => this.f5;

  set setF5(f5) => this.f5 = f5;

  get getF6 => this.f6;

  set setF6(f6) => this.f6 = f6;

  get getF7 => this.f7;

  set setF7(f7) => this.f7 = f7;

  get getF8 => this.f8;

  set setF8(f8) => this.f8 = f8;

  get getF9 => this.f9;

  set setF9(f9) => this.f9 = f9;

  get getG1 => this.g1;

  set setG1(g1) => this.g1 = g1;

  get getG2 => this.g2;

  set setG2(g2) => this.g2 = g2;

  get getG3 => this.g3;

  set setG3(g3) => this.g3 = g3;

  get getH => this.h;

  set setH(h) => this.h = h;

  get getXc => this.xc;

  set setXc(xc) => this.xc = xc;

  get getSumA => this.sumA;

  set setSumA(sumA) => this.sumA = sumA;

  get getSumB => this.sumB;

  set setSumB(sumB) => this.sumB = sumB;

  get getSumC => this.sumC;

  set setSumC(sumC) => this.sumC = sumC;

  get getSumD => this.sumD;

  set setSumD(sumD) => this.sumD = sumD;

  get getSumE => this.sumE;

  set setSumE(sumE) => this.sumE = sumE;

  get getSumF => this.sumF;

  set setSumF(sumF) => this.sumF = sumF;

  get getSumG => this.sumG;

  set setSumG(sumG) => this.sumG = sumG;

  get getSumH => this.sumH;

  set setSumH(sumH) => this.sumH = sumH;

  get getTotal => this.total;

  set setTotal(total) => this.total = total;

  get getX11 => this.x11;

  set setX11(x11) => this.x11 = x11;

  get getX12 => this.x12;

  set setX12(x12) => this.x12 = x12;

  get getTMonth => this.tMonth;

  set setTMonth(tMonth) => this.tMonth = tMonth;

  get getTYear => this.tYear;

  set setTYear(tYear) => this.tYear = tYear;

  get getTF => this.tF;

  set setTF(tF) => this.tF = tF;

  get getTime => this.time;

  set setTime(time) => this.time = time;

  get getCheckNo => this.checkNo;

  set setCheckNo(checkNo) => this.checkNo = checkNo;

  get getDefectName => this.defectName;

  set setDefectName(defectName) => this.defectName = defectName;

  get getTotalChecked => this.totalChecked;

  set setTotalChecked(totalChecked) => this.totalChecked = totalChecked;
  get getLastResult => this.lastResult;

  set setLastResult(lastResult) => this.lastResult = lastResult;
  SqlT01Full(
      {this.id = 0,
      this.inspectionType = 1,
      this.x01 = 0,
      this.x02 = '',
      this.x03 = 0,
      this.x04 = '',
      this.x05 = '',
      this.x06 = 0,
      this.x07 = 0,
      this.x08 = 0,
      this.x09 = 0,
      this.x10 = 0,
      this.a1 = 0,
      this.a2 = 0,
      this.a3 = 0,
      this.b1 = 0,
      this.b2 = 0,
      this.b3 = 0,
      this.c1 = 0,
      this.c2 = 0,
      this.d1 = 0,
      this.d2 = 0,
      this.d3 = 0,
      this.d4 = 0,
      this.e1 = 0,
      this.e2 = 0,
      this.e3 = 0,
      this.e4 = 0,
      this.e5 = 0,
      this.e6 = 0,
      this.e7 = 0,
      this.f1 = 0,
      this.f2 = 0,
      this.f3 = 0,
      this.f4 = 0,
      this.f5 = 0,
      this.f6 = 0,
      this.f7 = 0,
      this.f8 = 0,
      this.f9 = 0,
      this.g1 = 0,
      this.g2 = 0,
      this.g3 = 0,
      this.h = 0,
      this.xc = '',
      this.sumA = 0,
      this.sumB = 0,
      this.sumC = 0,
      this.sumD = 0,
      this.sumE = 0,
      this.sumF = 0,
      this.sumG = 0,
      this.sumH = 0,
      this.total = 0,
      this.x11 = 0,
      this.x12 = 0,
      this.tMonth = 0,
      this.tYear = 0,
      this.tF = 0,
      this.time = '',
      this.checkNo = 1,
      this.defectName = '',
      this.totalChecked = 0,
      this.lastResult = true});

  calculateValue() {
    sumA = a1 + a2 + a3;
    sumB = b1 + b2 + b3;
    sumC = c1 + c2;
    sumD = d1 + d2 + d3 + d4;
    sumE = e1 + e2 + e3 + e4 + e5 + e6 + e7;
    sumF = f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8 + f9;
    sumG = g1 + g2 + g3;
    sumH = h;
    x11 = x06 - x07;
    x12 = x08 - x09;
    tF = x11 + x12;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inspectionType': inspectionType,
      'X01': x01,
      'X02': x02,
      'X03': x03,
      'X04': x04,
      'X05': x05,
      'X06': x06,
      'X07': x07,
      'X08': x08,
      'X09': x09,
      'X10': x10,
      'a1': a1,
      'a2': a2,
      'a3': a3,
      'b1': b1,
      'b2': b2,
      'b3': b3,
      'c1': c1,
      'c2': c2,
      'd1': d1,
      'd2': d2,
      'd3': d3,
      'd4': d4,
      'e1': e1,
      'e2': e2,
      'e3': e3,
      'e4': e4,
      'e5': e5,
      'e6': e6,
      'e7': e7,
      'f1': f1,
      'f2': f2,
      'f3': f3,
      'f4': f4,
      'f5': f5,
      'f6': f6,
      'f7': f7,
      'f8': f8,
      'f9': f9,
      'g1': g1,
      'g2': g2,
      'g3': g3,
      'h': h,
      'XC': xc,
      'sumA': sumA,
      'sumB': sumB,
      'sumC': sumC,
      'sumD': sumD,
      'sumE': sumE,
      'sumF': sumF,
      'sumG': sumG,
      'sumH': sumH,
      'total': total,
      'X11': x11,
      'X12': x12,
      'tMonth': tMonth,
      'tYear': tYear,
      'tF': tF,
      'time': time,
      'checkNo': checkNo,
      'defectName': defectName,
      'totalChecked': totalChecked,
      'lastResult': lastResult,
    };
  }

  factory SqlT01Full.fromMap(Map<String, dynamic> map) {
    return SqlT01Full(
        id: map['ID'] != null ? map['ID']?.toInt() : map['_id']?.toInt(),
        inspectionType: map['2nd']?.toInt() ?? 0,
        x01: map['X01']?.toInt() ?? 0,
        x02: map['X02'] ?? '',
        x03: map['X03']?.toInt() ?? 0,
        x04: map['X04'] ?? '',
        x05: map['X05'] ?? '',
        x06: map['X06']?.toInt() ?? 0,
        x07: map['X07']?.toInt() ?? 0,
        x08: map['X08']?.toInt() ?? 0,
        x09: map['X09']?.toInt() ?? 0,
        x10: map['X10']?.toInt() ?? 0,
        a1: map['A1']?.toInt() ?? 0,
        a2: map['A2']?.toInt() ?? 0,
        a3: map['A3']?.toInt() ?? 0,
        b1: map['B1']?.toInt() ?? 0,
        b2: map['B2']?.toInt() ?? 0,
        b3: map['B3']?.toInt() ?? 0,
        c1: map['C1']?.toInt() ?? 0,
        c2: map['C2']?.toInt() ?? 0,
        d1: map['D1']?.toInt() ?? 0,
        d2: map['D2']?.toInt() ?? 0,
        d3: map['D3']?.toInt() ?? 0,
        d4: map['D4']?.toInt() ?? 0,
        e1: map['E1']?.toInt() ?? 0,
        e2: map['E2']?.toInt() ?? 0,
        e3: map['E3']?.toInt() ?? 0,
        e4: map['E4']?.toInt() ?? 0,
        e5: map['E5']?.toInt() ?? 0,
        e6: map['E6']?.toInt() ?? 0,
        e7: map['E7']?.toInt() ?? 0,
        f1: map['F1']?.toInt() ?? 0,
        f2: map['F2']?.toInt() ?? 0,
        f3: map['F3']?.toInt() ?? 0,
        f4: map['F4']?.toInt() ?? 0,
        f5: map['F5']?.toInt() ?? 0,
        f6: map['F6']?.toInt() ?? 0,
        f7: map['F7']?.toInt() ?? 0,
        f8: map['F8']?.toInt() ?? 0,
        f9: map['F9']?.toInt() ?? 0,
        g1: map['G1']?.toInt() ?? 0,
        g2: map['G2']?.toInt() ?? 0,
        g3: map['G3']?.toInt() ?? 0,
        h: map['H']?.toInt() ?? 0,
        xc: map['XC'] ?? '',
        sumA: map['sum A']?.toInt() ?? 0,
        sumB: map['Sum B']?.toInt() ?? 0,
        sumC: map['Sum C']?.toInt() ?? 0,
        sumD: map['Sum D']?.toInt() ?? 0,
        sumE: map['Sum E']?.toInt() ?? 0,
        sumF: map['Sum F']?.toInt() ?? 0,
        sumG: map['Sum G']?.toInt() ?? 0,
        sumH: map['Sum H']?.toInt() ?? 0,
        total: map['Total']?.toInt() ?? 0,
        x11: map['X11']?.toInt() ?? 0,
        x12: map['X12']?.toInt() ?? 0,
        tMonth: map['T-Month']?.toInt() ?? 0,
        tYear: map['T-Year']?.toInt() ?? 0,
        tF: map['TF']?.toInt() ?? 0,
        time: map['time'] ?? '',
        checkNo: map['checkNo']?.toInt() ?? 1,
        defectName: map['defectName'] ?? '',
        totalChecked: map['totalChecked']?.toInt() ?? 0,
        lastResult: MyFuntions.parseBool(map['lastResult']?.toInt() ?? 1));
  }

  String toJson() => json.encode(toMap());

  factory SqlT01Full.fromJson(String source) =>
      SqlT01Full.fromMap(json.decode(source));

  @override
  String toString() {
    return 'T011stInspectionData(id: $id, inspectionType: $inspectionType, x01: $x01, x02: $x02, x03: $x03, x04: $x04, x05: $x05, x06: $x06, x07: $x07, x08: $x08, x09: $x09, x10: $x10, a1: $a1, a2: $a2, a3: $a3, b1: $b1, b2: $b2, b3: $b3, c1: $c1, c2: $c2, d1: $d1, d2: $d2, d3: $d3, d4: $d4, e1: $e1, e2: $e2, e3: $e3, e4: $e4, e5: $e5, e6: $e6, e7: $e7, f1: $f1, f2: $f2, f3: $f3, f4: $f4, f5: $f5, f6: $f6, f7: $f7, f8: $f8, f9: $f9, g1: $g1, g2: $g2, g3: $g3, h: $h, xc: $xc, sumA: $sumA, sumB: $sumB, sumC: $sumC, sumD: $sumD, sumE: $sumE, sumF: $sumF, sumG: $sumG, sumH: $sumH, total: $total, x11: $x11, x12: $x12, tMonth: $tMonth, tYear: $tYear, tF: $tF, time: $time, isReCheck: $checkNo, defectName: $defectName, totalChecked: $totalChecked), lastResult $lastResult';
  }
}
