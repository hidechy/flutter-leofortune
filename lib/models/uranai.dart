// To parse this JSON data, do
//
//     final uranai = uranaiFromJson(jsonString);

import 'dart:convert';

Uranai uranaiFromJson(String str) => Uranai.fromJson(json.decode(str));

String uranaiToJson(Uranai data) => json.encode(data.toJson());

class Uranai {
  Uranai({
    this.data,
  });

  List<Datum> data;

  factory Uranai.fromJson(Map<String, dynamic> json) => Uranai(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.date,
    this.totalTitle,
    this.totalDescription,
    this.totalPoint,
    this.loveDescription,
    this.lovePoint,
    this.moneyDescription,
    this.moneyPoint,
    this.workDescription,
    this.workPoint,
    this.sachikoiRank,
    this.sachikoiLove,
    this.sachikoiMoney,
    this.sachikoiWork,
    this.sachikoiMan,
  });

  DateTime date;
  String totalTitle;
  String totalDescription;
  String totalPoint;
  String loveDescription;
  String lovePoint;
  String moneyDescription;
  String moneyPoint;
  String workDescription;
  String workPoint;
  String sachikoiRank;
  String sachikoiLove;
  String sachikoiMoney;
  String sachikoiWork;
  String sachikoiMan;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: DateTime.parse(json["date"]),
        totalTitle: json["total_title"],
        totalDescription: json["total_description"],
        totalPoint: json["total_point"],
        loveDescription: json["love_description"],
        lovePoint: json["love_point"],
        moneyDescription: json["money_description"],
        moneyPoint: json["money_point"],
        workDescription: json["work_description"],
        workPoint: json["work_point"],
        sachikoiRank: json["sachikoi_rank"],
        sachikoiLove: json["sachikoi_love"],
        sachikoiMoney: json["sachikoi_money"],
        sachikoiWork: json["sachikoi_work"],
        sachikoiMan: json["sachikoi_man"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "total_title": totalTitle,
        "total_description": totalDescription,
        "total_point": totalPoint,
        "love_description": loveDescription,
        "love_point": lovePoint,
        "money_description": moneyDescription,
        "money_point": moneyPoint,
        "work_description": workDescription,
        "work_point": workPoint,
        "sachikoi_rank": sachikoiRank,
        "sachikoi_love": sachikoiLove,
        "sachikoi_money": sachikoiMoney,
        "sachikoi_work": sachikoiWork,
        "sachikoi_man": sachikoiMan,
      };
}
