import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/ui/flash_card/card/flash.dart';

String flashcardStatusToString(FlashcardStatus status) {
  return status.toString().substring(16).toLowerCase();
}

FlashcardStatus getFlashcardStatusEnum(String status) {
  switch (status.toLowerCase()) {
    case "new":
      return FlashcardStatus.New;
    case "seen":
      return FlashcardStatus.Seen;
    case "positive":
      return FlashcardStatus.Positive;
    case "neutral":
      return FlashcardStatus.Neutral;
    case "negative":
      return FlashcardStatus.Negative;
    default:
      throw Exception("Unknown flashcard status value ($status)");
  }
}

class FlashcardModel {
  String id;
  String sectionId;
  String subjectId;
  String topicId;
  String videoId;
  String front;
  String definition;
  String example;
  String frontImage;
  String definitionImage;
  String exampleImage;
  int order;
  DateTime createdAt;
  DateTime updatedAt;
  FlashcardStatus status;
  Section section;

  FlashcardModel({
    this.id,
    this.sectionId,
    this.subjectId,
    this.topicId,
    this.videoId,
    this.front,
    this.definition,
    this.example,
    this.frontImage,
    this.definitionImage,
    this.exampleImage,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.section,
  });

  factory FlashcardModel.fromRawJson(String str) =>
      FlashcardModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlashcardModel.fromJson(Map<String, dynamic> json) => FlashcardModel(
        id: json["id"] == null ? null : json["id"],
        sectionId: json["section_id"] == null ? null : json["section_id"],
        subjectId: json["subject_id"] == null ? null : json["subject_id"],
        topicId: json["topic_id"] == null ? null : json["topic_id"],
        videoId: json["video_id"] == null ? null : json["video_id"],
        front: json["html_front"] == null ? null : json["html_front"],
        definition:
            json["html_definition"] == null ? null : json["html_definition"],
        example: json["html_example"] == null ? null : json["html_example"],
        frontImage: json["front_image"] == null ? null : json["front_image"],
        definitionImage:
            json["definition_image"] == null ? null : json["definition_image"],
        exampleImage:
            json["example_image"] == null ? null : json["example_image"],
        order: json["order"] == null ? null : json["order"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        status: json["status"] == null
            ? null
            : getFlashcardStatusEnum(json["status"]),
        section:
            json["section"] == null ? null : Section.fromJson(json["section"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "section_id": sectionId == null ? null : sectionId,
        "subject_id": subjectId == null ? null : subjectId,
        "topic_id": topicId == null ? null : topicId,
        "video_id": videoId == null ? null : videoId,
        "html_front": front == null ? null : front,
        "html_definition": definition == null ? null : definition,
        "html_example": example == null ? null : example,
        "order": order == null ? null : order,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "status": flashcardStatusToString(status),
        "section": section == null ? null : section.toJson(),
      };
}
