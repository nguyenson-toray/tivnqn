import 'dart:convert';

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
  });

  Setting copyWith({
    int? reloadTimeSeconds,
    int? showNotification,
    String? text,
    String? imgURL,
    String? showBegin,
    String? showEnd,
    String? chartBegin,
    String? chartEnd,
    int? rangeDay,
  }) {
    return Setting(
      reloadTimeSeconds: reloadTimeSeconds ?? this.reloadTimeSeconds,
      showNotification: showNotification ?? this.showNotification,
      text: text ?? this.text,
      imgURL: imgURL ?? this.imgURL,
      showBegin: showBegin ?? this.showBegin,
      showEnd: showEnd ?? this.showEnd,
      chartBegin: chartBegin ?? this.chartBegin,
      chartEnd: chartEnd ?? this.chartEnd,
      rangeDay: rangeDay ?? this.rangeDay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reloadTimeSeconds': reloadTimeSeconds,
      'showNotification': showNotification,
      'text': text,
      'imgURL': imgURL,
      'showBegin': showBegin,
      'showEnd': showEnd,
      'chartBegin': chartBegin,
      'chartEnd': chartEnd,
      'rangeDay': rangeDay,
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      reloadTimeSeconds: map['reloadTimeSeconds'] as int,
      showNotification: map['showNotification'] as int,
      text: map['text'] as String,
      imgURL: map['imgURL'] as String,
      showBegin: map['showBegin'] as String,
      showEnd: map['showEnd'] as String,
      chartBegin: map['chartBegin'] as String,
      chartEnd: map['chartEnd'] as String,
      rangeDay: map['rangeDay'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Setting.fromJson(String source) =>
      Setting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Setting(reloadTimeSeconds: $reloadTimeSeconds, showNotification: $showNotification, text: $text, imgURL: $imgURL, showBegin: $showBegin, showEnd: $showEnd, chartBegin: $chartBegin, chartEnd: $chartEnd, rangeDay: $rangeDay, this.reloadTimeSeconds: $this.reloadTimeSeconds, this.showNotification: $this.showNotification)';
  }

  @override
  bool operator ==(covariant Setting other) {
    if (identical(this, other)) return true;

    return other.reloadTimeSeconds == reloadTimeSeconds &&
        other.showNotification == showNotification &&
        other.text == text &&
        other.imgURL == imgURL &&
        other.showBegin == showBegin &&
        other.showEnd == showEnd &&
        other.chartBegin == chartBegin &&
        other.chartEnd == chartEnd &&
        other.rangeDay == rangeDay;
  }

  @override
  int get hashCode {
    return reloadTimeSeconds.hashCode ^
        showNotification.hashCode ^
        text.hashCode ^
        imgURL.hashCode ^
        showBegin.hashCode ^
        showEnd.hashCode ^
        chartBegin.hashCode ^
        chartEnd.hashCode ^
        rangeDay.hashCode;
  }
}
