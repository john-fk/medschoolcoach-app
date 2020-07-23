import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/video.dart';

DashboardSchedule scheduleDashboardFromJson(String str) =>
    DashboardSchedule.fromJson(json.decode(str));

String scheduleDashboardToJson(DashboardSchedule data) =>
    json.encode(data.toJson());

class DashboardSchedule {
  DashboardSchedule({
    this.today,
    this.days,
    this.items,
  });

  int today;
  int days;
  List<Video> items;

  factory DashboardSchedule.fromJson(Map<String, dynamic> json) =>
      DashboardSchedule(
        today: json["today"] == null ? null : json["today"],
        days: json["days"] == null ? null : json["days"],
        items: json["items"] == null
            ? null
            : List<Video>.from(
                json["items"].map((dynamic x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "today": today == null ? null : today,
        "days": days == null ? null : days,
        "items": items == null
            ? null
            : List<dynamic>.from(items.map<dynamic>((dynamic x) => x.toJson())),
      };
}
