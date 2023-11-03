import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PRelaxationFabric {
  int? id;
  DateTime? date;
  String? kindOfFabric;
  String? customer;
  String? artNo;
  String? lotNo;
  String? color;
  int? planQty;
  int? actualQty;
  PRelaxationFabric({
    this.id,
    this.date,
    this.kindOfFabric,
    this.customer,
    this.artNo,
    this.lotNo,
    this.color,
    this.planQty,
    this.actualQty,
  });

  @override
  String toString() {
    return 'PRelaxationFabric(id: $id, date: $date, kindOfFabric: $kindOfFabric, customer: $customer, artNo: $artNo, lotNo: $lotNo, color: $color, planQty: $planQty, actualQty: $actualQty)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'kindOfFabric': kindOfFabric,
      'customer': customer,
      'artNo': artNo,
      'lotNo': lotNo,
      'color': color,
      'planQty': planQty,
      'actualQty': actualQty,
    };
  }

  factory PRelaxationFabric.fromMap(Map<String, dynamic> map) {
    return PRelaxationFabric(
      id: map['id'] != null ? map['id'] as int : null,
      date:
          map['date'] != null ? DateTime.parse(map['date']) as DateTime : null,
      kindOfFabric:
          map['kindOfFabric'] != null ? map['kindOfFabric'] as String : null,
      customer: map['customer'] != null ? map['customer'] as String : null,
      artNo: map['artNo'] != null ? map['artNo'] as String : null,
      lotNo: map['lotNo'] != null ? map['lotNo'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      planQty: map['planQty'] != null ? map['planQty'] as int : null,
      actualQty: map['actualQty'] != null ? map['actualQty'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PRelaxationFabric.fromJson(String source) =>
      PRelaxationFabric.fromMap(json.decode(source) as Map<String, dynamic>);
}
