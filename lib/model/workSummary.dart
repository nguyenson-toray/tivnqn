// ignore_for_file: public_member_api_docs, sort_constructors_first
class WorkSummary {
  String shortName;
  List<ProcessDetailQty> processDetailQtys;
  double money;
  get getShortName => this.shortName;

  set setShortName(shortName) => this.shortName = shortName;

  get getProcessDetailQtys => this.processDetailQtys;

  set setProcessDetailQtys(processDetailQtys) =>
      this.processDetailQtys = processDetailQtys;

  get getMoney => this.money;

  set setMoney(money) => this.money = money;

  WorkSummary({
    required this.shortName,
    required this.processDetailQtys,
    required this.money,
  });
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
