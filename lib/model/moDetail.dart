// ignore_for_file: public_member_api_docs, sort_constructors_first
class MoDetail {
  int line;
  String mo;
  String style;
  String desc;
  int qty;
  String cnid;
  int targetDay;
  int lastProcess;
  get getLine => this.line;

  set setLine(line) => this.line = line;

  get getMo => this.mo;

  set setMo(mo) => this.mo = mo;

  get getStyle => this.style;

  set setStyle(style) => this.style = style;

  get getDesc => this.desc;

  set setDesc(desc) => this.desc = desc;

  get getQty => this.qty;

  set setQty(qty) => this.qty = qty;

  get getCnid => this.cnid;

  set setCnid(cnid) => this.cnid = cnid;

  get getTargetDay => this.targetDay;

  set setTargetDay(targetDay) => this.targetDay = targetDay;

  get getLastProcess => this.lastProcess;

  set setLastProcess(lastProcess) => this.lastProcess = lastProcess;
  MoDetail({
    required this.line,
    required this.mo,
    required this.style,
    required this.desc,
    required this.qty,
    required this.cnid,
    required this.targetDay,
    required this.lastProcess,
  });

  @override
  String toString() {
    return 'MoDetail(line: $line, mo: $mo, style: $style, desc: $desc, qty: $qty, cnid: $cnid, targetDay: $targetDay, lastProcess: $lastProcess)';
  }
}
