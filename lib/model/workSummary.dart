// ignore_for_file: public_member_api_docs, sort_constructors_first
class WorkSummary {
  String shortName;
  List<ProcessDetailQty> processDetailQtys;
  get getShortName => shortName;

  set setShortName(shortName) => this.shortName = shortName;

  get getProcessDetailQtys => processDetailQtys;

  set setProcessDetailQtys(processDetailQtys) =>
      this.processDetailQtys = processDetailQtys;

  WorkSummary({
    required this.shortName,
    required this.processDetailQtys,
  });

  @override
  String toString() =>
      'WorkSummary(shortName: $shortName, processDetailQtys: $processDetailQtys, this.processDetailQtys: ${processDetailQtys.toString})';
}

class ProcessDetailQty {
  int GxNo;
  String GxName;
  int qty;
  get getGxNo => GxNo;

  set setGxNo(GxNo) => this.GxNo = GxNo;

  get getGxName => GxName;

  set setGxName(GxName) => this.GxName = GxName;

  get getQty => qty;

  set setQty(qty) => this.qty = qty;
  ProcessDetailQty({
    required this.GxNo,
    required this.GxName,
    required this.qty,
  });

  @override
  String toString() =>
      'ProcessDetailQty(GxNo: $GxNo, GxName: $GxName, qty: $qty)';
}
