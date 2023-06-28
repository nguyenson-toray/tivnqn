import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlEmployee {
  String empId;
  String empName;
  get getEmpId => this.empId;

  set setEmpId(empId) => this.empId = empId;

  get getEmpName => this.empName;

  set setEmpName(empName) => this.empName = empName;
  SqlEmployee({
    required this.empId,
    required this.empName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'empId': empId,
      'empName': empName,
    };
  }

  factory SqlEmployee.fromMap(Map<String, dynamic> map) {
    return SqlEmployee(
      empId: map['empId'] as String,
      empName: map['empName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SqlEmployee.fromJson(String source) =>
      SqlEmployee.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SqlEmployee(empId: $empId, empName: $empName)';
}
