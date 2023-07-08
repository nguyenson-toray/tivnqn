// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppSetting {
  String lines;
  int timeChangeLine;
  int timeReload;
  int rangeDays;
  int showNotification;
  String notificationURL;
  String showBegin;
  int showDuration;
  String chartBegin;
  int chartDuration;
  String ipTvLine;
  get getLines => this.lines;

  set setLines(lines) => this.lines = lines;

  get getTimeChangeLine => this.timeChangeLine;

  set setTimeChangeLine(timeChangeLine) => this.timeChangeLine = timeChangeLine;

  get getTimeReload => this.timeReload;

  set setTimeReload(timeReload) => this.timeReload = timeReload;

  get getRangeDays => this.rangeDays;

  set setRangeDays(rangeDays) => this.rangeDays = rangeDays;

  get getShowNotification => this.showNotification;

  set setShowNotification(showNotification) =>
      this.showNotification = showNotification;

  get getNotificationURL => this.notificationURL;

  set setNotificationURL(notificationURL) =>
      this.notificationURL = notificationURL;

  get getShowBegin => this.showBegin;

  set setShowBegin(showBegin) => this.showBegin = showBegin;

  get getShowDuration => this.showDuration;

  set setShowDuration(showDuration) => this.showDuration = showDuration;

  get getChartBegin => this.chartBegin;

  set setChartBegin(chartBegin) => this.chartBegin = chartBegin;

  get getChartDuration => this.chartDuration;

  set setChartDuration(chartDuration) => this.chartDuration = chartDuration;

  get getIpTvLine => this.ipTvLine;

  set setIpTvLine(ipTvLine) => this.ipTvLine = ipTvLine;
  AppSetting({
    required this.lines,
    required this.timeChangeLine,
    required this.timeReload,
    required this.rangeDays,
    required this.showNotification,
    required this.notificationURL,
    required this.showBegin,
    required this.showDuration,
    required this.chartBegin,
    required this.chartDuration,
    required this.ipTvLine,
  });

  @override
  String toString() {
    return 'AppSetting(lines: $lines, timeChangeLine: $timeChangeLine, timeReload: $timeReload, rangeDays: $rangeDays, showNotification: $showNotification, notificationURL: $notificationURL, showBegin: $showBegin, showDuration: $showDuration, chartBegin: $chartBegin, chartDuration: $chartDuration, ipTvLine: $ipTvLine)';
  }
}
