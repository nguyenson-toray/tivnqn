// ignore_for_file: public_member_api_docs, sort_constructors_first
class Setting {
  int reloadTimeSeconds;
  int showNotification;
  String text;
  String imgURL;
  String showBegin;
  String showEnd;
  String chartBegin;
  String chartEnd;
  int rangeDay;
  String ipTvLine;
  int minuteChangeLine;
  String lines;
  get getReloadTimeSeconds => this.reloadTimeSeconds;

  set setReloadTimeSeconds(reloadTimeSeconds) =>
      this.reloadTimeSeconds = reloadTimeSeconds;

  get getShowNotification => this.showNotification;

  set setShowNotification(showNotification) =>
      this.showNotification = showNotification;

  get getText => this.text;

  set setText(text) => this.text = text;

  get getImgURL => this.imgURL;

  set setImgURL(imgURL) => this.imgURL = imgURL;

  get getShowBegin => this.showBegin;

  set setShowBegin(showBegin) => this.showBegin = showBegin;

  get getShowEnd => this.showEnd;

  set setShowEnd(showEnd) => this.showEnd = showEnd;

  get getChartBegin => this.chartBegin;

  set setChartBegin(chartBegin) => this.chartBegin = chartBegin;

  get getChartEnd => this.chartEnd;

  set setChartEnd(chartEnd) => this.chartEnd = chartEnd;

  get getRangeDay => this.rangeDay;

  set setRangeDay(rangeDay) => this.rangeDay = rangeDay;

  get getIpTvLine => this.ipTvLine;

  set setIpTvLine(ipTvLine) => this.ipTvLine = ipTvLine;

  get getMinuteChangeLine => this.minuteChangeLine;

  set setMinuteChangeLine(minuteChangeLine) =>
      this.minuteChangeLine = minuteChangeLine;
  Setting({
    required this.reloadTimeSeconds,
    required this.showNotification,
    required this.text,
    required this.imgURL,
    required this.showBegin,
    required this.showEnd,
    required this.chartBegin,
    required this.chartEnd,
    required this.rangeDay,
    required this.ipTvLine,
    required this.minuteChangeLine,
    required this.lines,
  });

  get getLines => this.lines;

  set setLines(lines) => this.lines = lines;

  @override
  String toString() {
    return 'Setting(reloadTimeSeconds: $reloadTimeSeconds, showNotification: $showNotification, text: $text, imgURL: $imgURL, showBegin: $showBegin, showEnd: $showEnd, chartBegin: $chartBegin, chartEnd: $chartEnd, rangeDay: $rangeDay, ipTvLine: $ipTvLine, minuteChangeLine: $minuteChangeLine, lines: $lines)';
  }
}
