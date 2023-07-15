// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlSumNoQty {
  int GxNo;
  int SumNoQty;
  int get getGxNo => GxNo;

  set setGxNo(int GxNo) => this.GxNo = GxNo;

  get getSumNoQty => SumNoQty;

  set setSumNoQty(SumNoQty) => this.SumNoQty = SumNoQty;
  SqlSumNoQty({
    required this.GxNo,
    required this.SumNoQty,
  });

  @override
  String toString() => 'SqlSumNoQty(GxNo: $GxNo, SumNoQty: $SumNoQty)';
}
