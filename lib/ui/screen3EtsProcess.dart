import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';

class Screen3EtsProcess extends StatefulWidget {
  const Screen3EtsProcess({super.key});

  @override
  State<Screen3EtsProcess> createState() => _Screen3EtsProcessState();
}

class _Screen3EtsProcessState extends State<Screen3EtsProcess> {
  final itemSize = g.processDetail.length;
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
        padding: const EdgeInsets.all(2),
        itemCount: g.processDetail.length,
        // the number of columns
        crossAxisCount: 5,
        // vertical gap between two items
        mainAxisSpacing: 1,
        // horizontal gap between two items
        crossAxisSpacing: 1,
        itemBuilder: (context, index) {
          int no = 0;
          int qty = 0;
          int cumm = 0;
          var noAndName =
              '${g.processDetail[index].getNo}-${g.processDetail[index].getName}';
          no = g.processDetail[index].getNo;
          try {
            qty = g.sqlSumNoQty
                .firstWhere((element) => element.getGxNo == no)
                .getSumNoQty;
          } catch (e) {}

          try {
            cumm = g.sqlCummulativeNoQty
                .firstWhere((element) => element.getGxNo == no)
                .getCummulativeQty;
          } catch (e) {}
          String qtyCumm = '$qty/$cumm';
          int qtyCummLength = qtyCumm.length;

          return Card(
            // color: MyFuntions.getColorByQty2(qty, g.sqlMoInfo.getTargetDay),
            color: Colors.teal[50],
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: g.screenWidth / 5 - 20 - qtyCummLength * 7,
                  child: Text(
                    noAndName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '$qty',
                      style: TextStyle(
                          color: MyFuntions.getColorByQty2(
                              qty, g.currentMoDetail.getTargetDay),
                          fontWeight:
                              qty == 0 ? FontWeight.bold : FontWeight.normal),
                    ),
                    Text(
                      '/$cumm',
                      style: TextStyle(
                          color: cumm == 0 ? Colors.red : Colors.black,
                          fontWeight:
                              cumm == 0 ? FontWeight.bold : FontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
