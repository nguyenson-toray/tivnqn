import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqlMK026 {
  int GxNo;
  String GxName;
  String CardColor;
  get getGxNo => this.GxNo;

  set setGxNo(GxNo) => this.GxNo = GxNo;

  get getGxName => this.GxName;

  set setGxName(GxName) => this.GxName = GxName;

  get getCardColor => this.CardColor;

  set setCardColor(CardColor) => this.CardColor = CardColor;

  SqlMK026({
    required this.GxNo,
    required this.GxName,
    required this.CardColor,
  });

  @override
  String toString() =>
      'SqlMK026(GxNo: $GxNo, GxName: $GxName, CardColor: $CardColor)';
}
