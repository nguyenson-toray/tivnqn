import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Worklayer {
  int? worklayerNo;
  String? workLayerName;
  int? operationBegin;
  int? operationEnd;
  get getWorklayerNo => this.worklayerNo;

  set setWorklayerNo(worklayerNo) => this.worklayerNo = worklayerNo;

  get getWorkLayerName => this.workLayerName;

  set setWorkLayerName(workLayerName) => this.workLayerName = workLayerName;

  get getPperationBegin => this.operationBegin;

  set setPperationBegin(pperationBegin) => this.operationBegin = pperationBegin;

  get getOperationEnd => this.operationEnd;

  set setOperationEnd(operationEnd) => this.operationEnd = operationEnd;
  Worklayer({
    this.worklayerNo,
    this.workLayerName,
    this.operationBegin,
    this.operationEnd,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'worklayerNo': worklayerNo,
      'workLayerName': workLayerName,
      'operationBegin': operationBegin,
      'operationEnd': operationEnd,
    };
  }

  factory Worklayer.fromMap(Map<String, dynamic> map) {
    return Worklayer(
      worklayerNo:
          map['WorklayerNo'] != null ? map['WorklayerNo'] as int : null,
      workLayerName:
          map['WorkLayerName'] != null ? map['WorkLayerName'] as String : null,
      operationBegin:
          map['OperationBegin'] != null ? map['OperationBegin'] as int : null,
      operationEnd:
          map['Operationend'] != null ? map['Operationend'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Worklayer.fromJson(String source) =>
      Worklayer.fromMap(json.decode(source) as Map<String, dynamic>);
}
