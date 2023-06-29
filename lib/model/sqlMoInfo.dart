// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlMoInfo {
  int line;
  String mo;
  String style;
  int qty;
  get getLine => this.line;

  set setLine(line) => this.line = line;

  get getMo => this.mo;

  set setMo(mo) => this.mo = mo;

  get getStyle => this.style;

  set setStyle(style) => this.style = style;

  get getQty => this.qty;

  set setQty(qty) => this.qty = qty;
  SqlMoInfo({
    required this.line,
    required this.mo,
    required this.style,
    required this.qty,
  });

  @override
  String toString() {
    return 'SqlMoInfo(line: $line, mo: $mo, style: $style, qty: $qty)';
  }
}
