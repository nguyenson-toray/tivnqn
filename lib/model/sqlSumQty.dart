import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlSumQty {
  int GxNo;
  String EmpId;
  int SumQty;
  get getGxNo => this.GxNo;

  set setGxNo(GxNo) => this.GxNo = GxNo;

  get getEmpId => this.EmpId;

  set setEmpId(EmpId) => this.EmpId = EmpId;

  get getSumQty => this.SumQty;

  set setSumQty(SumQty) => this.SumQty = SumQty;

  SqlSumQty({
    required this.GxNo,
    required this.EmpId,
    required this.SumQty,
  });

  @override
  String toString() => 'SqlSumQty(GxNo: $GxNo, EmpId: $EmpId, SumQty: $SumQty)';
}
