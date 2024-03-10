// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Configs {
  int? id;
  String? section;
  String? ip;
  String? mac;
  String? imageLink;
  int? doExercise;
  int? reloadSeconds;
  int? productionChart;
  String? productionChartBegin;
  int? productionChartDurationMinute;
  int? productionChartRangeDay;
  int? etsChart;
  String? etsMO;
  int? get getId => this.id;

  set setId(int? id) => this.id = id;

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

  get getReloadSeconds => this.reloadSeconds;

  set setReloadSeconds(reloadSeconds) => this.reloadSeconds = reloadSeconds;

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

  get getEtsMO => this.etsMO;

  set setEtsMO(etsMO) => this.etsMO = etsMO;
  Configs({
    this.id,
    this.section,
    this.ip,
    this.mac,
    this.imageLink,
    this.doExercise,
    this.reloadSeconds,
    this.productionChart,
    this.productionChartBegin,
    this.productionChartDurationMinute,
    this.productionChartRangeDay,
    this.etsChart,
    this.etsMO,
  });

  Configs copyWith({
    int? id,
    String? section,
    String? ip,
    String? mac,
    String? imageLink,
    int? doExercise,
    String? doExerciseTime,
    int? reloadSeconds,
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
      reloadSeconds: reloadSeconds ?? this.reloadSeconds,
      productionChart: productionChart ?? this.productionChart,
      productionChartBegin: productionChartBegin ?? this.productionChartBegin,
      productionChartDurationMinute:
          productionChartDurationMinute ?? this.productionChartDurationMinute,
      productionChartRangeDay:
          productionChartRangeDay ?? this.productionChartRangeDay,
      etsChart: etsChart ?? this.etsChart,
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
      'reloadSeconds': reloadSeconds,
      'productionChart': productionChart,
      'productionChartBegin': productionChartBegin,
      'productionChartDurationMinute': productionChartDurationMinute,
      'productionChartRangeDay': productionChartRangeDay,
      'etsChart': etsChart,
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
      reloadSeconds:
          map['reloadSeconds'] != null ? map['reloadSeconds'] as int : null,
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
      etsMO: map['etsMO'] != null ? map['etsMO'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Configs.fromJson(String source) =>
      Configs.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Configs(id: $id, section: $section, ip: $ip, mac: $mac, imageLink: $imageLink, doExercise: $doExercise, reloadSeconds: $reloadSeconds, productionChart: $productionChart, productionChartBegin: $productionChartBegin, productionChartDurationMinute: $productionChartDurationMinute, productionChartRangeDay: $productionChartRangeDay, etsChart: $etsChart, etsMO: $etsMO)';
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
        other.reloadSeconds == reloadSeconds &&
        other.productionChart == productionChart &&
        other.productionChartBegin == productionChartBegin &&
        other.productionChartDurationMinute == productionChartDurationMinute &&
        other.productionChartRangeDay == productionChartRangeDay &&
        other.etsChart == etsChart &&
        other.etsMO == etsMO;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        section.hashCode ^
        ip.hashCode ^
        mac.hashCode ^
        imageLink.hashCode ^
        doExercise.hashCode ^
        reloadSeconds.hashCode ^
        productionChart.hashCode ^
        productionChartBegin.hashCode ^
        productionChartDurationMinute.hashCode ^
        productionChartRangeDay.hashCode ^
        etsChart.hashCode ^
        etsMO.hashCode;
  }
}
