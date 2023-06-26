import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlSumQty {
  int opNo;
  String EmpId;
  int sumQty;
  SqlSumQty({
    required this.opNo,
    required this.EmpId,
    required this.sumQty,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'opNo': opNo,
      'EmpId': EmpId,
      'sumQty': sumQty,
    };
  }

  factory SqlSumQty.fromMap(Map<String, dynamic> map) {
    return SqlSumQty(
      opNo: map['opNo'] as int,
      EmpId: map['EmpId'] as String,
      sumQty: map['sumQty'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SqlSumQty.fromJson(String source) =>
      SqlSumQty.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SqlSumQty(opNo: $opNo, EmpId: $EmpId, sumQty: $sumQty)';
}
