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
        padding: EdgeInsets.all(2),
        itemCount: g.processAll.length,
        // the number of columns
        crossAxisCount: 5,
        // vertical gap between two items
        mainAxisSpacing: 1,
        // horizontal gap between two items
        crossAxisSpacing: 1,
        itemBuilder: (context, index) {
          int qty = 0;
          try {
            qty = (g.sqlSumNoQty.firstWhere((element) =>
                element.getGxNo == g.processDetail[index].getNo)).getSumNoQty;
          } catch (e) {
            print(e);
          }
          var noAndName =
              '${g.processDetail[index].getNo} : ${g.processDetail[index].getName}';
          return Card(
            // color: MyFuntions.getColorByQty2(qty, g.sqlMoInfo.getTargetDay),
            color: Colors.teal[50],
            shape: RoundedRectangleBorder(
              // side: BorderSide(color: Colors.tealAccent, width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (g.screenWidth - 180) / 5,
                  child: Text(
                    noAndName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$qty',
                  style: TextStyle(
                      color: MyFuntions.getColorByQty2(
                          qty, g.sqlMoInfo.getTargetDay),
                      fontWeight:
                          qty == 0 ? FontWeight.bold : FontWeight.normal),
                )
              ],
            ),
          );
        });
  }
}
