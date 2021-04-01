import 'dart:convert';

// Map<String, dynamic> scheduleProgressFromJson(String str) =>
//     Map<String, dynamic>.from(json.decode(str)).map<String, dynamic>(
//       (String k, dynamic v) => MapEntry<String, dynamic>(k, v),
//     );

ScheduleProgress scheduleProgressObjectFromJson(String str) =>
    ScheduleProgress.fromJson(json.decode(str));

class ScheduleProgress {
  Map<String, dynamic> list;
  int currentDay;
  int daysLeft;

  ScheduleProgress({
    this.list,
    this.currentDay,
    this.daysLeft
  });

  factory ScheduleProgress.fromJson(Map<String, dynamic> json) =>
      ScheduleProgress(
        list: json["list"] == null
            ? null
            : Map<String, dynamic>.from(json["list"]).map<String, dynamic>(
                (String k, dynamic v) => MapEntry<String, int>(k, v)),
        currentDay: json["current_day"] == null ? null : json["current_day"],
        daysLeft: json["days_left"]
      );
}
