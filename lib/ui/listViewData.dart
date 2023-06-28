import 'package:flutter/material.dart';
import 'package:tivnqn/global.dart';

class ListViewData extends StatefulWidget {
  const ListViewData({super.key});

  @override
  State<ListViewData> createState() => _ListViewDataState();
}

class _ListViewDataState extends State<ListViewData> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Text(g.sqlSumQty[index].getGxNo.toString()),
                trailing: Text(g.sqlSumQty[index].getSumQty.toString()),
                title: Text(g.sqlSumQty[index].EmpId),
              ),
            );
          },
          itemCount: g.sqlSumQty.length),
    );
  }
}
