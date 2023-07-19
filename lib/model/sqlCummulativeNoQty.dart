// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlCummulativeNoQty {
  int GxNo;
  int CummulativeQty;
  get getGxNo => this.GxNo;

  set setGxNo(GxNo) => this.GxNo = GxNo;

  get getCummulativeQty => this.CummulativeQty;

  set setCummulativeQty(CummulativeQty) => this.CummulativeQty = CummulativeQty;
  SqlCummulativeNoQty({
    required this.GxNo,
    required this.CummulativeQty,
  });

  @override
  String toString() =>
      'SqlCummNoQty(GxNo: $GxNo, CummulativeQty: $CummulativeQty)';
}
