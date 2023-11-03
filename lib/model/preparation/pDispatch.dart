import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PDispatch {
  int? id;
  String? date;
  String? line;
  String? brand;
  String? styleNo;
  int? orderQty;
  String? color;
  String? size;
  int? planQty;
  int? actualQty;
  PDispatch({
    this.id,
    this.date,
    this.line,
    this.brand,
    this.styleNo,
    this.orderQty,
    this.color,
    this.size,
    this.planQty,
    this.actualQty,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'line': line,
      'brand': brand,
      'styleNo': styleNo,
      'orderQty': orderQty,
      'color': color,
      'size': size,
      'planQty': planQty,
      'actualQty': actualQty,
    };
  }

  factory PDispatch.fromMap(Map<String, dynamic> map) {
    return PDispatch(
      id: map['id'] != null ? map['id'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
      line: map['line'] != null ? map['line'] as String : null,
      brand: map['brand'] != null ? map['brand'] as String : null,
      styleNo: map['styleNo'] != null ? map['styleNo'] as String : null,
      orderQty: map['orderQty'] != null ? map['orderQty'] as int : null,
      color: map['color'] != null ? map['color'] as String : null,
      size: map['size'] != null ? map['size'] as String : null,
      planQty: map['planQty'] != null ? map['planQty'] as int : null,
      actualQty: map['actualQty'] != null ? map['actualQty'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PDispatch.fromJson(String source) =>
      PDispatch.fromMap(json.decode(source) as Map<String, dynamic>);
}
