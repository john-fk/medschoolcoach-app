import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/commercial.dart';
import 'package:Medschoolcoach/utils/api/models/progress.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';

List<Video> videoFromJson(String str) =>
    List<Video>.from(json.decode(str).map((dynamic x) => Video.fromJson(x)));

String videoToJson(List<Video> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class Video {
  String id;
  String sectionId;
  String subjectId;
  String topicId;
  String name;
  String description;
  String image;
  String length;
  int seconds;
  String whiteboardNotesUrl;
  bool hasLectureNotes;
  String providerType;
  String providerId;
  String link;
  String resolutionLink360;
  String resolutionLink540;
  String resolutionLink720;
  int order;
  DateTime createdAt;
  DateTime updatedAt;
  Progress progress;
  Section section;
  bool favourite;
  Commercial commercial;
  int flashcardsCount;
  int questionsCount;
  String srt;
  String srtUrl;

  Video({
    this.id,
    this.sectionId,
    this.subjectId,
    this.topicId,
    this.name,
    this.description,
    this.image,
    this.length,
    this.seconds,
    this.hasLectureNotes,
    this.whiteboardNotesUrl,
    this.providerType,
    this.providerId,
    this.link,
    this.resolutionLink360,
    this.resolutionLink540,
    this.resolutionLink720,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.progress,
    this.section,
    this.favourite,
    this.commercial,
    this.flashcardsCount,
    this.questionsCount,
    this.srt,
    this.srtUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"] == null ? null : json["id"],
        sectionId: json["section_id"] == null ? null : json["section_id"],
        subjectId: json["subject_id"] == null ? null : json["subject_id"],
        topicId: json["topic_id"] == null ? null : json["topic_id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        length: json["length"] == null ? null : json["length"],
        seconds: json["seconds"] == null ? null : json["seconds"],
        whiteboardNotesUrl: json["whiteboard_notes_url"] == null
            ? null
            : json["whiteboard_notes_url"],
        hasLectureNotes: json["has_lecture_notes"] == 0 ? false : true,
        providerType:
            json["provider_type"] == null ? null : json["provider_type"],
        providerId: json["provider_id"] == null ? null : json["provider_id"],
        link: json["link"] == null ? null : json["link"],
        resolutionLink360: json["resolution_link360"] == null
            ? null
            : json["resolution_link360"],
        resolutionLink540: json["resolution_link540"] == null
            ? null
            : json["resolution_link540"],
        resolutionLink720: json["resolution_link720"] == null
            ? null
            : json["resolution_link720"],
        order: json["order"] == null ? null : json["order"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        progress: json["progress"] == null
            ? null
            : Progress.fromJson(json["progress"]),
        section:
            json["section"] == null ? null : Section.fromJson(json["section"]),
        favourite: json["favorite"] == null ? null : json["favorite"],
        commercial: json["commercial"] == null
            ? null
            : Commercial.fromJson(json["commercial"]),
        flashcardsCount:
            json["flashcard_count"] == null ? null : json["flashcard_count"],
        questionsCount:
            json["question_count"] == null ? null : json["question_count"],
        srt: json["srt"] == null ? null : json["srt"],
        srtUrl: json["srt_url"] == null ? null : json["srt_url"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "section_id": sectionId == null ? null : sectionId,
        "subject_id": subjectId == null ? null : subjectId,
        "topic_id": topicId == null ? null : topicId,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "image": image == null ? null : image,
        "length": length == null ? null : length,
        "seconds": seconds == null ? null : seconds,
        "has_lecture_notes": hasLectureNotes == 0 ? false : true,
        "whiteboard_notes_url":
            whiteboardNotesUrl == null ? null : whiteboardNotesUrl,
        "provider_type": providerType == null ? null : providerType,
        "provider_id": providerId == null ? null : providerId,
        "link": link == null ? null : link,
        "resolution_link360":
            resolutionLink360 == null ? null : resolutionLink360,
        "resolution_link540":
            resolutionLink540 == null ? null : resolutionLink540,
        "resolution_link720":
            resolutionLink720 == null ? null : resolutionLink720,
        "order": order == null ? null : order,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "progress": progress == null ? null : progress.toJson(),
        "favorite": favourite == null ? null : favourite,
        "section": section == null ? null : section.toJson(),
        "flashcard_count": flashcardsCount == null ? null : flashcardsCount,
        "question_count": questionsCount == null ? null : questionsCount,
      };
}
