import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:tivnqn/model/workSummary.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';

class Screen2EtsName extends StatefulWidget {
  const Screen2EtsName({super.key});

  @override
  State<Screen2EtsName> createState() => _Screen2EtsNameState();
}

class _Screen2EtsNameState extends State<Screen2EtsName> {
  @override
  Widget build(BuildContext context) {
    return g.workSummary.isEmpty
        ? Column(
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
          )
        : Column(children: [
            SizedBox(
              height: g.screenHeight - g.appBarH - g.footerH,
              child: MasonryGridView.count(
                padding: const EdgeInsets.all(2),
                itemCount: g.workSummary.length,
                // the number of columns
                crossAxisCount: 6,
                // vertical gap between two items
                mainAxisSpacing: 2,
                // horizontal gap between two items
                crossAxisSpacing: 2,
                itemBuilder: (context, index) {
                  List<ProcessDetailQty> process =
                      g.workSummary[index].getProcessDetailQtys;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Colors.white,
                          // color: MyFuntions.getColorByQty2(
                          //     process[0].getQty, g.sqlMoInfo.getTargetDay),
                          width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.cyan[50],
                    margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    child: Column(children: [
                      SizedBox(
                        height: process.length * 25,
                        child: MasonryGridView.count(
                          itemCount: process.length,
                          // the number of columns
                          crossAxisCount: 1,
                          // vertical gap between two items
                          mainAxisSpacing: 2,
                          // horizontal gap between two items
                          crossAxisSpacing: 2,
                          itemBuilder: (context, index2) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 1, 2, 1),
                                      width: (g.screenWidth - 195) / 6,
                                      child: Text(
                                        '''${process[index2].getGxNo}-${process[index2].getGxName}''',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // fontSize: 10,
                                          color: process[index2].getGxNo == 150
                                              ? Colors.deepPurpleAccent
                                              : Colors.black,
                                          fontWeight: process[index2].getGxNo >=
                                                      g.processNoFinishBegin &&
                                                  process[index2].getGxNo <=
                                                      g.processNoFinishEnd
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '''${process[index2].getQty}''',
                                    )
                                  ],
                                ),
                                const Divider(height: 1, color: Colors.white),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        width: g.screenWidth / 6,
                        decoration: BoxDecoration(
                          color:
                              MyFuntions.getColorByQty(process[0].getQty, 100),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            process[0].getQty > 100
                                ?
                                // SizedBox(
                                //     height: 17, child: Image.asset('assets/star.gif'))
                                const Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                // : (process[0].getQty <= 0.25 * g.sqlMoInfo.getTargetDay &&
                                //         DateTime.now().hour > 12)
                                //     ? Icon(
                                //         Icons.warning,
                                //         color: Colors.white,
                                //       )
                                : Container(),
                            Text(
                                '${g.workSummary[index].getShortName.toString()}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    color: Colors.black)),
                            Text(
                                g.enableMoney
                                    ? g.currencyFormat
                                        .format(g.workSummary[index].getMoney)
                                    : '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    color: Colors.white))
                          ],
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
            SizedBox(
              height: g.footerH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('hh:mm').format(DateTime.now()),
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  g.processNotScan.isNotEmpty
                      ? Image.asset('assets/warning2.gif')
                      : Image.asset('assets/firework.png'),
                  g.processNotScan.isNotEmpty
                      ? SizedBox(
                          height: g.footerH,
                          width: g.screenWidth - 160,
                          child: Marquee(
                              blankSpace: 300,
                              velocity: 45.0,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),
                              text:
                                  '''${g.processNotScan.length} CĐ chưa có sản lượng : ${g.processNotScan}'''),
                        )
                      : const Text(
                          '100% CĐ có sản lượng !',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                  Text(
                    'Version : ${g.version}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            )
          ]);
  }
}
