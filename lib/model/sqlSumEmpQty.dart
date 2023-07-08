import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlSumEmpQty {
  int GxNo;
  String EmpId;
  int SumEmpQty;
  get getGxNo => this.GxNo;

  set setGxNo(GxNo) => this.GxNo = GxNo;

  get getEmpId => this.EmpId;

  set setEmpId(EmpId) => this.EmpId = EmpId;

  get getSumEmpQty => this.SumEmpQty;

  set setSumEmpQty(SumEmpQty) => this.SumEmpQty = SumEmpQty;

  SqlSumEmpQty({
    required this.GxNo,
    required this.EmpId,
    required this.SumEmpQty,
  });

  @override
  String toString() =>
      'SqlSumEmpQty(GxNo: $GxNo, EmpId: $EmpId, SumEmpQty: $SumEmpQty)';
}
