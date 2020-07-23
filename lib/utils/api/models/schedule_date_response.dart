import 'dart:convert';

ScheduleDateResponse scheduleDateResponseFromJson(String str) =>
    ScheduleDateResponse.fromJson(json.decode(str));

String scheduleDateResponseToJson(ScheduleDateResponse data) =>
    json.encode(data.toJson());

class ScheduleDateResponse {
  String length;
  DateTime endDate;

  ScheduleDateResponse({
    this.length,
    this.endDate,
  });

  factory ScheduleDateResponse.fromJson(Map<String, dynamic> json) =>
      ScheduleDateResponse(
        length: json["length"] == null ? null : json["length"],
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "length": length == null ? null : length,
        "end_date": endDate == null
            ? null
            : "${endDate.year.toString().padLeft(4, '0')}-"
                "${endDate.month.toString().padLeft(2, '0')}-"
                "${endDate.day.toString().padLeft(2, '0')}",
      };
}
