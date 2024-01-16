import 'dart:convert';

class Configs {
  int? id;
  String? section;
  String? ip;
  String? mac;
  String? imageLink;
  int? doExercise;
  String? doExerciseTime;
  int? reloadSeconds;
  int? notification;
  String? notificationLink;
  String? notificationBegin;
  int? notificationDurationMinute;
  int? productionChart;
  String? productionChartBegin;
  int? productionChartDurationMinute;
  int? productionChartRangeDay;
  int? etsChart;
  String? etsChartBegin;
  int? etsChartDurationMinute;
  String? etsMO;
  Configs({
    this.id,
    this.section,
    this.ip,
    this.mac,
    this.imageLink,
    this.doExercise,
    this.doExerciseTime,
    this.reloadSeconds,
    this.notification,
    this.notificationLink,
    this.notificationBegin,
    this.notificationDurationMinute,
    this.productionChart,
    this.productionChartBegin,
    this.productionChartDurationMinute,
    this.productionChartRangeDay,
    this.etsChart,
    this.etsChartBegin,
    this.etsChartDurationMinute,
    this.etsMO,
  });
  get getId => this.id;

  set setId(id) => this.id = id;

  get getSection => this.section;

  set setSection(section) => this.section = section;

  get getIp => this.ip;

  set setIp(ip) => this.ip = ip;

  get getMac => this.mac;

  set setMac(mac) => this.mac = mac;

  get getImageLink => this.imageLink;

  set setImageLink(imageLink) => this.imageLink = imageLink;

  get getDoExercise => this.doExercise;

  set setDoExercise(doExercise) => this.doExercise = doExercise;

  get getDoExerciseTime => this.doExerciseTime;

  set setDoExerciseTime(doExerciseTime) => this.doExerciseTime = doExerciseTime;

  get getReloadSeconds => this.reloadSeconds;

  set setReloadSeconds(reloadSeconds) => this.reloadSeconds = reloadSeconds;

  get getNotification => this.notification;

  set setNotification(notification) => this.notification = notification;

  get getNotificationLink => this.notificationLink;

  set setNotificationLink(notificationLink) =>
      this.notificationLink = notificationLink;

  get getNotificationBegin => this.notificationBegin;

  set setNotificationBegin(notificationBegin) =>
      this.notificationBegin = notificationBegin;

  get getNotificationDurationMinute => this.notificationDurationMinute;

  set setNotificationDurationMinute(notificationDurationMinute) =>
      this.notificationDurationMinute = notificationDurationMinute;

  get getProductionChart => this.productionChart;

  set setProductionChart(productionChart) =>
      this.productionChart = productionChart;

  get getProductionChartBegin => this.productionChartBegin;

  set setProductionChartBegin(productionChartBegin) =>
      this.productionChartBegin = productionChartBegin;

  get getProductionChartDurationMinute => this.productionChartDurationMinute;

  set setProductionChartDurationMinute(productionChartDurationMinute) =>
      this.productionChartDurationMinute = productionChartDurationMinute;

  get getProductionChartRangeDay => this.productionChartRangeDay;

  set setProductionChartRangeDay(productionChartRangeDay) =>
      this.productionChartRangeDay = productionChartRangeDay;

  get getEtsChart => this.etsChart;

  set setEtsChart(etsChart) => this.etsChart = etsChart;

  get getEtsChartBegin => this.etsChartBegin;

  set setEtsChartBegin(etsChartBegin) => this.etsChartBegin = etsChartBegin;

  get getEtsChartDurationMinute => this.etsChartDurationMinute;

  set setEtsChartDurationMinute(etsChartDurationMinute) =>
      this.etsChartDurationMinute = etsChartDurationMinute;

  get getEtsMO => this.etsMO;

  set setEtsMO(etsMO) => this.etsMO = etsMO;

  Configs copyWith({
    int? id,
    String? section,
    String? ip,
    String? mac,
    String? imageLink,
    int? doExercise,
    String? doExerciseTime,
    int? reloadSeconds,
    int? notification,
    String? notificationLink,
    String? notificationBegin,
    int? notificationDurationMinute,
    int? productionChart,
    String? productionChartBegin,
    int? productionChartDurationMinute,
    int? productionChartRangeDay,
    int? etsChart,
    String? etsChartBegin,
    int? etsChartDurationMinute,
    String? etsMO,
  }) {
    return Configs(
      id: id ?? this.id,
      section: section ?? this.section,
      ip: ip ?? this.ip,
      mac: mac ?? this.mac,
      imageLink: imageLink ?? this.imageLink,
      doExercise: doExercise ?? this.doExercise,
      doExerciseTime: doExerciseTime ?? this.doExerciseTime,
      reloadSeconds: reloadSeconds ?? this.reloadSeconds,
      notification: notification ?? this.notification,
      notificationLink: notificationLink ?? this.notificationLink,
      notificationBegin: notificationBegin ?? this.notificationBegin,
      notificationDurationMinute:
          notificationDurationMinute ?? this.notificationDurationMinute,
      productionChart: productionChart ?? this.productionChart,
      productionChartBegin: productionChartBegin ?? this.productionChartBegin,
      productionChartDurationMinute:
          productionChartDurationMinute ?? this.productionChartDurationMinute,
      productionChartRangeDay:
          productionChartRangeDay ?? this.productionChartRangeDay,
      etsChart: etsChart ?? this.etsChart,
      etsChartBegin: etsChartBegin ?? this.etsChartBegin,
      etsChartDurationMinute:
          etsChartDurationMinute ?? this.etsChartDurationMinute,
      etsMO: etsMO ?? this.etsMO,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'section': section,
      'ip': ip,
      'mac': mac,
      'imageLink': imageLink,
      'doExercise': doExercise,
      'doExerciseTime': doExerciseTime,
      'reloadSeconds': reloadSeconds,
      'notification': notification,
      'notificationLink': notificationLink,
      'notificationBegin': notificationBegin,
      'notificationDurationMinute': notificationDurationMinute,
      'productionChart': productionChart,
      'productionChartBegin': productionChartBegin,
      'productionChartDurationMinute': productionChartDurationMinute,
      'productionChartRangeDay': productionChartRangeDay,
      'etsChart': etsChart,
      'etsChartBegin': etsChartBegin,
      'etsChartDurationMinute': etsChartDurationMinute,
      'etsMO': etsMO,
    };
  }

  factory Configs.fromMap(Map<String, dynamic> map) {
    return Configs(
      id: map['id'] != null ? map['id'] as int : null,
      section: map['section'] != null ? map['section'] as String : null,
      ip: map['ip'] != null ? map['ip'] as String : null,
      mac: map['mac'] != null ? map['mac'] as String : null,
      imageLink: map['imageLink'] != null ? map['imageLink'] as String : null,
      doExercise: map['doExercise'] != null ? map['doExercise'] as int : null,
      doExerciseTime: map['doExerciseTime'] != null
          ? map['doExerciseTime'] as String
          : null,
      reloadSeconds:
          map['reloadSeconds'] != null ? map['reloadSeconds'] as int : null,
      notification:
          map['notification'] != null ? map['notification'] as int : null,
      notificationLink: map['notificationLink'] != null
          ? map['notificationLink'] as String
          : null,
      notificationBegin: map['notificationBegin'] != null
          ? map['notificationBegin'] as String
          : null,
      notificationDurationMinute: map['notificationDurationMinute'] != null
          ? map['notificationDurationMinute'] as int
          : null,
      productionChart:
          map['productionChart'] != null ? map['productionChart'] as int : null,
      productionChartBegin: map['productionChartBegin'] != null
          ? map['productionChartBegin'] as String
          : null,
      productionChartDurationMinute:
          map['productionChartDurationMinute'] != null
              ? map['productionChartDurationMinute'] as int
              : null,
      productionChartRangeDay: map['productionChartRangeDay'] != null
          ? map['productionChartRangeDay'] as int
          : null,
      etsChart: map['etsChart'] != null ? map['etsChart'] as int : null,
      etsChartBegin:
          map['etsChartBegin'] != null ? map['etsChartBegin'] as String : null,
      etsChartDurationMinute: map['etsChartDurationMinute'] != null
          ? map['etsChartDurationMinute'] as int
          : null,
      etsMO: map['etsMO'] != null ? map['etsMO'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Configs.fromJson(String source) =>
      Configs.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Configs(id: $id, section: $section, ip: $ip, mac: $mac, imageLink: $imageLink, doExercise: $doExercise, doExerciseTime: $doExerciseTime, reloadSeconds: $reloadSeconds, notification: $notification, notificationLink: $notificationLink, notificationBegin: $notificationBegin, notificationDurationMinute: $notificationDurationMinute, productionChart: $productionChart, productionChartBegin: $productionChartBegin, productionChartDurationMinute: $productionChartDurationMinute, productionChartRangeDay: $productionChartRangeDay, etsChart: $etsChart, etsChartBegin: $etsChartBegin, etsChartDurationMinute: $etsChartDurationMinute, etsMO: $etsMO)';
  }

  @override
  bool operator ==(covariant Configs other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.section == section &&
        other.ip == ip &&
        other.mac == mac &&
        other.imageLink == imageLink &&
        other.doExercise == doExercise &&
        other.doExerciseTime == doExerciseTime &&
        other.reloadSeconds == reloadSeconds &&
        other.notification == notification &&
        other.notificationLink == notificationLink &&
        other.notificationBegin == notificationBegin &&
        other.notificationDurationMinute == notificationDurationMinute &&
        other.productionChart == productionChart &&
        other.productionChartBegin == productionChartBegin &&
        other.productionChartDurationMinute == productionChartDurationMinute &&
        other.productionChartRangeDay == productionChartRangeDay &&
        other.etsChart == etsChart &&
        other.etsChartBegin == etsChartBegin &&
        other.etsChartDurationMinute == etsChartDurationMinute &&
        other.etsMO == etsMO;
  }
}
