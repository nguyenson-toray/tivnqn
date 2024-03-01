import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/model/processDetail.dart';
import 'package:tivnqn/model/sqlSumNoQty.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/myFuntions.dart';

class DashboardETS extends StatefulWidget {
  const DashboardETS({super.key});

  @override
  State<DashboardETS> createState() => _DashboardETSState();
}

class _DashboardETSState extends State<DashboardETS> {
  var leftCollumnW = g.screenWidth / 4 - 2;
  var rightCollumnW = g.screenWidth / 4 * 3 - 4;
  ChartSeriesController? chartControllerETS;
  Legend myLegend = const Legend(
      itemPadding: 3,
      // height: '40%',
      textStyle: TextStyle(
          fontSize: 11, fontWeight: FontWeight.normal, color: Colors.black),
      position: LegendPosition.bottom,
      isVisible: true,
      overflowMode: LegendItemOverflowMode.wrap);
  DataLabelSettings myDataLabelSettings = const DataLabelSettings(
    labelAlignment: ChartDataLabelAlignment.auto,
    labelPosition: ChartDataLabelPosition.outside,
    alignment: ChartAlignment.center,
    isVisible: false,
    textStyle: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarETS(),
        body: Stack(children: [
          Container(
            padding: EdgeInsets.all(2),
            child: Row(
              children: [
                Container(
                    // color: Colors.amberAccent,
                    width: leftCollumnW,
                    height: g.screenHeight - g.appBarH - 4,
                    child: MasonryGridView.count(
                        padding: const EdgeInsets.all(2),
                        // itemCount: g.workSummary.length,
                        itemCount: g.processDetail.length,
                        // the number of columns
                        crossAxisCount: 1,
                        // vertical gap between two items
                        mainAxisSpacing: 2,
                        // horizontal gap between two items
                        crossAxisSpacing: 2,
                        itemBuilder: (context, index) {
                          ProcessDetail process = g.processDetail[index];
                          int qty = 0;

                          SqlSumNoQty element;
                          int i = 0;
                          for (var element in g.sqlSumNoQty) {
                            if (element.getGxNo == process.getNo) {
                              qty = element.getSumNoQty;
                              break;
                            }
                          }

                          return Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white,
                                  // color: MyFuntions.getColorByQty2(
                                  //     process[0].getQty, g.sqlMoInfo.getTargetDay),
                                  width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            color: Colors.cyan[50],
                            margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${process.getNo}'),
                                SizedBox(
                                  width: leftCollumnW / 3 * 2,
                                  child: Text(
                                    '${process.getName}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('${process.getQtyDaily}')
                              ],
                            ),
                          );
                          //****************** */
                          // return Container(
                          //   width: leftCollumnW - 4,
                          //   height: 30,
                          //   color: Colors.cyan,
                          //   child: ListTile(
                          //     leading:
                          //         Text(g.processDetail[index].getNo.toString()),
                          //     title: Text(
                          //       g.processDetail[index].getName.toString(),
                          //       overflow: TextOverflow.ellipsis,
                          //     ),
                          //     trailing: Text(g.processDetail[index].getUnitPrice
                          //         .toString()),
                          //   ),
                          // );

                          // List<ProcessDetailQty> process =
                          //     g.workSummary[index].getProcessDetailQtys;
                          // return Card(
                          //   shape: RoundedRectangleBorder(
                          //     side: const BorderSide(
                          //         color: Colors.white,
                          //         // color: MyFuntions.getColorByQty2(
                          //         //     process[0].getQty, g.sqlMoInfo.getTargetDay),
                          //         width: 1),
                          //     borderRadius: BorderRadius.circular(5),
                          //   ),
                          //   color: Colors.cyan[50],
                          //   margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                          //   child: Column(children: [
                          //     SizedBox(
                          //       height: process.length * 25,
                          //       child: MasonryGridView.count(
                          //         itemCount: process.length,
                          //         // the number of columns
                          //         crossAxisCount: 1,
                          //         // vertical gap between two items
                          //         mainAxisSpacing: 2,
                          //         // horizontal gap between two items
                          //         crossAxisSpacing: 2,
                          //         itemBuilder: (context, index2) {
                          //           return Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceAround,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.center,
                          //             children: [
                          //               Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceAround,
                          //                 children: [
                          //                   Container(
                          //                     padding:
                          //                         const EdgeInsets.fromLTRB(
                          //                             2, 1, 2, 1),
                          //                     width: g.screenWidth / 4 - 60,
                          //                     child: Text(
                          //                       '''${process[index2].getGxNo}-${process[index2].getGxName}''',
                          //                       overflow: TextOverflow.ellipsis,
                          //                       style: TextStyle(
                          //                         // fontSize: 10,
                          //                         color: process[index2]
                          //                                     .getGxNo ==
                          //                                 150
                          //                             ? Colors.deepPurpleAccent
                          //                             : Colors.black,
                          //                         fontWeight: process[index2]
                          //                                         .getGxNo >=
                          //                                     g
                          //                                         .processNoFinishBegin &&
                          //                                 process[index2]
                          //                                         .getGxNo <=
                          //                                     g.processNoFinishEnd
                          //                             ? FontWeight.bold
                          //                             : FontWeight.normal,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Text(
                          //                     '''${process[index2].getQty} Pcs''',
                          //                   )
                          //                 ],
                          //               ),
                          //               const Divider(
                          //                   height: 1, color: Colors.white),
                          //             ],
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //     // Container(
                          //     //   width: g.screenWidth / 3,
                          //     //   decoration: BoxDecoration(
                          //     //     color: MyFuntions.getColorByQty(
                          //     //         process[0].getQty, 100),
                          //     //     borderRadius: BorderRadius.circular(5),
                          //     //   ),
                          //     //   child: Text(
                          //     //       '${g.workSummary[index].getShortName.toString()}',
                          //     //       textAlign: TextAlign.center,
                          //     //       style: const TextStyle(
                          //     //           fontWeight: FontWeight.normal,
                          //     //           fontSize: 13,
                          //     //           color: Colors.black)),
                          //     // ),
                          //   ]),
                          // );
                        })),
                Container(
                    width: rightCollumnW,
                    child: SfCartesianChart(
                        legend: myLegend,
                        primaryXAxis: CategoryAxis(
                          labelPosition: ChartDataLabelPosition.outside,
                          labelStyle: TextStyle(
                            // fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        series: <CartesianSeries<SqlSumNoQty, String>>[
                          ColumnSeries<SqlSumNoQty, String>(
                              dataSource: g.sqlSumNoQty,
                              xValueMapper: (SqlSumNoQty data, _) =>
                                  data.getGxNo.toString(),
                              yValueMapper: (SqlSumNoQty data, _) =>
                                  data.getSumNoQty,
                              name: 'BIỂU ĐỒ SẢN LƯỢNG CÁC CÔNG ĐOẠN',
                              color: Color.fromRGBO(8, 142, 255, 1))
                        ])),
              ],
            ),
          ),
          Positioned(
              right: 2,
              bottom: 2,
              child: Text(
                'Version : ${g.version}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 6,
                    fontWeight: FontWeight.normal),
              ))
        ]));
  }

  appBarETS() {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 6.0,
      leadingWidth: 95,
      leading: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          maxRadius: g.appBarH / 2 - 2,
          minRadius: g.appBarH / 2 - 2,
          backgroundColor:
              // g.isLoading
              //     ? Colors.primaries[Random().nextInt(Colors.primaries.length)]
              //     :
              Colors.white,
          child: Center(
            child: Text(
              g.currentLine.toString(),
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      actions: [
        InkWell(
            onTap: () {},
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 40,
            )),
        InkWell(
            onTap: () {},
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 40,
            )),
        Switch(
          value: g.autochangeLine,
          onChanged: (value) {
            setState(() {
              g.autochangeLine = value;
            });
          },
        ),
        const Text(
          '''Auto
Change ''',
          style: TextStyle(color: Colors.white),
        ),
      ],
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          children: [
            Text('${g.currentMoDetail.getStyle.trim()}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: g.fontSizeAppbar)),
            Row(
              children: [
                Text(' ${g.currentMoDetail.getDesc.trim()}',
                    style: const TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 12)),
                Text(' - ${g.currentMoDetail.getQty.toString()} Pcs',
                    style: const TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat(g.dateFormat2).format(
                g.today,
              ),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            MyFuntions.clockAppBar(context),
          ],
        ),
      ]),
    );
  }
}
