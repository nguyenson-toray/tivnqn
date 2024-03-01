import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/model/chartData.dart';
import 'package:tivnqn/model/sqlT01.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/global.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:tivnqn/ui/chartUI.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyFuntions {
  // static List<WorkSummary> summaryDailyDataETS() {
  //   g.processScaned.clear();
  //   g.processNotScan.clear();
  //   g.idEmpScaneds.clear();

  //   List<WorkSummary> result = [];
  //   for (var element in g.sqlSumEmpQty) {
  //     g.idEmpScaneds.add(element.getEmpId);
  //     g.processScaned.add(element.getGxNo);
  //   }
  //   g.idEmpScaneds = g.idEmpScaneds.toSet().toList();
  //   g.processScaned = g.processScaned.toSet().toList();
  //   g.processNotScan =
  //       g.processAll.toSet().difference(g.processScaned.toSet()).toList();
  //   for (var idEmpScaned in g.idEmpScaneds) {
  //     double moneyEmp = 0;
  //     final String currentName = g.sqlEmployees
  //         .firstWhere((emp) => emp.getEmpId == idEmpScaned)
  //         .getEmpName;
  //     var names = currentName.split(' ');
  //     final String currentEmpShortName =
  //         "${names[names.length - 2]} ${names.last}";
  //     WorkSummary workSummary = WorkSummary(
  //         shortName: 'shortName',
  //         processDetailQtys: [
  //           ProcessDetailQty(GxNo: 0, GxName: 'GxName', qty: 0)
  //         ],
  //         money: 0);
  //     List<ProcessDetailQty> processDetailQtys = [];
  //     for (int i = 0; i < g.sqlSumEmpQty.length; i++) {
  //       if (idEmpScaned == g.sqlSumEmpQty[i].EmpId) {
  //         final int GxNo = g.sqlSumEmpQty[i].getGxNo;
  //         final int qty = g.sqlSumEmpQty[i].getSumEmpQty;

  //         final String GxName = g.processDetail
  //             .firstWhere(
  //                 (element) => element.getNo == g.sqlSumEmpQty[i].getGxNo)
  //             .getName;
  //         final processDetailQty =
  //             ProcessDetailQty(GxNo: GxNo, GxName: GxName, qty: qty);
  //         processDetailQtys.add(processDetailQty);
  //         moneyEmp += qty *
  //             g.processDetail
  //                 .firstWhere(
  //                     (element) => element.getNo == processDetailQty.getGxNo)
  //                 .getUnitPrice;
  //         workSummary = WorkSummary(
  //             shortName: currentEmpShortName,
  //             processDetailQtys: processDetailQtys,
  //             money: moneyEmp);
  //       }
  //     }
  //     result.add(workSummary);
  //   }
  //   print('summaryDailyDataETS => ${result.length}');
  //   return result;
  // }

  static Future<bool> loadDataSQL(String type) async {
    print('loadDataSQL : $type');
    g.isLoading = true;
    switch (type) {
      case 'production': //load production db
        {
          g.chartData.clear();
          g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);
          g.chartUi = ChartUI.createChartUI(
              g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
          g.sqlT01 =
              await g.sqlProductionDB.getT01InspectionData(g.currentLine);
        }
        break;
      case 'changeLine': // changeLine
        {
          if (g.screenMode == 'chartProduction') {
          } else {
            g.currentMoDetail = g.moDetails
                .firstWhere((element) => element.getLine == g.currentLine);
            g.processDetail =
                await g.sqlETSDB.getProcessDetail(g.currentMoDetail.getCnid);
            g.currentIndexLine = g.linesETS.indexOf(g.currentLine);
            g.sqlSumNoQty = await g.sqlETSDB
                .getSqlSumNoQty(g.currentMoDetail.getMo, g.pickedDate);
            g.sqlCummulativeNoQty =
                await g.sqlETSDB.getSqlCummNoQty(g.currentMoDetail.getMo);
            MyFuntions.summaryDataETS();
          }
        }
        break;
      case 'refresh': // load line data , setting
        {
          g.configs = await g.sqlApp.sellectConfigs();
          g.configs.forEach((element) {
            if (g.ip == element.getIp) {
              g.config = element;
            }
          });
          if (g.screenMode == 'chartProduction') {
            //production
            g.currentIndexLine = g.lines.indexOf(g.currentLine);
            g.sqlT01 =
                await g.sqlProductionDB.getT01InspectionData(g.currentLine);
            g.chartData.clear();
            g.chartData = MyFuntions.sqlT01ToChartData(g.sqlT01);
            g.chartUi = ChartUI.createChartUI(
                g.chartData, 'Sản lượng & tỉ lệ lỗi'.toUpperCase());
          } else {
            //ETS
            // g.sqlSumEmpQty = a
            g.sqlSumNoQty = await g.sqlETSDB
                .getSqlSumNoQty(g.currentMoDetail.getMo, g.pickedDate);
            g.sqlCummulativeNoQty =
                await g.sqlETSDB.getSqlCummNoQty(g.currentMoDetail.getMo);
            MyFuntions.summaryDataETS();
          }
        }
        break;
      default:
    }
    g.isLoading = false;
    return (g.sqlSumEmpQty.isNotEmpty);
  }

  static int setLineFollowIP(String ip) {
    int line = 1;
    switch (ip) {
      case '192.168.1.71':
        {
          line = 1;
        }
        break;
      case '192.168.1.72':
        {
          line = 2;
        }
        break;
      case '192.168.1.73':
        {
          line = 3;
        }
        break;
      case '192.168.1.74':
        {
          line = 4;
        }
        break;
      case '192.168.1.75':
        {
          line = 5;
        }
        break;
      case '192.168.1.76':
        {
          line = 6;
        }
        break;
      case '192.168.1.77':
        {
          line = 7;
        }
        break;
      case '192.168.1.78':
        {
          line = 8;
        }
        break;
      case '192.168.1.79':
        {
          line = 9;
        }
        break;
      default:
        line = 1;
    }
    return line;
  }

  static Color getColorByLine(int line) {
    // // if (line % 2 == 0)
    // return Color.fromARGB(50, 100, 150, 150);
    // // else
    // //   return Color.fromARGB(80, 100, 150, 150);
    Color result = Colors.blueAccent;
    switch (line) {
      case 1:
        result = Color.fromARGB(50, 100, 150, 150);
        break;
      case 2:
        result = Color.fromARGB(70, 100, 150, 150);
        break;
      case 3:
        result = Color.fromARGB(90, 100, 150, 150);
        break;
      case 4:
        result = Color.fromARGB(50, 120, 200, 250);
        break;
      case 5:
        result = Color.fromARGB(70, 120, 200, 250);
        break;
      case 6:
        result = Color.fromARGB(90, 120, 200, 250);
        break;
      case 7:
        result = Color.fromARGB(50, 160, 200, 250);
        break;
      case 8:
        result = Color.fromARGB(70, 160, 200, 250);
        break;
      case 9:
        result = Color.fromARGB(90, 160, 200, 250);
        break;
      default:
        result = Colors.blue;
    }
    return result;
  }

  static Color getColorByPercent(double percent) {
    Color result = Colors.yellow;

    if (percent <= 0.25) {
      result = Colors.red;
    } else if (percent <= 0.5) {
      result = Colors.orange;
    } else if (percent <= 0.75) {
      result = Colors.amber;
    } else {
      result = Colors.green;
    }
    return result;
  }

  static Color getColorByQty(int qty, int target) {
    Color result = Colors.yellow;
    int ration = (qty / target * 100).round();
    if (ration <= 25) {
      result = Colors.redAccent;
    } else if (ration <= 50) {
      result = Colors.orange;
    } else if (ration <= 75) {
      result = Color.fromARGB(255, 249, 227, 25);
    } else {
      result = Colors.greenAccent;
    }
    return result;
  }

  static Color getColorByQty2(int qty, int target) {
    Color result = const Color.fromRGBO(248, 240, 168, 1);
    int ration = (qty / target * 100).round();
    if (ration <= 25) {
      result = const Color.fromARGB(255, 245, 31, 16);
    } else if (ration <= 50) {
      result = const Color.fromARGB(255, 216, 130, 2);
    } else if (ration <= 75) {
      result = Color.fromARGB(255, 240, 220, 37);
    } else {
      result = Color.fromARGB(255, 10, 186, 19);
    }
    return result;
  }

  static bool parseBool(int integer) {
    if (integer > 0) {
      return true;
    } else {
      return false;
    }
  }

  static List<ChartData> sqlT01ToChartData(List<SqlT01> dataInput) {
    List<SqlT01> input = [...dataInput];
    List<ChartData> result = [];
    List<String> dates = [];
    for (var element in input) {
      dates.add(element.getX02);
    }
    dates = dates.toSet().toList();
    for (var dateString in dates) {
      num qty1st = 0;
      num qty1stOK = 0;
      num qty1stNOK = 0;
      num qtyAfterRepaire = 0;
      num qtyOKAfterRepaire = 0;
      num rationDefect1st = 0;
      num rationDefectAfterRepaire = 0;
      for (var data in input) {
        if (dateString == data.getX02) {
          qty1st += data.getX06;
          qty1stOK += data.getX07;
          qtyAfterRepaire += data.getX08;
          qtyOKAfterRepaire += data.getX09;
        }
        qty1stNOK = qty1st - qty1stOK;
        rationDefect1st = double.parse((qty1stNOK / qty1st).toStringAsFixed(4));
        rationDefectAfterRepaire = double.parse(
            ((qtyAfterRepaire - qtyOKAfterRepaire) / qtyAfterRepaire)
                .toStringAsFixed(4));
      }
      ChartData data = ChartData(
          date: dateString,
          qty1st: qty1st,
          qty1stOK: qty1stOK,
          qty1stNOK: qty1stNOK,
          qtyAfterRepaire: qtyAfterRepaire,
          qtyOKAfterRepaire: qtyOKAfterRepaire,
          rationDefect1st: rationDefect1st,
          rationDefectAfterRepaire: rationDefectAfterRepaire);
      result.add(data);
    }
    return result;
  }

  static String getLinkImage(String orgLink) {
    // https://drive.google.com/file/d/1-3zgxOg_AyWoTkEu8F21WvNX-kcRwChB/view?usp=drive_link
    // file ID : 1-3zgxOg_AyWoTkEu8F21WvNX-kcRwChB
    // -> https://drive.google.com/uc?export=view&id=<FILE_ID>
    // https://drive.google.com/uc?export=view&id=1-3zgxOg_AyWoTkEu8F21WvNX-kcRwChB

    // https://drive.google.com/file/d/11HhYkZ00h6HwiUnXatTXUMUIuiVvrENK/view?usp=drive_link
    String link =
        // 'https://drive.google.com/uc?export=view&id=';
        'https://drive.google.com/uc?export=download&id=';
    try {
      String fileId = orgLink.substring(32, 65);
      // String fileId = orgLink
      //     .split('https://drive.google.com/file/d/')[0]
      //     .toString()
      //     .split('/view?usp=drive_link')[0]
      //     .toString();
      link += fileId;
      print('org link : $orgLink');
      print('fileId : $fileId');
      print('direct link -> : $link');
      return link;
    } catch (e) {
      print(e);
      return 'https://drive.google.com/uc?export=view&id=1-L3t8Rwj2DsVEeNzyGLgI7U7v06jaciL';
    }
  }

  static Future<void> playAudio() async {
    AssetsAudioPlayer.newPlayer().open(Audio("assets/notification_sound.wav"),
        autoStart: true, volume: 1.0);
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static DateTime findLastDateOfTheMonth(DateTime dateTime) {
    // print(
    //     'findLastDateOfTheMonth $dateTime => ${DateTime(dateTime.year, dateTime.month + 1, 0)}');
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }

  static DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    // print(
    //     'findFirstDateOfTheMonth $dateTime => ${DateTime(dateTime.year, dateTime.month, 1)}');
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  static int findWeekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static Color getRandomColor() {
    Random random = Random();
    Color color = Color.fromARGB(
        random.nextInt(50) + 100,
        random.nextInt(50) + 150,
        random.nextInt(50) + 150,
        random.nextInt(50) + 150);
    return color;
  }

  static Color getColorByWorklayer(String name) {
    Color color = Colors.yellow;
    switch (name) {
      case 'Than truoc':
      case 'Hoan thanh':
        color = Colors.yellow;
        break;
      case 'Non':
        color = Colors.blue;
        break;
      case 'Tay':
        color = Colors.green;
        break;
      default:
    }
    return color;
  }

  // static void createDataChartEtsWorkLayer() {
  //   g.workSummary.forEach((element) {
  //     element.getProcessDetailQtys.forEach((processDetailQty) {
  //       g.processDetailQtys.add(processDetailQty);
  //     });
  //   });
  //   g.processNotScan.forEach((element) {
  //     g.processDetailQtys
  //         .add(ProcessDetailQty(GxNo: element, GxName: 'GxName', qty: 0));
  //   });
  //   g.processDetailQtys.sort((a, b) => a.getGxNo.compareTo(b.getGxNo));
  //   g.workLayerNames.clear();
  //   for (int i = 1; i <= 9; i++) {
  //     List<ProcessDetailQty> processDetailQtyLayer = [];
  //     String layerName = '';
  //     g.processDetailQtys.forEach((element) {
  //       if ((element.getGxNo >= g.workLayers[i].getPperationBegin) &
  //           (element.getGxNo <= g.workLayers[i].getOperationEnd)) {
  //         processDetailQtyLayer.add(element);
  //         layerName = g.workLayers[i].getWorkLayerName;
  //       }
  //     });

  //     if (processDetailQtyLayer.length > 0) {
  //       g.workLayerNames.add(layerName);
  //       g.workLayerQtys.add(processDetailQtyLayer);
  //     }
  //   }
  // }

  static Widget clockAppBar(BuildContext context) {
    return Container(
      width: 120, height: g.appBarH,
      color: Colors.transparent,
      // height: g.appBarH ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DigitalClock(
            digitAnimationStyle: Curves.fastOutSlowIn,
            areaDecoration: BoxDecoration(color: Colors.transparent),
            hourMinuteDigitTextStyle: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: g.fontSizeAppbar),
            secondDigitTextStyle: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
            colon: Text(
              ":",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  static Widget getClock(BuildContext context) {
    return Container(
      width: 160,
      color: const Color.fromRGBO(0, 0, 0, 0.122),
      height: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DigitalClock(
            digitAnimationStyle: Curves.fastOutSlowIn,
            areaDecoration: BoxDecoration(color: Colors.transparent),
            hourMinuteDigitTextStyle: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 34),
            secondDigitTextStyle: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                ),
            colon: Text(
              ":",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 34),
            ),
          ),
        ],
      ),
    );
  }

  static Widget noData() {
    return Container(
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Image.asset('assets/noData.png'),
          ),
          const Text(
            'KHÔNG CÓ DỮ LIỆU !',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  static Widget loadFail() {
    return Container(
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Image.asset('assets/noData.png'),
          ),
          const Text(
            'Load failed ! Check wifi & restart App',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  static Widget showNotification() {
    playAudio();

    return FittedBox(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: g.screenWidth,
            height: g.screenHeight - g.appBarH,
            color: Colors.amberAccent[100],
            child: AutoSizeText(
              textAlign: TextAlign.start,
              softWrap: true,
              maxFontSize: 70,
              overflow: TextOverflow.ellipsis,
              minFontSize: 16,
              g.thongbao.getNoidung.toString(),
              style: TextStyle(
                  fontSize: 70,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold),
              maxLines: 25,
            ),
          ),
          Positioned(
            child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/speaker.gif')),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  static bool checkThongBao() {
    print(g.thongbao);
    DateTime time = DateTime.now();
    bool result = false;
    if (!g.thongbao.getOnOff) {
      g.title = "Sản lượng & tỉ lệ lỗi".toUpperCase();
      result = false;
    } else {
      DateTime timeBegin1 = g.thongbao.getThoigian1;
      DateTime timeEnd1 =
          timeBegin1.add(Duration(minutes: g.thongbao.getThoiluongPhut));
      DateTime timeBegin2 = g.thongbao.getThoigian2;
      DateTime timeEnd2 =
          timeBegin2.add(Duration(minutes: g.thongbao.getThoiluongPhut));
      DateTime timeBegin3 = g.thongbao.getThoigian3;
      DateTime timeEnd3 =
          timeBegin3.add(Duration(minutes: g.thongbao.getThoiluongPhut));

      if ((time.isAfter(timeBegin1) && time.isBefore(timeEnd1)) ||
          (time.isAfter(timeBegin2) && time.isBefore(timeEnd2)) ||
          (time.isAfter(timeBegin3) && time.isBefore(timeEnd3))) {
        g.title = g.thongbao.getTieude;
        result = true;
      }
    }
    print('checkThongBao : ' + result.toString());
    return result;
  }

  static Widget showLoading() {
    return Container(
        alignment: Alignment.center,
        color: Colors.white,
        width: g.screenWidth,
        height: g.screenHeight,
        child: SizedBox(
          width: 100,
          height: 200,
          child: Column(children: [
            Image.asset('assets/logo.png'),
            Image.asset('assets/loading.gif'),
          ]),
        ));
  }

  static summaryDataETS() {
    g.processDetail.forEach((process) {
      try {
        process.setQtyDaily = g.sqlSumNoQty
            .where((element) => element.getGxNo == process.getNo)
            .first
            .getSumNoQty;
      } catch (e) {
        process.setQtyDaily = 0;
      }
      try {
        process.setQtyTotal = g.sqlCummulativeNoQty
            .where((element) => element.getGxNo == process.getNo)
            .first
            .getCummulativeQty;
      } catch (e) {
        process.setQtyTotal = 0;
      }
    });
  }
}
