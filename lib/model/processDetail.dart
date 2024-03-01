// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProcessDetail {
  String cind;
  int no;
  String code;
  String name;
  int qtyDaily;
  int qtyTotal;
  ProcessDetail({
    required this.cind,
    required this.no,
    required this.code,
    required this.name,
    required this.qtyDaily,
    required this.qtyTotal,
  });
  get getCind => this.cind;

  set setCind(cind) => this.cind = cind;

  get getNo => this.no;

  set setNo(no) => this.no = no;

  get getCode => this.code;

  set setCode(code) => this.code = code;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getQtyDaily => this.qtyDaily;

  set setQtyDaily(qtyDaily) => this.qtyDaily = qtyDaily;

  get getQtyTotal => this.qtyTotal;

  set setQtyTotal(qtyTotal) => this.qtyTotal = qtyTotal;

  ProcessDetail copyWith({
    String? cind,
    int? no,
    String? code,
    String? name,
    int? qtyDaily,
    int? qtyTotal,
  }) {
    return ProcessDetail(
      cind: cind ?? this.cind,
      no: no ?? this.no,
      code: code ?? this.code,
      name: name ?? this.name,
      qtyDaily: qtyDaily ?? this.qtyDaily,
      qtyTotal: qtyTotal ?? this.qtyTotal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cind': cind,
      'no': no,
      'code': code,
      'name': name,
      'qtyDaily': qtyDaily,
      'qtyTotal': qtyTotal,
    };
  }

  factory ProcessDetail.fromMap(Map<String, dynamic> map) {
    return ProcessDetail(
      cind: map['cind'] as String,
      no: map['no'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      qtyDaily: map['qtyDaily'] as int,
      qtyTotal: map['qtyTotal'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProcessDetail.fromJson(String source) =>
      ProcessDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProcessDetail(cind: $cind, no: $no, code: $code, name: $name, qtyDaily: $qtyDaily, qtyTotal: $qtyTotal)';
  }

  @override
  bool operator ==(covariant ProcessDetail other) {
    if (identical(this, other)) return true;

    return other.cind == cind &&
        other.no == no &&
        other.code == code &&
        other.name == name &&
        other.qtyDaily == qtyDaily &&
        other.qtyTotal == qtyTotal;
  }

  @override
  int get hashCode {
    return cind.hashCode ^
        no.hashCode ^
        code.hashCode ^
        name.hashCode ^
        qtyDaily.hashCode ^
        qtyTotal.hashCode;
  }
}
