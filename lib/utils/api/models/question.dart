import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/section.dart';

QuestionList questionListFromJson(String str) =>
    QuestionList.fromJson(json.decode(str));

String questionListToJson(QuestionList data) => json.encode(data.toJson());

List<Question> questionOfDayFromJson(String str) => List<Question>.from(
    json.decode(str)['items'].map((dynamic x) => Question.fromJson(x)));

List<Question> questionFromJson(String str) => List<Question>.from(
    json.decode(str).map((dynamic x) => Question.fromJson(x)));

String questionToJson(List<Question> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class QuestionList {
  List<Question> items;
  int limit;
  int offset;
  int total;

  QuestionList({this.items, this.limit, this.offset, this.total});

  factory QuestionList.fromJson(Map<String, dynamic> json) => QuestionList(
        items: json["items"] == null
            ? null
            : List<Question>.from(
                json["items"].map((dynamic x) => Question.fromJson(x))),
        limit: json['limit'],
        offset: json['offset'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "items": items == null
            ? null
            : List<dynamic>.from(items.map<dynamic>((dynamic x) => x.toJson())),
      };
}

class Question {
  String id;
  String sectionId;
  String subjectId;
  String topicId;
  String videoId;
  int number;
  String stem;
  String choiceA;
  String choiceB;
  String choiceC;
  String choiceD;
  String answer;
  String explanation;
  String editor;
  String formating;
  String comments;
  dynamic submittedAt;
  dynamic approvedAt;
  int order;
  DateTime createdAt;
  DateTime updatedAt;
  int isCorrect;
  Section section;
  bool favorite;
  String yourAnswer;
  QuestionStats stats;

  Question({
    this.id,
    this.sectionId,
    this.subjectId,
    this.topicId,
    this.videoId,
    this.number,
    this.stem,
    this.choiceA,
    this.choiceB,
    this.choiceC,
    this.choiceD,
    this.answer,
    this.explanation,
    this.editor,
    this.formating,
    this.comments,
    this.submittedAt,
    this.approvedAt,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.isCorrect,
    this.section,
    this.favorite,
    this.yourAnswer,
    this.stats,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"] == null ? null : json["id"],
        sectionId: json["section_id"] == null ? null : json["section_id"],
        subjectId: json["subject_id"] == null ? null : json["subject_id"],
        topicId: json["topic_id"] == null ? null : json["topic_id"],
        videoId: json["video_id"] == null ? null : json["video_id"],
        number: json["number"] == null ? null : json["number"],
        stem: json["html_stem"] == null ? null : json["html_stem"],
        choiceA: json["html_choice_a"].toString().isEmpty
            ? json["choice_a"]
            : json["html_choice_a"],
        choiceB: json["html_choice_b"].toString().isEmpty
            ? json["choice_b"]
            : json["html_choice_b"],
        choiceC: json["html_choice_c"].toString().isEmpty
            ? json["choice_c"]
            : json["html_choice_c"],
        choiceD: json["html_choice_d"].toString().isEmpty
            ? json["choice_d"]
            : json["html_choice_d"],
        answer: json["answer"] == null ? null : json["answer"],
        explanation: json["html_explanation"].toString().isEmpty
            ? json["explanation"]
            : json["html_explanation"],
        editor: json["editor"] == null ? null : json["editor"],
        formating: json["formating"] == null ? null : json["formating"],
        comments: json["comments"] == null ? null : json["comments"],
        submittedAt: json["submitted_at"],
        approvedAt: json["approved_at"],
        order: json["order"] == null ? null : json["order"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isCorrect: json["is_correct"] == null ? null : json["is_correct"],
        section:
            json["section"] == null ? null : Section.fromJson(json["section"]),
        favorite: json["favorite"] == null ? null : json["favorite"],
        yourAnswer: json["your_answer"] == null ? null : json["your_answer"],
        stats: json["stats"] == null
            ? null
            : QuestionStats.fromJson(json["stats"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "section_id": sectionId == null ? null : sectionId,
        "subject_id": subjectId == null ? null : subjectId,
        "topic_id": topicId == null ? null : topicId,
        "video_id": videoId == null ? null : videoId,
        "number": number == null ? null : number,
        "html_stem": stem == null ? null : stem,
        "html_choice_a": choiceA == null ? null : choiceA,
        "html_choice_b": choiceB == null ? null : choiceB,
        "html_choice_c": choiceC == null ? null : choiceC,
        "html_choice_d": choiceD == null ? null : choiceD,
        "answer": answer == null ? null : answer,
        "html_explanation": explanation == null ? null : explanation,
        "editor": editor == null ? null : editor,
        "formating": formating == null ? null : formating,
        "comments": comments == null ? null : comments,
        "submitted_at": submittedAt,
        "approved_at": approvedAt,
        "order": order == null ? null : order,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "is_correct": isCorrect == null ? null : isCorrect,
        "section": section == null ? null : section.toJson(),
        "favorite": favorite == null ? null : favorite,
        "your_answer": yourAnswer == null ? null : yourAnswer,
        "stats": stats == null ? null : stats.toJson(),
      };
}

class QuestionStats {
  int usersAnsweredCorrect;
  int usersAnsweredIncorrect;

  QuestionStats({
    this.usersAnsweredCorrect,
    this.usersAnsweredIncorrect,
  });

  factory QuestionStats.fromJson(Map<String, dynamic> json) => QuestionStats(
        usersAnsweredCorrect: json["users_answered_correct"] == null
            ? null
            : json["users_answered_correct"],
        usersAnsweredIncorrect: json["users_answered_incorrect"] == null
            ? null
            : json["users_answered_incorrect"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "users_answered_correct":
            usersAnsweredCorrect == null ? null : usersAnsweredCorrect,
        "users_answered_incorrect":
            usersAnsweredIncorrect == null ? null : usersAnsweredIncorrect,
      };
}
