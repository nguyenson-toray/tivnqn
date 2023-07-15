
// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlSumEmpQty {
  int GxNo;
  String EmpId;
  int SumEmpQty;
  get getGxNo => GxNo;

  set setGxNo(GxNo) => this.GxNo = GxNo;

  get getEmpId => EmpId;

  set setEmpId(EmpId) => this.EmpId = EmpId;

  get getSumEmpQty => SumEmpQty;

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
