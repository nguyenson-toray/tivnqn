// ignore_for_file: public_member_api_docs, sort_constructors_first
class Planning {
  int line;
  String style;
  int quantity;
  DateTime beginDate;
  DateTime endDate;
  String comment;
  get getLine => this.line;

  set setLine(line) => this.line = line;

  get getStyle => this.style;

  set setStyle(style) => this.style = style;

  get getQuantity => this.quantity;

  set setQuantity(quantity) => this.quantity = quantity;

  get getBeginDate => this.beginDate;

  set setBeginDate(beginDate) => this.beginDate = beginDate;

  get getEndDate => this.endDate;

  set setEndDate(endDate) => this.endDate = endDate;

  get getComment => this.comment;

  set setComment(comment) => this.comment = comment;
  Planning({
    required this.line,
    required this.style,
    required this.quantity,
    required this.beginDate,
    required this.endDate,
    required this.comment,
  });

  @override
  String toString() {
    return 'Planning(line: $line, style: $style, quantity: $quantity, beginDate: $beginDate, endDate: $endDate, comment: $comment)';
  }
}
