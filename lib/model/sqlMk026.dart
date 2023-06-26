import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlMK026 {
  int opNo;
  String opName;
  SqlMK026({
    required this.opNo,
    required this.opName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'opNo': opNo,
      'opName': opName,
    };
  }

  factory SqlMK026.fromMap(Map<String, dynamic> map) {
    return SqlMK026(
      opNo: int.parse(map['opNo']),
      opName: map['opName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SqlMK026.fromJson(String source) =>
      SqlMK026.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SqlMK026(opNo: $opNo, opName: $opName)';
}
