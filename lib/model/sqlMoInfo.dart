// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlMoInfo {
  int line;
  String mo;
  String style;
  int qty;
  int targetDay;
  int lastProcess;
  get getLine => this.line;

  set setLine(line) => this.line = line;

  get getMo => this.mo;

  set setMo(mo) => this.mo = mo;

  get getStyle => this.style;

  set setStyle(style) => this.style = style;

  get getQty => this.qty;

  set setQty(qty) => this.qty = qty;

  get getTargetDay => this.targetDay;

  set setTargetDay(targetDay) => this.targetDay = targetDay;

  get getLastProcess => this.lastProcess;

  set setLastProcess(lastProcess) => this.lastProcess = lastProcess;
  SqlMoInfo({
    required this.line,
    required this.mo,
    required this.style,
    required this.qty,
    required this.targetDay,
    required this.lastProcess,
  });

  @override
  String toString() {
    return 'SqlMoInfo(line: $line, mo: $mo, style: $style, qty: $qty, targetDay: $targetDay, lastProcess: $lastProcess)';
  }
}
