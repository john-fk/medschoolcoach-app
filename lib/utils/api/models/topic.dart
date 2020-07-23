import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/video.dart';

class Topic {
  String id;
  String subjectId;
  String name;
  int order;
  DateTime createdAt;
  DateTime updatedAt;
  int percentage;
  List<Video> videos;

  Topic({
    this.id,
    this.subjectId,
    this.name,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.percentage,
    this.videos,
  });

  factory Topic.fromRawJson(String str) => Topic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["id"],
        subjectId: json["subject_id"],
        name: json["name"],
        order: json["order"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        percentage: json["percentage"] == null ? null : json["percentage"],
        videos: json["videos"] == null
            ? null
            : List<Video>.from(
                json["videos"].map((dynamic x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "subject_id": subjectId,
        "name": name,
        "order": order,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "percentage": percentage == null ? null : percentage,
      };
}
