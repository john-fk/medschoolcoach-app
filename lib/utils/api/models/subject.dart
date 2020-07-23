import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/topic.dart';

class Subject {
  String id;
  String sectionId;
  String name;
  int order;
  DateTime createdAt;
  DateTime updatedAt;
  int percentage;
  List<Topic> topics;
  int amountOfQuestions;
  int amountOfNewQuestions;
  int amountOfFlashcards;

  Subject({
    this.id,
    this.sectionId,
    this.name,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.topics,
    this.percentage,
    this.amountOfQuestions,
    this.amountOfNewQuestions,
    this.amountOfFlashcards,
  });

  factory Subject.fromRawJson(String str) => Subject.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json["id"],
        sectionId: json["section_id"],
        name: json["name"],
        order: json["order"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        topics: json["topics"] == null
            ? List<Topic>()
            : List<Topic>.from(
                json["topics"].map((dynamic x) => Topic.fromJson(x))),
        percentage: json["percentage"] == null ? null : json["percentage"],
        amountOfQuestions: json["amount_of_questions"] == null
            ? null
            : json["amount_of_questions"],
        amountOfNewQuestions: json["amount_of_new_questions"] == null
            ? null
            : json["amount_of_new_questions"],
        amountOfFlashcards: json["amount_of_flashcards"] == null
            ? null
            : json["amount_of_flashcards"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "section_id": sectionId,
        "name": name,
        "order": order,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "topics": List<dynamic>.from(topics.map<dynamic>((x) => x.toJson())),
        "percentage": percentage == null ? null : percentage,
        "amount_of_questions":
            amountOfQuestions == null ? null : amountOfQuestions,
        "amount_of_new_questions":
            amountOfNewQuestions == null ? null : amountOfNewQuestions,
        "amount_of_flashcards":
            amountOfFlashcards == null ? null : amountOfFlashcards,
      };
}
