import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/progress.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';

LastWatchedResponse lastWatchedResponseFromJson(String str) =>
    LastWatchedResponse.fromJson(json.decode(str));

String lastWatchedResponseToJson(LastWatchedResponse data) =>
    json.encode(data.toJson());

class LastWatchedResponse {
  String id;
  String sectionId;
  String subjectId;
  String topicId;
  String name;
  String keywords;
  String description;
  String image;
  String length;
  int seconds;
  String notes;
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
  Subject subject;
  Topic topic;

  LastWatchedResponse({
    this.id,
    this.sectionId,
    this.subjectId,
    this.topicId,
    this.name,
    this.keywords,
    this.description,
    this.image,
    this.length,
    this.seconds,
    this.notes,
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
    this.subject,
    this.topic,
  });

  factory LastWatchedResponse.fromJson(Map<String, dynamic> json) =>
      LastWatchedResponse(
        id: json["id"] == null ? null : json["id"],
        sectionId: json["section_id"] == null ? null : json["section_id"],
        subjectId: json["subject_id"] == null ? null : json["subject_id"],
        topicId: json["topic_id"] == null ? null : json["topic_id"],
        name: json["name"] == null ? null : json["name"],
        keywords: json["keywords"] == null ? null : json["keywords"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        length: json["length"] == null ? null : json["length"],
        seconds: json["seconds"] == null ? null : json["seconds"],
        notes: json["notes"] == null ? null : json["notes"],
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
        subject:
            json["subject"] == null ? null : Subject.fromJson(json["subject"]),
        topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "section_id": sectionId == null ? null : sectionId,
        "subject_id": subjectId == null ? null : subjectId,
        "topic_id": topicId == null ? null : topicId,
        "name": name == null ? null : name,
        "keywords": keywords == null ? null : keywords,
        "description": description == null ? null : description,
        "image": image == null ? null : image,
        "length": length == null ? null : length,
        "seconds": seconds == null ? null : seconds,
        "notes": notes == null ? null : notes,
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
        "section": section == null ? null : section.toJson(),
        "subject": subject == null ? null : subject.toJson(),
        "topic": topic == null ? null : topic.toJson(),
      };
}
