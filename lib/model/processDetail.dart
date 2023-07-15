import 'dart:convert';

class ProcessDetail {
  String cind;
  int no;
  String code;
  String name;
  get getCind => cind;

  set setCind(cind) => this.cind = cind;

  get getNo => no;

  set setNo(no) => this.no = no;

  get getCode => code;

  set setCode(code) => this.code = code;

  get getName => name;

  set setName(name) => this.name = name;
  ProcessDetail({
    required this.cind,
    required this.no,
    required this.code,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cind': cind,
      'no': no,
      'code': code,
      'name': name,
    };
  }

  factory ProcessDetail.fromMap(Map<String, dynamic> map) {
    return ProcessDetail(
      cind: map['cind'] as String,
      no: map['no'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProcessDetail.fromJson(String source) =>
      ProcessDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProcessDetail(cind: $cind, no: $no, code: $code, name: $name)';
  }
}
