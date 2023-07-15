// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlMoSetting {
  int line;
  String mo;
  int lastProcess;
  int targetDay;

  get getLine => line;

  set setLine(line) => this.line = line;

  get getMo => mo;

  set setMo(mo) => this.mo = mo;

  get getTargetDay => targetDay;

  set setTargetDay(targetDay) => this.targetDay = targetDay;

  get getLastProcess => lastProcess;

  set setLastProcess(lastProcess) => this.lastProcess = lastProcess;
  SqlMoSetting({
    required this.line,
    required this.mo,
    required this.targetDay,
    required this.lastProcess,
  });

  @override
  String toString() {
    return 'SqlMoSetting(line: $line, mo: $mo, targetDay: $targetDay, lastProcess: $lastProcess)';
  }
}
