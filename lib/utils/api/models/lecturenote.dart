import 'dart:convert';

class LectureNote {
  String id;
  String videoId;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  LectureNote({
    this.id,
    this.videoId,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory LectureNote.fromRawJson(String str) => LectureNote.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LectureNote.fromJson(Map<String, dynamic> json) => LectureNote(
    id: json["id"],
    videoId: json["video_id"],
    content: json["content"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "video_id": videoId,
    "content": content,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
