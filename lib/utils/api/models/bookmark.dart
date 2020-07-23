import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/video.dart';

List<Bookmark> bookmarkFromJson(String str) => List<Bookmark>.from(
    json.decode(str).map((dynamic x) => Bookmark.fromJson(x)));

String bookmarkToJson(List<Bookmark> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class Bookmark {
  String id;
  String sectionId;
  String name;
  int order;
  DateTime createdAt;
  DateTime updatedAt;
  List<Video> videos;

  Bookmark({
    this.id,
    this.sectionId,
    this.name,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.videos,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json["id"] == null ? null : json["id"],
        sectionId: json["section_id"] == null ? null : json["section_id"],
        name: json["name"] == null ? null : json["name"],
        order: json["order"] == null ? null : json["order"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        videos: json["videos"] == null
            ? null
            : List<Video>.from(
                json["videos"].map((dynamic x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "section_id": sectionId == null ? null : sectionId,
        "name": name == null ? null : name,
        "order": order == null ? null : order,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "videos": videos == null
            ? null
            : List<dynamic>.from(videos.map<dynamic>((x) => x.toJson())),
      };
}
