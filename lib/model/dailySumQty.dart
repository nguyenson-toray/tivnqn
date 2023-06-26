// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DailySumQty {
  int id = -1;
  int opNo = 0;
  String opName = '';
  String empId = '';
  String empName = '';
  int sumQty = 0;
  DailySumQty({
    required this.id,
    required this.opNo,
    required this.opName,
    required this.empId,
    required this.empName,
    required this.sumQty,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'opNo': opNo,
      'opName': opName,
      'empId': empId,
      'empName': empName,
      'sumQty': sumQty,
    };
  }

  factory DailySumQty.fromMap(Map<String, dynamic> map) {
    return DailySumQty(
      id: map['id'] as int,
      opNo: map['opNo'] as int,
      opName: map['opName'] as String,
      empId: map['empId'] as String,
      empName: map['empName'] as String,
      sumQty: map['sumQty'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailySumQty.fromJson(String source) =>
      DailySumQty.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DailySumQty(id: $id, opNo: $opNo, opName: $opName, empId: $empId, empName: $empName, sumQty: $sumQty)';
  }
}
